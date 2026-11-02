import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/constants/app_constants.dart';
import 'data/repositories/checklist_repository.dart';
import 'data/repositories/process_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/repositories/trip_settings_repository.dart';
import 'data/services/location_service.dart';
import 'data/services/routing_service.dart';
import 'providers/checklist_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/process_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/trip_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  final encryptionKey = await _loadOrCreateKey();

  await Future.wait([
    Hive.openBox(
      AppConstants.profileBox,
      encryptionCipher: HiveAesCipher(encryptionKey),
    ),
    Hive.openBox(AppConstants.checklistBox),
    Hive.openBox(AppConstants.settingsBox),
  ]);

  final themeProvider = ThemeProvider()..load();

  final processRepository = LocalProcessRepository();
  final profileRepository = HiveProfileRepository();
  final checklistRepository = HiveChecklistRepository();
  final tripSettingsRepository = HiveTripSettingsRepository();
  final locationService = GeolocatorLocationService();
  final routingService = OsmRoutingService();

  runApp(
    MultiProvider(
      providers: [
        Provider<ProcessRepository>.value(value: processRepository),
        ChangeNotifierProvider(
          create: (_) => ProcessProvider(repository: processRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            repository: profileRepository,
            locationService: locationService,
            routingService: routingService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ChecklistProvider(repository: checklistRepository),
        ),
        ChangeNotifierProvider(create: (_) => LocaleProvider()..load()),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider(
          create: (_) => TripProvider(
            settingsRepository: tripSettingsRepository,
            locationService: locationService,
            routingService: routingService,
          )..loadSettings(),
        ),
      ],
      child: const ProcessNavigatorApp(),
    ),
  );
}

Future<List<int>> _loadOrCreateKey() async {
  const storage = FlutterSecureStorage();
  const keyName = 'profile_box_key';

  final saved = await storage.read(key: keyName);
  if (saved != null) return base64Url.decode(saved);

  final fresh = Hive.generateSecureKey();
  await storage.write(key: keyName, value: base64UrlEncode(fresh));
  return fresh;
}
