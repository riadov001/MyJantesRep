import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/service.dart';
import '../models/reservation.dart';
import '../models/quote.dart';
import '../models/user.dart';
import 'storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String _baseUrl = AppConstants.baseUrl;
  String? _token;

  // Initialize token from storage
  Future<void> init() async {
    _token = await StorageService.getToken();
  }

  // Get headers with authentication
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  // Set token
  void setToken(String token) {
    _token = token;
  }

  // Clear token
  void clearToken() {
    _token = null;
  }

  // Generic HTTP methods
  Future<Map<String, dynamic>> _get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> _put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> _delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        'API Error: ${response.statusCode} - ${response.body}',
        statusCode: response.statusCode,
      );
    }
  }

  // Auth API
  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = {
      'username': email,
      'password': password,
    };
    return await _post(AppConstants.loginEndpoint, data);
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    final data = {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
    };
    return await _post(AppConstants.usersEndpoint, data);
  }

  // Services API
  Future<List<Service>> getServices() async {
    try {
      final response = await _get(AppConstants.servicesEndpoint);
      if (response.containsKey('data')) {
        final servicesData = List<Map<String, dynamic>>.from(response['data']);
        return servicesData.map((json) => Service.fromJson(json)).toList();
      }
      return Service.getDefaultServices(); // Fallback to static data
    } catch (e) {
      // If API fails, return static services data
      return Service.getDefaultServices();
    }
  }

  Future<Service?> getService(String id) async {
    try {
      final response = await _get('${AppConstants.servicesEndpoint}/$id');
      return Service.fromJson(response);
    } catch (e) {
      // Fallback to static data
      return Service.getDefaultServices().firstWhere(
        (service) => service.id == id,
        orElse: () => Service.getDefaultServices().first,
      );
    }
  }

  // Reservations API
  Future<List<Reservation>> getReservations() async {
    final response = await _get(AppConstants.reservationsEndpoint);
    final reservationsData = List<Map<String, dynamic>>.from(response['data'] ?? []);
    return reservationsData.map((json) => Reservation.fromJson(json)).toList();
  }

  Future<Reservation> createReservation({
    required String serviceId,
    required DateTime dateTime,
    String? notes,
    String? vehicleInfo,
    List<String>? imageUrls,
  }) async {
    final data = {
      'service_id': serviceId,
      'date_time': dateTime.toIso8601String(),
      'notes': notes,
      'vehicle_info': vehicleInfo,
      'image_urls': imageUrls,
      'status': 'pending',
    };
    final response = await _post(AppConstants.reservationsEndpoint, data);
    return Reservation.fromJson(response);
  }

  Future<Reservation> updateReservation(String id, Map<String, dynamic> data) async {
    final response = await _put('${AppConstants.reservationsEndpoint}/$id', data);
    return Reservation.fromJson(response);
  }

  Future<void> cancelReservation(String id) async {
    await _put('${AppConstants.reservationsEndpoint}/$id', {'status': 'cancelled'});
  }

  // Quotes API
  Future<List<Quote>> getQuotes() async {
    final response = await _get(AppConstants.quotesEndpoint);
    final quotesData = List<Map<String, dynamic>>.from(response['data'] ?? []);
    return quotesData.map((json) => Quote.fromJson(json)).toList();
  }

  Future<Quote> createQuote({
    required String serviceId,
    required String vehicleMake,
    required String vehicleModel,
    required String vehicleYear,
    required String wheelSize,
    required String description,
    required List<String> imageUrls,
  }) async {
    final data = {
      'service_id': serviceId,
      'vehicle_make': vehicleMake,
      'vehicle_model': vehicleModel,
      'vehicle_year': vehicleYear,
      'wheel_size': wheelSize,
      'description': description,
      'image_urls': imageUrls,
      'status': 'pending',
    };
    final response = await _post(AppConstants.quotesEndpoint, data);
    return Quote.fromJson(response);
  }

  // User API
  Future<User> getCurrentUser() async {
    final response = await _get('${AppConstants.usersEndpoint}/me');
    return User.fromJson(response);
  }

  Future<User> updateUser(String id, Map<String, dynamic> data) async {
    final response = await _put('${AppConstants.usersEndpoint}/$id', data);
    return User.fromJson(response);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message';
}
