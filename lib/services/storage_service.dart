import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token management
  static Future<void> saveToken(String token) async {
    await _prefs?.setString(AppConstants.tokenKey, token);
  }

  static Future<String?> getToken() async {
    return _prefs?.getString(AppConstants.tokenKey);
  }

  static Future<void> clearToken() async {
    await _prefs?.remove(AppConstants.tokenKey);
  }

  // User data management
  static Future<void> saveUser(String userData) async {
    await _prefs?.setString(AppConstants.userKey, userData);
  }

  static Future<String?> getUser() async {
    return _prefs?.getString(AppConstants.userKey);
  }

  static Future<void> clearUser() async {
    await _prefs?.remove(AppConstants.userKey);
  }

  // Services cache
  static Future<void> saveServicesCache(String servicesData) async {
    await _prefs?.setString(AppConstants.servicesCache, servicesData);
    await _prefs?.setInt('${AppConstants.servicesCache}_timestamp', 
        DateTime.now().millisecondsSinceEpoch);
  }

  static Future<String?> getServicesCache() async {
    // Check if cache is not older than 1 hour
    final timestamp = _prefs?.getInt('${AppConstants.servicesCache}_timestamp');
    if (timestamp != null) {
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (cacheAge < 3600000) { // 1 hour in milliseconds
        return _prefs?.getString(AppConstants.servicesCache);
      }
    }
    return null;
  }

  // Clear all cache
  static Future<void> clearCache() async {
    await _prefs?.remove(AppConstants.servicesCache);
    await _prefs?.remove('${AppConstants.servicesCache}_timestamp');
  }

  // Generic storage methods
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
