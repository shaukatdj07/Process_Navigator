import 'package:flutter/foundation.dart';

/// Office information for a process.
@immutable
class OfficeInfo {
  const OfficeInfo({
    required this.name,
    required this.address,
    required this.timings,
  });

  final String name;
  final String address;
  final String timings;
}

/// Fee information, with an optional simple calculator range.
@immutable
class FeeInfo {
  const FeeInfo({
    required this.baseFee,
    this.notes,
    this.dependsOnVehicleType = false,
  });

  final int baseFee;
  final String? notes;
  final bool dependsOnVehicleType;
}

/// Submission instructions for a process step.
@immutable
class SubmitInfo {
  const SubmitInfo({required this.instructions, required this.receiptNote});

  final List<String> instructions;
  final String receiptNote;
}

/// What happens after submission — timeline and follow-up.
@immutable
class NextStepInfo {
  const NextStepInfo({required this.timeline, required this.followUp});

  final String timeline;
  final String followUp;
}

/// Official source badge shown on every step.
@immutable
class SourceInfo {
  const SourceInfo({
    required this.sourceName,
    required this.url,
    required this.lastVerified,
  });

  final String sourceName;
  final String url;
  final DateTime lastVerified;
}
