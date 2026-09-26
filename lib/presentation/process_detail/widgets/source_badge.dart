import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/process_step_model.dart';

class SourceBadge extends StatelessWidget {
  const SourceBadge({super.key, required this.source, required this.onReport});

  final SourceInfo source;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text('Verified $verified', style: AppTextStyles.caption),
              ],
            ),
          ),
          TextButton(
            onPressed: onReport,
            child: const Text('Report'),
          ),
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
