import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/process_step_model.dart';

class NextStepTab extends StatelessWidget {
  const NextStepTab({super.key, required this.nextStep});

  final NextStepInfo nextStep;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.accent),
                  const SizedBox(width: 10),
                  const Text('Expected timeline', style: AppTextStyles.title),
                ],
              ),
              const SizedBox(height: 8),
              Text(nextStep.timeline, style: AppTextStyles.body),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.flag_outlined, color: AppColors.accent),
                  const SizedBox(width: 10),
                  const Text('Follow-up', style: AppTextStyles.title),
                ],
              ),
              const SizedBox(height: 8),
              Text(nextStep.followUp, style: AppTextStyles.body),
            ],
          ),
        ),
      ],
    );
  }
}
