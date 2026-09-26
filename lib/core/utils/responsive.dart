import 'package:flutter/material.dart';

/// Lightweight responsive helpers — no external dependency, keeps the app
/// store submission lean while still adapting to phones, large phones and
/// tablets.
class Responsive {
  const Responsive._();

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600;

  /// Number of grid columns for category / process grids.
  static int gridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  /// Horizontal page padding that grows gently on larger screens.
  static double pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return 32;
    if (width >= 600) return 24;
    return 16;
  }

  /// Clamp text scale so accessibility settings never break layouts.
  static double clampedTextScale(BuildContext context) {
    return MediaQuery.textScalerOf(context).scale(1).clamp(0.9, 1.25);
  }
}
