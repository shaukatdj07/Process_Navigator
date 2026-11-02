import '../data/models/trip_settings_model.dart';

enum TransportMode { bike, car, rickshaw, bus }

class TripCost {
  const TripCost({required this.oneWay, this.litres});

  final double oneWay;
  final double? litres;

  double get roundTrip => oneWay * 2;
}

class TripCostCalculator {
  const TripCostCalculator._();

  static TripCost calculate({
    required TransportMode mode,
    required double distanceKm,
    required TripSettingsModel settings,
  }) {
    switch (mode) {
      case TransportMode.bike:
        return _fuel(distanceKm, settings.bikeKmPerLitre, settings.petrolPrice);
      case TransportMode.car:
        return _fuel(distanceKm, settings.carKmPerLitre, settings.petrolPrice);
      case TransportMode.rickshaw:
        return TripCost(oneWay: settings.rickshawBaseFare + distanceKm * settings.rickshawRatePerKm);
      case TransportMode.bus:
        return TripCost(oneWay: settings.busFare);
    }
  }

  static TripCost _fuel(double distanceKm, double kmPerLitre, double petrolPrice) {
    final litres = distanceKm / kmPerLitre;
    return TripCost(oneWay: litres * petrolPrice, litres: litres);
  }
}
