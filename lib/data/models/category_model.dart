import 'package:flutter/material.dart';

/// Immutable data model for a process category (e.g. Vehicles, Documents).
@immutable
class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.processCount,
  });

  final String id;
  final String name;
  final IconData icon;
  final int processCount;
}
