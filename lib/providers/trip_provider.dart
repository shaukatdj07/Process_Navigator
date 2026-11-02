import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../data/models/trip_settings_model.dart';
import '../data/repositories/trip_settings_repository.dart';
import '../data/services/location_service.dart';
import '../data/services/routing_service.dart';
import '../domain/trip_cost_calculator.dart';

enum LocationStatus { idle, loading, error }

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
  LocationStatus locationStatus = LocationStatus.idle;
  String? errorKey;

  Future<void> loadSettings() async {
    settings = await _settingsRepository.load();
    notifyListeners();
  }

  Future<void> saveSettings(TripSettingsModel updated) async {
    settings = updated;
    await _settingsRepository.save(updated);
    notifyListeners();
  }

  void selectMode(TransportMode newMode) {
    mode = newMode;
    notifyListeners();
  }

  void clearError() {
    if (locationStatus == LocationStatus.idle) return;
    locationStatus = LocationStatus.idle;
    errorKey = null;
    notifyListeners();
  }

  Future<double?> distanceFromMyLocation(String officeAddress) async {
    if (locationStatus == LocationStatus.loading) return null;
    locationStatus = LocationStatus.loading;
    errorKey = null;
    notifyListeners();

    try {
      final from = await _locationService.currentPosition();
      final to = await _routingService.geocode(officeAddress);
      if (to == null) {
        _fail('trip_office_not_found');
        return null;
      }
      final distance = await _routingService.roadDistanceKm(from, to);
      if (distance == null) {
        _fail('trip_no_route');
        return null;
      }
      locationStatus = LocationStatus.idle;
      notifyListeners();
      return distance;
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
    } on RoutingException {
      _fail('trip_route_failed');
    } on TimeoutException {
      _fail('trip_timeout');
    } on SocketException {
      _fail('trip_network_error');
    } catch (_) {
      _fail('trip_network_error');
    }
    return null;
  }

  Future<void> openLocationSettings() => _locationService.openSettings();

  void _fail(String key) {
    locationStatus = LocationStatus.error;
    errorKey = key;
    notifyListeners();
  }
}
