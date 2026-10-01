import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  Box get _box => Hive.box(AppConstants.settingsBox);

  bool get isDark {
    if (_mode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _mode == ThemeMode.dark;
  }

  void load() {
    final saved = _box.get(AppConstants.themeModeKey) as String?;
    _mode = ThemeMode.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    );
    AppColors.isDark = isDark;
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    await _box.put(AppConstants.themeModeKey, mode.name);
    _apply();
  }

  @override
  void didChangePlatformBrightness() {
    if (_mode == ThemeMode.system) _apply();
  }

  void _apply() {
    AppColors.isDark = isDark;
    _rebuildAll();
    notifyListeners();
  }

  void _rebuildAll() {
    void rebuild(Element element) {
      element.markNeedsBuild();
      element.visitChildren(rebuild);
    }

    final root = WidgetsBinding.instance.rootElement;
    if (root != null) rebuild(root);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
