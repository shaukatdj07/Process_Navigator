import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/process_step_model.dart';
import '../../../domain/trip_cost_calculator.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/trip_provider.dart';
import 'trip_rates_sheet.dart';

class TripCostCard extends StatelessWidget {
  const TripCostCard({super.key, required this.office});

  final OfficeInfo office;

  static const Map<TransportMode, IconData> _icons = {
    TransportMode.bike: Icons.two_wheeler_rounded,
    TransportMode.car: Icons.directions_car_rounded,
    TransportMode.rickshaw: Icons.electric_rickshaw_rounded,
    TransportMode.bus: Icons.directions_bus_rounded,
  };

  String _modeLabel(AppStrings t, TransportMode mode) {
    return switch (mode) {
      TransportMode.bike => t('mode_bike'),
      TransportMode.car => t('mode_car'),
      TransportMode.rickshaw => t('mode_rickshaw'),
      TransportMode.bus => t('mode_bus'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final trip = context.watch<TripProvider>();
    final city = context.watch<ProfileProvider>().profile.city;
    final isLoading = trip.status == TripStatus.loading;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t('trip_title'), style: AppTextStyles.title),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final mode in TransportMode.values)
                ChoiceChip(
                  avatar: Icon(
                    _icons[mode],
                    size: 18,
                    color: trip.mode == mode ? AppColors.surface : AppColors.ink,
                  ),
                  label: Text(_modeLabel(t, mode)),
                  selected: trip.mode == mode,
                  selectedColor: AppColors.accent,
                  labelStyle: AppTextStyles.body.copyWith(
                    color: trip.mode == mode ? AppColors.surface : AppColors.ink,
                  ),
                  showCheckmark: false,
                  onSelected: (_) => context.read<TripProvider>().selectMode(mode),
                ),
            ],
          ),
          const SizedBox(height: 14),
          AppButton(
            label: isLoading ? t('trip_calculating') : t('trip_calculate'),
            icon: Icons.route_rounded,
            isLoading: isLoading,
            onPressed: () => context.read<TripProvider>().calculate(office: office, userCity: city),
          ),
          if (trip.status == TripStatus.error && trip.errorKey != null) ...[
            const SizedBox(height: 12),
            _ErrorBlock(errorKey: trip.errorKey!),
          ],
          if (trip.status == TripStatus.ready && trip.result != null) ...[
            const SizedBox(height: 14),
            _ResultBlock(result: trip.result!, mode: trip.mode),
          ],
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => TripRatesSheet.show(context),
            child: Text(t('trip_edit_rates')),
          ),
        ],
      ),
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({required this.errorKey});

  final String errorKey;

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final needsSettings = errorKey == 'trip_location_denied_forever' || errorKey == 'trip_location_off';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(t(errorKey), style: AppTextStyles.bodyMuted)),
          ],
        ),
        if (needsSettings)
          TextButton(
            onPressed: () => context.read<TripProvider>().openLocationSettings(),
            child: Text(t('open_settings')),
          ),
      ],
    );
  }
}

class _ResultBlock extends StatelessWidget {
  const _ResultBlock({required this.result, required this.mode});

  final TripCost result;
  final TransportMode mode;

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);

    final missing = result.missingInput;
    final missingMessage = missing == TripCostCalculator.missingRickshawRate
        ? t('trip_missing_rickshaw_rate')
        : missing == TripCostCalculator.missingBusFare
            ? t('trip_missing_bus_fare')
            : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _line(t('trip_distance'), Money.km(result.distanceKm)),
          if (result.litresOneWay != null)
            _line(t('trip_fuel_used'), '${result.litresOneWay!.toStringAsFixed(2)} ${t('trip_litres')}'),
          if (missingMessage != null) ...[
            const SizedBox(height: 6),
            Text(missingMessage, style: AppTextStyles.bodyMuted),
          ] else ...[
            _line(t('trip_one_way'), Money.rs(result.oneWay!), bold: true),
            _line(t('trip_round'), Money.rs(result.roundTrip!), bold: true),
          ],
          const SizedBox(height: 8),
          Text(t('trip_estimate_note'), style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _line(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: AppTextStyles.body)),
          const SizedBox(width: 12),
          Text(
            value,
            style: bold ? AppTextStyles.title.copyWith(color: AppColors.accent) : AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}
