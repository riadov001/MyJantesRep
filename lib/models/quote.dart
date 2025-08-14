import 'service.dart';

enum QuoteStatus {
  pending,
  sent,
  accepted,
  declined,
}

class Quote {
  final String id;
  final String userId;
  final String serviceId;
  final Service? service;
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleYear;
  final String wheelSize;
  final String description;
  final List<String> imageUrls;
  final QuoteStatus status;
  final double? estimatedPrice;
  final String? response;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Quote({
    required this.id,
    required this.userId,
    required this.serviceId,
    this.service,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.wheelSize,
    required this.description,
    required this.imageUrls,
    required this.status,
    this.estimatedPrice,
    this.response,
    required this.createdAt,
    this.updatedAt,
  });

  String get statusText {
    switch (status) {
      case QuoteStatus.pending:
        return 'En attente';
      case QuoteStatus.sent:
        return 'Devis envoyé';
      case QuoteStatus.accepted:
        return 'Accepté';
      case QuoteStatus.declined:
        return 'Refusé';
    }
  }

  String get vehicleInfo => '$vehicleMake $vehicleModel ($vehicleYear)';

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      serviceId: json['service_id'].toString(),
      service: json['service'] != null ? Service.fromJson(json['service']) : null,
      vehicleMake: json['vehicle_make'] ?? '',
      vehicleModel: json['vehicle_model'] ?? '',
      vehicleYear: json['vehicle_year'] ?? '',
      wheelSize: json['wheel_size'] ?? '',
      description: json['description'] ?? '',
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      status: QuoteStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => QuoteStatus.pending,
      ),
      estimatedPrice: json['estimated_price']?.toDouble(),
      response: json['response'],
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
      'vehicle_make': vehicleMake,
      'vehicle_model': vehicleModel,
      'vehicle_year': vehicleYear,
      'wheel_size': wheelSize,
      'description': description,
      'image_urls': imageUrls,
      'status': status.name,
      'estimated_price': estimatedPrice,
      'response': response,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
