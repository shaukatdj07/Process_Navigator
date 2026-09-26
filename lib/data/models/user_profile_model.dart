import 'package:flutter/foundation.dart';

/// "Saved Details" profile — every field is optional per the product spec.
/// Stored locally only; CNIC is never uploaded anywhere.
@immutable
class UserProfileModel {
  const UserProfileModel({
    this.fullName = '',
    this.fatherName = '',
    this.city = '',
    this.phone = '',
    this.cnic = '',
    this.preferredLanguage = 'English',
    this.vehicleType = '',
    this.licenseExpiry,
    this.passportExpiry,
  });

  final String fullName;
  final String fatherName;
  final String city;
  final String phone;
  final String cnic;
  final String preferredLanguage;
  final String vehicleType;
  final DateTime? licenseExpiry;
  final DateTime? passportExpiry;

  bool get isEmpty =>
      fullName.isEmpty &&
      fatherName.isEmpty &&
      city.isEmpty &&
      phone.isEmpty &&
      cnic.isEmpty &&
      vehicleType.isEmpty &&
      licenseExpiry == null &&
      passportExpiry == null;

  UserProfileModel copyWith({
    String? fullName,
    String? fatherName,
    String? city,
    String? phone,
    String? cnic,
    String? preferredLanguage,
    String? vehicleType,
    DateTime? licenseExpiry,
    DateTime? passportExpiry,
  }) {
    return UserProfileModel(
      fullName: fullName ?? this.fullName,
      fatherName: fatherName ?? this.fatherName,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      cnic: cnic ?? this.cnic,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      vehicleType: vehicleType ?? this.vehicleType,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      passportExpiry: passportExpiry ?? this.passportExpiry,
    );
  }

  /// Plain-map form for Hive storage — avoids needing a generated
  /// TypeAdapter, which keeps the build simple for a first release.
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'fatherName': fatherName,
      'city': city,
      'phone': phone,
      'cnic': cnic,
      'preferredLanguage': preferredLanguage,
      'vehicleType': vehicleType,
      'licenseExpiry': licenseExpiry?.toIso8601String(),
      'passportExpiry': passportExpiry?.toIso8601String(),
    };
  }

  factory UserProfileModel.fromMap(Map<dynamic, dynamic> map) {
    return UserProfileModel(
      fullName: map['fullName'] as String? ?? '',
      fatherName: map['fatherName'] as String? ?? '',
      city: map['city'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      cnic: map['cnic'] as String? ?? '',
      preferredLanguage: map['preferredLanguage'] as String? ?? 'English',
      vehicleType: map['vehicleType'] as String? ?? '',
      licenseExpiry: map['licenseExpiry'] != null
          ? DateTime.tryParse(map['licenseExpiry'] as String)
          : null,
      passportExpiry: map['passportExpiry'] != null
          ? DateTime.tryParse(map['passportExpiry'] as String)
          : null,
    );
  }
}
