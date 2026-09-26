import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_card.dart';
import '../../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final padding = Responsive.pagePadding(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(padding, 16, padding, 32),
        children: [
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Language', style: AppTextStyles.title),
                      const SizedBox(height: 4),
                      Text(
                        locale.isUrdu ? 'اردو (Urdu)' : 'English',
                        style: AppTextStyles.bodyMuted,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: locale.isUrdu,
                  activeColor: AppColors.accent,
                  onChanged: (_) => locale.toggle(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.wifi_off_rounded, color: AppColors.accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Saved guides and your profile work fully offline.',
                    style: AppTextStyles.bodyMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('About', style: AppTextStyles.title),
                const SizedBox(height: 6),
                Text(
                  '${AppConstants.appName} — ${AppConstants.tagline}',
                  style: AppTextStyles.bodyMuted,
                ),
                const SizedBox(height: 4),
                const Text('Version 1.0.0', style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
