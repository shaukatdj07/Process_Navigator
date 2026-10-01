import 'dart:convert';
import 'package:http/http.dart' as http;
import 'location_service.dart';

enum RoutingFailure { api, malformed, invalidCoordinates }

class RoutingException implements Exception {
  const RoutingException(this.reason);

  final RoutingFailure reason;
}

abstract class RoutingService {
  Future<GeoPoint?> geocode(String query);
  Future<double?> roadDistanceKm(GeoPoint from, GeoPoint to);
  Future<String?> cityAt(GeoPoint point);
}

class OsmRoutingService implements RoutingService {
  OsmRoutingService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const Map<String, String> _headers = {
    'User-Agent': 'ProcessNavigatorApp/1.0',
    'Accept': 'application/json',
  };

  @override
  Future<GeoPoint?> geocode(String query) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'json',
      'limit': '1',
    });
    final response = await _client.get(uri, headers: _headers).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) return null;
    final list = jsonDecode(response.body) as List<dynamic>;
    if (list.isEmpty) return null;
    final first = list.first as Map<String, dynamic>;
    final lat = double.tryParse('${first['lat']}');
    final lon = double.tryParse('${first['lon']}');
    if (lat == null || lon == null) return null;
    return GeoPoint(lat, lon);
  }

  static bool _validPoint(GeoPoint p) =>
      p.lat.isFinite && p.lon.isFinite && p.lat.abs() <= 90 && p.lon.abs() <= 180;

  @override
  Future<double?> roadDistanceKm(GeoPoint from, GeoPoint to) async {
    if (!_validPoint(from) || !_validPoint(to)) {
      throw const RoutingException(RoutingFailure.invalidCoordinates);
    }
    final path = '/route/v1/driving/${from.lon},${from.lat};${to.lon},${to.lat}';
    final uri = Uri.https('router.project-osrm.org', path, {'overview': 'false'});
    final response = await _client.get(uri, headers: _headers).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {

      if (response.body.contains('NoRoute')) return null;
      throw const RoutingException(RoutingFailure.api);
    }
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['code'] == 'NoRoute') return null;
      final routes = body['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) return null;
      final meters = (routes.first as Map<String, dynamic>)['distance'];
      if (meters is! num || meters < 0) {
        throw const RoutingException(RoutingFailure.malformed);
      }
      return meters.toDouble() / 1000;
    } on RoutingException {
      rethrow;
    } catch (_) {
      throw const RoutingException(RoutingFailure.malformed);
    }
  }

  @override
  Future<String?> cityAt(GeoPoint point) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'lat': '${point.lat}',
      'lon': '${point.lon}',
      'format': 'json',
      'zoom': '10',
      'accept-language': 'en',
    });
    final response = await _client.get(uri, headers: _headers).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) return null;
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final address = body['address'] as Map<String, dynamic>?;
    if (address == null) return null;
    final city = address['city'] ?? address['town'] ?? address['county'] ?? address['state_district'];
    if (city is! String) return null;
    return city
        .replaceAll(RegExp(r'\s+(District|Division|Tehsil|City|Metropolitan Corporation)$', caseSensitive: false), '')
        .trim();
  }
}
