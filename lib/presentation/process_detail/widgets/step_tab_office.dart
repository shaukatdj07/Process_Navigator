import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../data/models/process_step_model.dart';
import '../../../providers/profile_provider.dart';
import 'trip_cost_card.dart';

class OfficeTab extends StatelessWidget {
  const OfficeTab({super.key, required this.office});

  final OfficeInfo office;

  Future<void> _openDirections(BuildContext context, String city) async {
    final t = AppStrings.read(context);
    final messenger = ScaffoldMessenger.of(context);
    final destination = office.routingAddressFor(city) ??
        (city.isEmpty ? office.department : '${office.department}, $city, Pakistan');
    final uri = Uri.https('www.google.com', '/maps/dir/', {'api': '1', 'destination': destination});
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) messenger.showSnackBar(SnackBar(content: Text(t('trip_network_error'))));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(t('trip_network_error'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final city = context.watch<ProfileProvider>().profile.city;
    final isVerified = office.hasVerifiedAddressFor(city);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        AppCard(
          accentColor: AppColors.accent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBadge(icon: Icons.location_city_rounded, size: 44),
                  const SizedBox(width: 12),
                  Expanded(child: Text(office.department, style: AppTextStyles.title)),
                ],
              ),
              const SizedBox(height: 16),
              _InfoRow(icon: Icons.place_rounded, label: t('address'), value: office.addressFor(city)),
              const SizedBox(height: 12),
              _InfoRow(icon: Icons.schedule_rounded, label: t('timings'), value: office.timings),
            ],
          ),
        ),
        if (!isVerified) ...[
          const SizedBox(height: 12),
          AppCard(
            accentColor: AppColors.warning,
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.warning),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    city.isEmpty
                        ? t('office_add_city')
                        : t.format('office_no_branch', {'city': city}),
                    style: AppTextStyles.bodyMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        TripCostCard(office: office),
        const SizedBox(height: 12),
        AppButton(
          label: t('get_directions'),
          icon: Icons.directions_rounded,
          onPressed: () => _openDirections(context, city),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.accent),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label.toUpperCase(), style: AppTextStyles.overline),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.body),
            ],
          ),
        ),
      ],
    );
  }
}
