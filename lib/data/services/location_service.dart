import 'package:geolocator/geolocator.dart';

class GeoPoint {
  const GeoPoint(this.lat, this.lon);

  final double lat;
  final double lon;
}

enum LocationFailure { serviceOff, denied, deniedForever, unknown }

class LocationException implements Exception {
  const LocationException(this.reason);

  final LocationFailure reason;
}

abstract class LocationService {
  Future<GeoPoint> currentPosition();
  Future<void> openSettings();
}

class GeolocatorLocationService implements LocationService {

  bool _askedThisSession = false;

  @override
  Future<GeoPoint> currentPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw const LocationException(LocationFailure.serviceOff);

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && !_askedThisSession) {
      _askedThisSession = true;
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException(LocationFailure.denied);
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(LocationFailure.deniedForever);
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 12),
        ),
      );
      return GeoPoint(position.latitude, position.longitude);
    } catch (_) {

      try {
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) return GeoPoint(last.latitude, last.longitude);
      } catch (_) {}
      throw const LocationException(LocationFailure.unknown);
    }
  }

  @override
  Future<void> openSettings() => Geolocator.openAppSettings();
}
