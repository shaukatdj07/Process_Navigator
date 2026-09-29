import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/process_step_model.dart';
import '../../../providers/profile_provider.dart';
import 'trip_cost_card.dart';

class OfficeTab extends StatelessWidget {
  const OfficeTab({super.key, required this.office});

  final OfficeInfo office;

  Future<void> _openDirections(BuildContext context, String? verifiedAddress) async {
    final t = AppStrings.of(context);
    if (verifiedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('trip_no_verified_office'))),
      );
      return;
    }
    final uri = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': verifiedAddress,
    });
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final city = context.watch<ProfileProvider>().profile.city;
    final address = office.addressFor(city);
    final isVerified = office.hasVerifiedAddressFor(city);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.accentMuted,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.location_city_rounded, color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(office.department, style: AppTextStyles.title)),
                ],
              ),
              const SizedBox(height: 16),
              _InfoRow(icon: Icons.place_outlined, label: t('address'), value: address),
              const SizedBox(height: 12),
              _InfoRow(icon: Icons.schedule_outlined, label: t('timings'), value: office.timings),
            ],
          ),
        ),
        if (!isVerified) ...[
          const SizedBox(height: 12),
          AppCard(
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
          variant: AppButtonVariant.secondary,
          onPressed: () => _openDirections(context, office.routingAddressFor(city)),
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
        Icon(icon, size: 18, color: AppColors.inkFaint),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.body),
            ],
          ),
        ),
      ],
    );
  }
}
