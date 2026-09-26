import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/process_step_model.dart';

class FeeTab extends StatelessWidget {
  const FeeTab({super.key, required this.fee});

  final FeeInfo fee;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Official fee', style: AppTextStyles.title),
              const SizedBox(height: 6),
              Text(
                fee.baseFee == 0 ? 'Free' : 'Rs. ${fee.baseFee}',
                style: AppTextStyles.displayLarge.copyWith(color: AppColors.accent),
              ),
              if (fee.notes != null) ...[
                const SizedBox(height: 8),
                Text(fee.notes!, style: AppTextStyles.bodyMuted),
              ],
            ],
          ),
        ),
        if (fee.dependsOnVehicleType) ...[
          const SizedBox(height: 16),
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.calculate_outlined, color: AppColors.accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Save your vehicle type in Saved Details to see an estimate pre-filled here automatically.',
                    style: AppTextStyles.bodyMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
