import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../data/models/process_step_model.dart';

class FeeTab extends StatelessWidget {
  const FeeTab({super.key, required this.fee});

  final FeeInfo fee;

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        AppCard(
          accentColor: AppColors.highlight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBadge(icon: Icons.payments_rounded, color: AppColors.highlight, size: 40),
                  const SizedBox(width: 12),
                  Text(t('official_fee'), style: AppTextStyles.title),
                ],
              ),
              const SizedBox(height: 10),

              if (fee.variesLocally)
                Text(
                  t('confirm_at_office'),
                  style: AppTextStyles.headline.copyWith(color: AppColors.accent),
                )
              else
                for (final tier in fee.tiers) _TierRow(tier: tier),
              if (fee.notes != null) ...[
                const SizedBox(height: 12),
                Text(fee.notes!, style: AppTextStyles.bodyMuted),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({required this.tier});

  final FeeTier tier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(tier.label, style: AppTextStyles.body)),
          const SizedBox(width: 12),
          Text(
            tier.amountText,
            style: AppTextStyles.figure.copyWith(fontSize: 20),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
