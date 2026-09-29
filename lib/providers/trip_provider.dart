import 'package:flutter/foundation.dart';
import '../data/models/process_step_model.dart';
import '../data/models/trip_settings_model.dart';
import '../data/repositories/trip_settings_repository.dart';
import '../data/services/location_service.dart';
import '../data/services/routing_service.dart';
import '../domain/trip_cost_calculator.dart';

enum TripStatus { idle, loading, ready, error }


class TripProvider extends ChangeNotifier {
  TripProvider({
    required TripSettingsRepository settingsRepository,
    required LocationService locationService,
    required RoutingService routingService,
  })  : _settingsRepository = settingsRepository,
        _locationService = locationService,
        _routingService = routingService;

  final TripSettingsRepository _settingsRepository;
  final LocationService _locationService;
  final RoutingService _routingService;

  TripSettingsModel settings = const TripSettingsModel();
  TransportMode mode = TransportMode.bike;
  TripStatus status = TripStatus.idle;
  TripCost? result;

  String? errorKey;

  double? _lastDistanceKm;

  Future<void> loadSettings() async {
    settings = await _settingsRepository.load();
    notifyListeners();
  }

  Future<void> saveSettings(TripSettingsModel updated) async {
    settings = updated;
    await _settingsRepository.save(updated);

    final distance = _lastDistanceKm;
    if (distance != null) {
      result = TripCostCalculator.calculate(mode: mode, distanceKm: distance, settings: settings);
    }
    notifyListeners();
  }

  void selectMode(TransportMode newMode) {
    mode = newMode;
    final distance = _lastDistanceKm;
    if (distance != null) {
      result = TripCostCalculator.calculate(mode: mode, distanceKm: distance, settings: settings);
    }
    notifyListeners();
  }

  Future<void> calculate({required OfficeInfo office, required String? userCity}) async {
    final address = office.routingAddressFor(userCity);
    if (address == null) {
      _fail('trip_no_verified_office');
      return;
    }

    status = TripStatus.loading;
    errorKey = null;
    notifyListeners();

    try {
      final from = await _locationService.currentPosition();
      final to = await _routingService.geocode(address);
      if (to == null) {
        _fail('trip_office_not_found');
        return;
      }
      final distance = await _routingService.roadDistanceKm(from, to);
      if (distance == null) {
        _fail('trip_route_failed');
        return;
      }
      _lastDistanceKm = distance;
      result = TripCostCalculator.calculate(mode: mode, distanceKm: distance, settings: settings);
      status = TripStatus.ready;
      notifyListeners();
    } on LocationException catch (e) {
      switch (e.reason) {
        case LocationFailure.serviceOff:
          _fail('trip_location_off');
        case LocationFailure.denied:
          _fail('trip_location_denied');
        case LocationFailure.deniedForever:
          _fail('trip_location_denied_forever');
        case LocationFailure.unknown:
          _fail('trip_location_unknown');
      }
    } catch (_) {
      _fail('trip_network_error');
    }
  }

  Future<void> openLocationSettings() => _locationService.openSettings();

  void reset() {
    status = TripStatus.idle;
    result = null;
    errorKey = null;
    _lastDistanceKm = null;
    notifyListeners();
  }

  void _fail(String key) {
    status = TripStatus.error;
    errorKey = key;
    notifyListeners();
  }
}
