import 'package:flutter/foundation.dart';

@immutable
class TripSettingsModel {
  const TripSettingsModel({
    this.petrolPrice = defaultPetrolPrice,
    this.bikeKmPerLitre = 40,
    this.carKmPerLitre = 12,
    this.rickshawRatePerKm,
    this.busFare,
  });

  static const double defaultPetrolPrice = 391.30;

  final double petrolPrice;
  final double bikeKmPerLitre;
  final double carKmPerLitre;
  final double? rickshawRatePerKm;
  final double? busFare;

  TripSettingsModel copyWith({
    double? petrolPrice,
    double? bikeKmPerLitre,
    double? carKmPerLitre,
    double? rickshawRatePerKm,
    double? busFare,
  }) {
    return TripSettingsModel(
      petrolPrice: petrolPrice ?? this.petrolPrice,
      bikeKmPerLitre: bikeKmPerLitre ?? this.bikeKmPerLitre,
      carKmPerLitre: carKmPerLitre ?? this.carKmPerLitre,
      rickshawRatePerKm: rickshawRatePerKm ?? this.rickshawRatePerKm,
      busFare: busFare ?? this.busFare,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'petrolPrice': petrolPrice,
      'bikeKmPerLitre': bikeKmPerLitre,
      'carKmPerLitre': carKmPerLitre,
      'rickshawRatePerKm': rickshawRatePerKm,
      'busFare': busFare,
    };
  }

  factory TripSettingsModel.fromMap(Map<dynamic, dynamic> map) {
    double? asDouble(dynamic v) => v is num ? v.toDouble() : null;
    return TripSettingsModel(
      petrolPrice: asDouble(map['petrolPrice']) ?? defaultPetrolPrice,
      bikeKmPerLitre: asDouble(map['bikeKmPerLitre']) ?? 40,
      carKmPerLitre: asDouble(map['carKmPerLitre']) ?? 12,
      rickshawRatePerKm: asDouble(map['rickshawRatePerKm']),
      busFare: asDouble(map['busFare']),
    );
  }
}
