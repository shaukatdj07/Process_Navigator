import 'package:flutter/foundation.dart';

/// A single required document line within a process's checklist step.
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
