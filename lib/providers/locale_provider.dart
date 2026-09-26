import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';

/// Owns the bilingual (English / Urdu) interface language, including the
/// text direction switch required for proper Urdu right-to-left layout.
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  TextDirection get textDirection =>
      _locale.languageCode == 'ur' ? TextDirection.rtl : TextDirection.ltr;

  bool get isUrdu => _locale.languageCode == 'ur';

  void load() {
    final box = Hive.box(AppConstants.settingsBox);
    final saved = box.get(AppConstants.localeKey, defaultValue: 'en') as String;
    _locale = Locale(saved);
    notifyListeners();
  }

  Future<void> toggle() async {
    _locale = isUrdu ? const Locale('en') : const Locale('ur');
    notifyListeners();
    final box = Hive.box(AppConstants.settingsBox);
    await box.put(AppConstants.localeKey, _locale.languageCode);
  }
}
