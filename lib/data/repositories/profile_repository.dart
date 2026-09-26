import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_profile_model.dart';

/// Persists "Saved Details" locally. CNIC and other sensitive fields never
/// leave the device — this repository has no network calls at all.
abstract class ProfileRepository {
  Future<UserProfileModel> getProfile();
  Future<void> saveProfile(UserProfileModel profile);
  Future<void> eraseAll();
}

class HiveProfileRepository implements ProfileRepository {
  Box get _box => Hive.box(AppConstants.profileBox);

  @override
  Future<UserProfileModel> getProfile() async {
    final raw = _box.get(AppConstants.profileKey);
    if (raw == null) return const UserProfileModel();
    return UserProfileModel.fromMap(Map<dynamic, dynamic>.from(raw as Map));
  }

  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    await _box.put(AppConstants.profileKey, profile.toMap());
  }

  @override
  Future<void> eraseAll() async {
    await _box.clear();
  }
}
