import 'package:flutter/foundation.dart';
import '../../core/utils/money.dart';

@immutable
class OfficeInfo {
  const OfficeInfo({
    required this.department,
    required this.cityAddresses,
    required this.timings,
    this.fallbackNote,
  });

  final String department;
  final Map<String, String> cityAddresses;
  final String timings;
  final String? fallbackNote;

  String? _verifiedFor(String? userCity) {
    if (userCity == null || userCity.trim().isEmpty) return null;
    final wanted = userCity.trim().toLowerCase();
    for (final entry in cityAddresses.entries) {
      if (entry.key.toLowerCase() == wanted) return entry.value;
    }
    return null;
  }

  bool hasVerifiedAddressFor(String? userCity) => _verifiedFor(userCity) != null;

  String addressFor(String? userCity) {
    return _verifiedFor(userCity) ??
        fallbackNote ??
        'Visit your nearest $department office and confirm the exact branch locally.';
  }

  String? routingAddressFor(String? userCity) => _verifiedFor(userCity);
}

@immutable
class FeeTier {
  const FeeTier(this.label, this.amountText);

  factory FeeTier.rs(String label, int amount) => FeeTier(label, Money.rs(amount));

  final String label;
  final String amountText;
}

@immutable
class FeeInfo {
  const FeeInfo({
    this.tiers = const [],
    this.notes,
    this.variesLocally = false,
  });

  factory FeeInfo.flat(int amount, {String? notes}) {
    return FeeInfo(tiers: [FeeTier.rs('Fee', amount)], notes: notes);
  }

  const FeeInfo.varies({required String this.notes})
      : tiers = const [],
        variesLocally = true;

  final List<FeeTier> tiers;
  final String? notes;
  final bool variesLocally;
}

@immutable
class SubmitInfo {
  const SubmitInfo({required this.instructions, required this.receiptNote});

  final List<String> instructions;
  final String receiptNote;
}

@immutable
class NextStepInfo {
  const NextStepInfo({required this.timeline, required this.followUp});

  final String timeline;
  final String followUp;
}

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
