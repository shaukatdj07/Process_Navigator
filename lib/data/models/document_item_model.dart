import 'package:flutter/foundation.dart';

@immutable
class DocumentItemModel {
  const DocumentItemModel({
    required this.id,
    required this.title,
    required this.copies,
    this.attestationRequired = false,
  });

  final String id;
  final String title;
  final int copies;
  final bool attestationRequired;
}
