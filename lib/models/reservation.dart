import 'service.dart';

enum ReservationStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

class Reservation {
  final String id;
  final String userId;
  final String serviceId;
  final Service? service;
  final DateTime dateTime;
  final ReservationStatus status;
  final String? notes;
  final String? vehicleInfo;
  final List<String>? imageUrls;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Reservation({
    required this.id,
    required this.userId,
    required this.serviceId,
    this.service,
    required this.dateTime,
    required this.status,
    this.notes,
    this.vehicleInfo,
    this.imageUrls,
    required this.createdAt,
    this.updatedAt,
  });

  String get statusText {
    switch (status) {
      case ReservationStatus.pending:
        return 'En attente';
      case ReservationStatus.confirmed:
        return 'Confirmée';
      case ReservationStatus.inProgress:
        return 'En cours';
      case ReservationStatus.completed:
        return 'Terminée';
      case ReservationStatus.cancelled:
        return 'Annulée';
    }
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      serviceId: json['service_id'].toString(),
      service: json['service'] != null ? Service.fromJson(json['service']) : null,
      dateTime: DateTime.parse(json['date_time']),
      status: ReservationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReservationStatus.pending,
      ),
      notes: json['notes'],
      vehicleInfo: json['vehicle_info'],
      imageUrls: json['image_urls'] != null 
          ? List<String>.from(json['image_urls'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'date_time': dateTime.toIso8601String(),
      'status': status.name,
      'notes': notes,
      'vehicle_info': vehicleInfo,
      'image_urls': imageUrls,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
