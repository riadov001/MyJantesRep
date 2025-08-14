import 'dart:io';

class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://gold-oyster-439778.hostingersite.com';
  static const String apiPath = '/wp-json/wp/v2';
  static const String jwtPath = '/wp-json/jwt-auth/v1';
  
  // WordPress API Endpoints
  static const String loginEndpoint = '$jwtPath/token';
  static const String registerEndpoint = '$jwtPath/token/validate';
  static const String servicesEndpoint = '$apiPath/services';
  static const String reservationsEndpoint = '$apiPath/reservations';
  static const String quotesEndpoint = '$apiPath/quotes';
  static const String usersEndpoint = '$apiPath/users';
  
  // Storage Keys
  static const String tokenKey = 'jwt_token';
  static const String userKey = 'user_data';
  static const String servicesCache = 'services_cache';
  
  // App Configuration
  static const String appName = 'MyJantes Manager';
  static const String logoUrl = 'https://myjantes.fr/logo.png';
  
  // Services IDs (based on WordPress post IDs)
  static const Map<String, String> serviceIds = {
    'renovation': '1',
    'personnalisation': '2',
    'tribofinition': '3',
    'soudure': '4',
    'decapage': '5',
    'hydrographie': '6',
  };
  
  // Service Icons (using Material Icons)
  static const Map<String, String> serviceIcons = {
    'renovation': 'build',
    'personnalisation': 'palette',
    'tribofinition': 'auto_awesome',
    'soudure': 'construction',
    'decapage': 'cleaning_services',
    'hydrographie': 'water',
  };
  
  // Business hours
  static const Map<String, String> businessHours = {
    'monday': '08:00-18:00',
    'tuesday': '08:00-18:00',
    'wednesday': '08:00-18:00',
    'thursday': '08:00-18:00',
    'friday': '08:00-18:00',
    'saturday': '09:00-17:00',
    'sunday': 'closed',
  };
  
  // Contact information
  static const String phoneNumber = '+33123456789';
  static const String emailAddress = 'contact@myjantes.fr';
  static const String address = '123 Rue de la Rénovation, 75000 Paris';
}
