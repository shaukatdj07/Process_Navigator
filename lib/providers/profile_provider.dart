import 'package:flutter/foundation.dart';
import '../data/models/user_profile_model.dart';
import '../data/repositories/profile_repository.dart';
import '../data/services/location_service.dart';
import '../data/services/routing_service.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider({
    required ProfileRepository repository,
    required LocationService locationService,
    required RoutingService routingService,
  })  : _repository = repository,
        _locationService = locationService,
        _routingService = routingService;

  final ProfileRepository _repository;
  final LocationService _locationService;
  final RoutingService _routingService;

  UserProfileModel profile = const UserProfileModel();
  bool isLoading = false;
  bool isDetectingCity = false;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    profile = await _repository.getProfile();
    isLoading = false;
    notifyListeners();
  }

  Future<void> save(UserProfileModel updated) async {
    profile = updated;
    notifyListeners();
    await _repository.saveProfile(updated);
  }

  Future<void> eraseAll() async {
    profile = const UserProfileModel();
    notifyListeners();
    await _repository.eraseAll();
  }

  Future<String?> detectCity() async {
    isDetectingCity = true;
    notifyListeners();
    try {
      final point = await _locationService.currentPosition();
      return await _routingService.cityAt(point);
    } finally {
      isDetectingCity = false;
      notifyListeners();
    }
  }
}
