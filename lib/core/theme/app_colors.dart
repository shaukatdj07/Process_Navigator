import 'package:flutter/material.dart';
import 'app_palette.dart';

class AppColors {
  const AppColors._();

  static bool isDark = false;

  static AppPalette get _p => isDark ? AppPalette.dark : AppPalette.light;

  static Color get background => _p.background;
  static Color get surface => _p.surface;
  static Color get surfaceMuted => _p.surfaceMuted;
  static Color get ink => _p.ink;
  static Color get inkMuted => _p.inkMuted;
  static Color get inkFaint => _p.inkFaint;
  static Color get border => _p.border;
  static Color get accent => _p.accent;
  static Color get accentMuted => _p.accentMuted;

  static const Color onHighlight = Color(0xFF0F2A24);

  static const Color highlight = Color(0xFFF2A93B);

  static const Color accentPressed = Color(0xFF085A41);

  static const Color success = Color(0xFF2E9B5B);
  static const Color warning = Color(0xFFC98A1B);
  static const Color danger = Color(0xFFD65252);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B6E4F), Color(0xFF07493A)],
  );

  static const Map<String, Color> categoryTones = {
    'identity': Color(0xFF2F5BD8),
    'travel': Color(0xFF0A8FA8),
    'vehicles': Color(0xFFD9541E),
    'property': Color(0xFF8A5A2B),
    'certificates': Color(0xFFB8860B),
    'business': Color(0xFF7A3FC9),
    'nocs': Color(0xFF0B6E4F),
    'education': Color(0xFFC2306B),
  };

  static Color toneOf(String categoryId) => categoryTones[categoryId] ?? accent;
}
