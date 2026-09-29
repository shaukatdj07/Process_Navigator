import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/trip_settings_model.dart';

abstract class TripSettingsRepository {
  Future<TripSettingsModel> load();
  Future<void> save(TripSettingsModel settings);
}

class HiveTripSettingsRepository implements TripSettingsRepository {
  Box get _box => Hive.box(AppConstants.settingsBox);

  @override
  Future<TripSettingsModel> load() async {
    final raw = _box.get(AppConstants.tripSettingsKey);
    if (raw == null) return const TripSettingsModel();
    return TripSettingsModel.fromMap(Map<dynamic, dynamic>.from(raw as Map));
  }

  @override
  Future<void> save(TripSettingsModel settings) async {
    await _box.put(AppConstants.tripSettingsKey, settings.toMap());
  }
}
