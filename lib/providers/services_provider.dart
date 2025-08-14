import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/service.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ServicesProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Service> _services = [];
  bool _isLoading = false;
  String? _error;

  List<Service> get services => _services;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get services with caching
  Future<void> loadServices({bool forceRefresh = false}) async {
    if (_services.isNotEmpty && !forceRefresh) return;

    _setLoading(true);
    _error = null;

    try {
      // Try to load from cache first
      if (!forceRefresh) {
        final cachedData = await StorageService.getServicesCache();
        if (cachedData != null) {
          final servicesData = jsonDecode(cachedData) as List;
          _services = servicesData
              .map((json) => Service.fromJson(json))
              .toList();
          notifyListeners();
          return;
        }
      }

      // Load from API
      _services = await _apiService.getServices();
      
      // Cache the data
      final servicesJson = _services.map((s) => s.toJson()).toList();
      await StorageService.saveServicesCache(jsonEncode(servicesJson));
      
    } catch (e) {
      _error = e.toString();
      // Fallback to default services if API fails
      _services = Service.getDefaultServices();
    } finally {
      _setLoading(false);
    }
  }

  // Get service by ID
  Service? getServiceById(String id) {
    try {
      return _services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get popular services
  List<Service> get popularServices {
    return _services.where((service) => service.isPopular).toList();
  }

  // Get services by price range
  List<Service> getServicesByPriceRange(double minPrice, double maxPrice) {
    return _services
        .where((service) => service.price >= minPrice && service.price <= maxPrice)
        .toList();
  }

  // Search services
  List<Service> searchServices(String query) {
    if (query.isEmpty) return _services;
    
    query = query.toLowerCase();
    return _services.where((service) {
      return service.name.toLowerCase().contains(query) ||
             service.description.toLowerCase().contains(query) ||
             service.shortDescription.toLowerCase().contains(query);
    }).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
