import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/process_step_model.dart';

class SubmitTab extends StatelessWidget {
  const SubmitTab({super.key, required this.submit});

  final SubmitInfo submit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        for (var i = 0; i < submit.instructions.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 26,
                    width: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.accentMuted,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(submit.instructions[i], style: AppTextStyles.body)),
                ],
              ),
            ),
          ),
        const SizedBox(height: 4),
        AppCard(
          child: Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: AppColors.warning),
              const SizedBox(width: 12),
              Expanded(child: Text(submit.receiptNote, style: AppTextStyles.bodyMuted)),
            ],
          ),
        ),
      ],
    );
  }
}
