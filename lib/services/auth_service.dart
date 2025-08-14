import 'dart:convert';
import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Initialize auth state from storage
  Future<void> init() async {
    try {
      final token = await StorageService.getToken();
      if (token != null) {
        _apiService.setToken(token);
        final userData = await StorageService.getUser();
        if (userData != null) {
          _currentUser = User.fromJson(jsonDecode(userData));
        } else {
          // Try to fetch user data from API
          await _fetchCurrentUser();
        }
      }
    } catch (e) {
      // If there's an error, clear the stored data
      await logout();
    }
  }

  // Login
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      
      if (response['token'] != null) {
        final token = response['token'];
        _apiService.setToken(token);
        await StorageService.saveToken(token);

        // Get user data
        if (response['user'] != null) {
          _currentUser = User.fromJson(response['user']);
          await StorageService.saveUser(jsonEncode(_currentUser!.toJson()));
        } else {
          await _fetchCurrentUser();
        }

        return _currentUser!;
      } else {
        throw Exception('Login failed: No token received');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Register
  Future<User> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final response = await _apiService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      // After successful registration, attempt to login
      return await login(email, password);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    _apiService.clearToken();
    await StorageService.clearToken();
    await StorageService.clearUser();
    await StorageService.clearCache();
  }

  // Fetch current user from API
  Future<void> _fetchCurrentUser() async {
    try {
      _currentUser = await _apiService.getCurrentUser();
      await StorageService.saveUser(jsonEncode(_currentUser!.toJson()));
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }

  // Update user profile
  Future<User> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
  }) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phone != null) data['phone'] = phone;
      if (address != null) data['address'] = address;

      _currentUser = await _apiService.updateUser(_currentUser!.id, data);
      await StorageService.saveUser(jsonEncode(_currentUser!.toJson()));

      return _currentUser!;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Validate token
  Future<bool> validateToken() async {
    try {
      await _fetchCurrentUser();
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  }
}
