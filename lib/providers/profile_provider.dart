import 'package:flutter/foundation.dart';
import '../data/models/user_profile_model.dart';
import '../data/repositories/profile_repository.dart';

/// Owns the "Saved Details (My Profile)" state used to personalise
/// checklists and pre-fill the fee calculator / reminders.
class ProfileProvider extends ChangeNotifier {
  ProfileProvider({required ProfileRepository repository})
      : _repository = repository;

  final ProfileRepository _repository;

  UserProfileModel profile = const UserProfileModel();
  bool isLoading = false;

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
}
