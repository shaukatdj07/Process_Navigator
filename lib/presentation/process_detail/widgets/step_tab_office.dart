import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/process_step_model.dart';

class OfficeTab extends StatelessWidget {
  const OfficeTab({super.key, required this.office});

  final OfficeInfo office;

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
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.accentMuted,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.location_city_rounded,
                        color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(office.name, style: AppTextStyles.title),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _InfoRow(icon: Icons.place_outlined, label: 'Address', value: office.address),
              const SizedBox(height: 12),
              _InfoRow(icon: Icons.schedule_outlined, label: 'Timings', value: office.timings),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Get directions',
          icon: Icons.directions_rounded,
          variant: AppButtonVariant.secondary,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Map directions open once your city is set in Saved Details.'),
              ),
            );
          },
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
