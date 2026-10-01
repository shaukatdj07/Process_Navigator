import 'package:flutter/material.dart';

class AppPalette {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.ink,
    required this.inkMuted,
    required this.inkFaint,
    required this.border,
    required this.accent,
    required this.accentMuted,
  });

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color ink;
  final Color inkMuted;
  final Color inkFaint;
  final Color border;
  final Color accent;
  final Color accentMuted;

  static const AppPalette light = AppPalette(
    background: Color(0xFFF5F3EC),
    surface: Colors.white,
    surfaceMuted: Color(0xFFECE9DE),
    ink: Color(0xFF0F2A24),
    inkMuted: Color(0xFF52625D),
    inkFaint: Color(0xFF8C9994),
    border: Color(0xFFE1DED2),
    accent: Color(0xFF0B6E4F),
    accentMuted: Color(0xFFDDF1E9),
  );

  static const AppPalette dark = AppPalette(
    background: Color(0xFF0D1513),
    surface: Color(0xFF15211E),
    surfaceMuted: Color(0xFF1F2D29),
    ink: Color(0xFFEAF1EE),
    inkMuted: Color(0xFFA9B8B3),
    inkFaint: Color(0xFF7C8D87),
    border: Color(0xFF2A3A35),
    accent: Color(0xFF3DBE8B),
    accentMuted: Color(0xFF173A2F),
  );
}
