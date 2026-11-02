import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/process_step_model.dart';

class SourceBadge extends StatelessWidget {
  const SourceBadge({super.key, required this.source, required this.onReport});

  final SourceInfo source;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final verified = DateFormat('d MMM yyyy').format(source.lastVerified);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _openSource(source.url),
                  child: Text(
                    source.sourceName,
                    style: AppTextStyles.link,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text('${t('verified_on')} $verified', style: AppTextStyles.caption),
              ],
            ),
          ),
          TextButton(onPressed: onReport, child: Text(t('report'))),
        ],
      ),
    );
  }

  Future<void> _openSource(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
