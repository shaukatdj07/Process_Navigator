import 'package:flutter/material.dart';


class Responsive {
  const Responsive._();

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600;

  static int gridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  static double pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return 32;
    if (width >= 600) return 24;
    return 16;
  }

  static double clampedTextScale(BuildContext context) {
    return MediaQuery.textScalerOf(context).scale(1).clamp(0.9, 1.25);
  }
}
