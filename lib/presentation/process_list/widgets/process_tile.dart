import 'package:flutter/material.dart';
import '../../../core/localization/content_text.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/process_model.dart';

class ProcessTile extends StatelessWidget {
  const ProcessTile({super.key, required this.process, required this.onTap});

  final ProcessModel process;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      accentColor: AppColors.toneOf(process.categoryId),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ContentText.processTitle(context, process),
                  style: AppTextStyles.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  ContentText.processSummary(context, process),
                  style: AppTextStyles.bodyMuted,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios_rounded, color: AppColors.inkFaint, size: 16),
        ],
      ),
    );
  }
}
