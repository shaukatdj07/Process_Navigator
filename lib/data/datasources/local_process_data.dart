import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/process_model.dart';
import 'business_data.dart';
import 'certificate_data.dart';
import 'education_data.dart';
import 'identity_data.dart';
import 'licence_data.dart';
import 'property_data.dart';
import 'travel_data.dart';
import 'vehicle_data.dart';

class LocalProcessData {
  const LocalProcessData._();

  static final List<ProcessModel> processes = [
    ...identityProcesses,
    ...travelProcesses,
    ...vehicleProcesses,
    ...propertyProcesses,
    ...certificateProcesses,
    ...businessProcesses,
    ...licenceProcesses,
    ...educationProcesses,
  ];

  static const List<_CategorySeed> _seeds = [
    _CategorySeed('identity', 'Identity Documents', Icons.badge_rounded),
    _CategorySeed('travel', 'Passport and Travel', Icons.flight_takeoff_rounded),
    _CategorySeed('vehicles', 'Vehicles and Driving', Icons.directions_car_filled_rounded),
    _CategorySeed('property', 'Property', Icons.home_work_rounded),
    _CategorySeed('certificates', 'Certificates', Icons.workspace_premium_rounded),
    _CategorySeed('business', 'Business and Tax', Icons.storefront_rounded),
    _CategorySeed('nocs', 'NOCs and Licenses', Icons.fact_check_rounded),
    _CategorySeed('education', 'Education Attestation', Icons.school_rounded),
  ];

  static List<CategoryModel> get categories {
    return _seeds.map((seed) {
      final count = processes.where((p) => p.categoryId == seed.id).length;
      return CategoryModel(
        id: seed.id,
        name: seed.name,
        icon: seed.icon,
        processCount: count,
      );
    }).toList();
  }
}

class _CategorySeed {
  const _CategorySeed(this.id, this.name, this.icon);

  final String id;
  final String name;
  final IconData icon;
}
