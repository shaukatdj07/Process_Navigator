import '../data/models/trip_settings_model.dart';

enum TransportMode { bike, car, rickshaw, bus }

class TripCost {
  const TripCost({
    required this.distanceKm,
    this.oneWay,
    this.missingInput,
    this.litresOneWay,
  });

  final double distanceKm;
  final double? oneWay;
  final double? litresOneWay;
  final String? missingInput;

  double? get roundTrip => oneWay == null ? null : oneWay! * 2;
}

class TripCostCalculator {
  const TripCostCalculator._();

  static const String missingRickshawRate = 'rickshaw_rate';
  static const String missingBusFare = 'bus_fare';

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
        final rate = settings.rickshawRatePerKm;
        if (rate == null) {
          return TripCost(distanceKm: distanceKm, missingInput: missingRickshawRate);
        }
        return TripCost(distanceKm: distanceKm, oneWay: distanceKm * rate);
      case TransportMode.bus:
        final fare = settings.busFare;
        if (fare == null) {
          return TripCost(distanceKm: distanceKm, missingInput: missingBusFare);
        }
        return TripCost(distanceKm: distanceKm, oneWay: fare);
    }
  }

  static TripCost _fuel(double distanceKm, double kmPerLitre, double petrolPrice) {
    final litres = distanceKm / kmPerLitre;
    return TripCost(
      distanceKm: distanceKm,
      litresOneWay: litres,
      oneWay: litres * petrolPrice,
    );
  }
}
