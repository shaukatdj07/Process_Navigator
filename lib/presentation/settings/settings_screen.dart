import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/icon_badge.dart';
import '../../core/widgets/choice_selector.dart';
import '../../core/widgets/settings_section.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final locale = context.watch<LocaleProvider>();
    final theme = context.watch<ThemeProvider>();
    final padding = Responsive.pagePadding(context);

    return Scaffold(
      appBar: AppBar(title: Text(t('settings_title'))),
      body: ListView(
        padding: EdgeInsets.fromLTRB(padding, 16, padding, 32),
        children: [
          SettingsSection(
            icon: Icons.palette_rounded,
            title: t('appearance'),
            child: ChoiceSelector<ThemeMode>(
              value: theme.mode,
              onChanged: (mode) => context.read<ThemeProvider>().setMode(mode),
              options: [
                ChoiceOption(value: ThemeMode.system, label: t('theme_system'), icon: Icons.brightness_auto_rounded),
                ChoiceOption(value: ThemeMode.light, label: t('theme_light'), icon: Icons.light_mode_rounded),
                ChoiceOption(value: ThemeMode.dark, label: t('theme_dark'), icon: Icons.dark_mode_rounded),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SettingsSection(
            icon: Icons.translate_rounded,
            title: t('language'),
            child: ChoiceSelector<bool>(
              value: locale.isUrdu,
              onChanged: (isUrdu) {
                if (isUrdu != context.read<LocaleProvider>().isUrdu) {
                  context.read<LocaleProvider>().toggle();
                }
              },
              options: const [
                ChoiceOption(value: false, label: 'English'),
                ChoiceOption(value: true, label: 'اردو'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Row(
              children: [
                IconBadge(icon: Icons.explore_rounded, size: 48),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t('app_name'), style: AppTextStyles.title),
                      const SizedBox(height: 2),
                      Text('${t('version')} 1.0.0', style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
