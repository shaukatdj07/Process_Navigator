import 'package:flutter/material.dart';

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
