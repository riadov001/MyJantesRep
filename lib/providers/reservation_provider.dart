import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../models/quote.dart';
import '../services/api_service.dart';

class ReservationProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Reservation> _reservations = [];
  List<Quote> _quotes = [];
  bool _isLoading = false;
  String? _error;

  List<Reservation> get reservations => _reservations;
  List<Quote> get quotes => _quotes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load user reservations
  Future<void> loadReservations() async {
    _setLoading(true);
    _error = null;

    try {
      _reservations = await _apiService.getReservations();
    } catch (e) {
      _error = e.toString();
      _reservations = [];
    } finally {
      _setLoading(false);
    }
  }

  // Create reservation
  Future<bool> createReservation({
    required String serviceId,
    required DateTime dateTime,
    String? notes,
    String? vehicleInfo,
    List<String>? imageUrls,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final reservation = await _apiService.createReservation(
        serviceId: serviceId,
        dateTime: dateTime,
        notes: notes,
        vehicleInfo: vehicleInfo,
        imageUrls: imageUrls,
      );
      
      _reservations.insert(0, reservation);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Cancel reservation
  Future<bool> cancelReservation(String reservationId) async {
    _setLoading(true);
    _error = null;

    try {
      await _apiService.cancelReservation(reservationId);
      
      // Update local list
      final index = _reservations.indexWhere((r) => r.id == reservationId);
      if (index != -1) {
        _reservations[index] = Reservation(
          id: _reservations[index].id,
          userId: _reservations[index].userId,
          serviceId: _reservations[index].serviceId,
          service: _reservations[index].service,
          dateTime: _reservations[index].dateTime,
          status: ReservationStatus.cancelled,
          notes: _reservations[index].notes,
          vehicleInfo: _reservations[index].vehicleInfo,
          imageUrls: _reservations[index].imageUrls,
          createdAt: _reservations[index].createdAt,
          updatedAt: DateTime.now(),
        );
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load user quotes
  Future<void> loadQuotes() async {
    _setLoading(true);
    _error = null;

    try {
      _quotes = await _apiService.getQuotes();
    } catch (e) {
      _error = e.toString();
      _quotes = [];
    } finally {
      _setLoading(false);
    }
  }

  // Create quote request
  Future<bool> createQuote({
    required String serviceId,
    required String vehicleMake,
    required String vehicleModel,
    required String vehicleYear,
    required String wheelSize,
    required String description,
    required List<String> imageUrls,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final quote = await _apiService.createQuote(
        serviceId: serviceId,
        vehicleMake: vehicleMake,
        vehicleModel: vehicleModel,
        vehicleYear: vehicleYear,
        wheelSize: wheelSize,
        description: description,
        imageUrls: imageUrls,
      );
      
      _quotes.insert(0, quote);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get reservations by status
  List<Reservation> getReservationsByStatus(ReservationStatus status) {
    return _reservations.where((r) => r.status == status).toList();
  }

  // Get quotes by status
  List<Quote> getQuotesByStatus(QuoteStatus status) {
    return _quotes.where((q) => q.status == status).toList();
  }

  // Get upcoming reservations
  List<Reservation> get upcomingReservations {
    return _reservations
        .where((r) => r.dateTime.isAfter(DateTime.now()) && 
                     r.status != ReservationStatus.cancelled)
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
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
