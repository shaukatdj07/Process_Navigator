import 'package:flutter/material.dart';

/// Centralised color palette following the 60/30/10 design rule.
///
/// 60% — [background]   dominant background & surfaces
/// 30% — [ink]           typography & secondary surfaces
/// 10% — [accent]        CTAs, links & visual emphasis
class AppColors {
  const AppColors._();

  static const Color background = Color(0xFFF7F4ED); // 60% dominant
  static const Color ink = Color(0xFF111111); // 30% typography/secondary
  static const Color accent = Color(0xFF5B7CFF); // 10% CTAs/links/emphasis

  // Derived / supporting tones kept within the same palette family so the
  // 60/30/10 ratio holds across states (hover, disabled, borders, etc.).
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFEFEBE1);
  static const Color inkMuted = Color(0xFF5C5C5C);
  static const Color inkFaint = Color(0xFF9A9A9A);
  static const Color border = Color(0xFFE3DFD4);
  static const Color accentMuted = Color(0xFFE7ECFF);
  static const Color accentPressed = Color(0xFF4763CC);

  static const Color success = Color(0xFF2E9B5B);
  static const Color warning = Color(0xFFC98A1B);
  static const Color danger = Color(0xFFD65252);
}
