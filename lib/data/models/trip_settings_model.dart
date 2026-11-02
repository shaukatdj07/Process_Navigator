import 'package:flutter/foundation.dart';

@immutable
class TripSettingsModel {
  const TripSettingsModel({
    this.petrolPrice = defaultPetrolPrice,
    this.bikeKmPerLitre = defaultBikeKmPerLitre,
    this.carKmPerLitre = defaultCarKmPerLitre,
    this.rickshawBaseFare = defaultRickshawBaseFare,
    this.rickshawRatePerKm = defaultRickshawRatePerKm,
    this.busFare = defaultBusFare,
  });

  static const double defaultPetrolPrice = 391.30;
  static const double defaultBikeKmPerLitre = 40;
  static const double defaultCarKmPerLitre = 12;
  static const double defaultRickshawBaseFare = 100;
  static const double defaultRickshawRatePerKm = 30;
  static const double defaultBusFare = 50;

  final double petrolPrice;
  final double bikeKmPerLitre;
  final double carKmPerLitre;
  final double rickshawBaseFare;
  final double rickshawRatePerKm;
  final double busFare;

  TripSettingsModel copyWith({
    double? petrolPrice,
    double? bikeKmPerLitre,
    double? carKmPerLitre,
    double? rickshawBaseFare,
    double? rickshawRatePerKm,
    double? busFare,
  }) {
    return TripSettingsModel(
      petrolPrice: petrolPrice ?? this.petrolPrice,
      bikeKmPerLitre: bikeKmPerLitre ?? this.bikeKmPerLitre,
      carKmPerLitre: carKmPerLitre ?? this.carKmPerLitre,
      rickshawBaseFare: rickshawBaseFare ?? this.rickshawBaseFare,
      rickshawRatePerKm: rickshawRatePerKm ?? this.rickshawRatePerKm,
      busFare: busFare ?? this.busFare,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'petrolPrice': petrolPrice,
      'bikeKmPerLitre': bikeKmPerLitre,
      'carKmPerLitre': carKmPerLitre,
      'rickshawBaseFare': rickshawBaseFare,
      'rickshawRatePerKm': rickshawRatePerKm,
      'busFare': busFare,
    };
  }

  factory TripSettingsModel.fromMap(Map<dynamic, dynamic> map) {
    double read(dynamic v, double fallback) => (v is num && v > 0) ? v.toDouble() : fallback;
    return TripSettingsModel(
      petrolPrice: read(map['petrolPrice'], defaultPetrolPrice),
      bikeKmPerLitre: read(map['bikeKmPerLitre'], defaultBikeKmPerLitre),
      carKmPerLitre: read(map['carKmPerLitre'], defaultCarKmPerLitre),
      rickshawBaseFare: read(map['rickshawBaseFare'], defaultRickshawBaseFare),
      rickshawRatePerKm: read(map['rickshawRatePerKm'], defaultRickshawRatePerKm),
      busFare: read(map['busFare'], defaultBusFare),
    );
  }
}
