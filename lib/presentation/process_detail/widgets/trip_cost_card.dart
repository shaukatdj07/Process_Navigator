import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../data/models/process_step_model.dart';
import '../../../domain/trip_cost_calculator.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/trip_provider.dart';
import 'trip_rates_sheet.dart';

class TripCostCard extends StatefulWidget {
  const TripCostCard({super.key, required this.office});

  final OfficeInfo office;

  @override
  State<TripCostCard> createState() => _TripCostCardState();
}

class _TripCostCardState extends State<TripCostCard> {
  static const double _maxKm = 3000;

  static const Map<TransportMode, IconData> _icons = {
    TransportMode.bike: Icons.two_wheeler_rounded,
    TransportMode.car: Icons.directions_car_rounded,
    TransportMode.rickshaw: Icons.electric_rickshaw_rounded,
    TransportMode.bus: Icons.directions_bus_rounded,
  };

  final TextEditingController _distance = TextEditingController();

  @override
  void dispose() {
    _distance.dispose();
    super.dispose();
  }

  double? get _km {
    final value = double.tryParse(_distance.text.trim().replaceAll(',', '.'));
    if (value == null || value <= 0 || value > _maxKm) return null;
    return value;
  }

  String _modeLabel(AppStrings t, TransportMode mode) {
    return switch (mode) {
      TransportMode.bike => t('mode_bike'),
      TransportMode.car => t('mode_car'),
      TransportMode.rickshaw => t('mode_rickshaw'),
      TransportMode.bus => t('mode_bus'),
    };
  }

  Future<void> _useMyLocation(String address) async {
    final km = await context.read<TripProvider>().distanceFromMyLocation(address);
    if (!mounted || km == null) return;
    setState(() => _distance.text = km.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final trip = context.watch<TripProvider>();
    final city = context.watch<ProfileProvider>().profile.city;
    final verifiedAddress = widget.office.routingAddressFor(city);
    final isLoading = trip.locationStatus == LocationStatus.loading;
    final km = _km;
    final cost = km == null
        ? null
        : TripCostCalculator.calculate(mode: trip.mode, distanceKm: km, settings: trip.settings);

    return AppCard(
      accentColor: AppColors.highlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(icon: Icons.route_rounded, color: AppColors.highlight, size: 40),
              const SizedBox(width: 12),
              Expanded(child: Text(t('trip_title'), style: AppTextStyles.title)),
            ],
          ),
          const SizedBox(height: 14),
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
                  backgroundColor: AppColors.surface,
                  labelStyle: AppTextStyles.body.copyWith(
                    color: trip.mode == mode ? AppColors.surface : AppColors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                  showCheckmark: false,
                  onSelected: (_) => context.read<TripProvider>().selectMode(mode),
                ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _distance,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            onChanged: (_) {
              context.read<TripProvider>().clearError();
              setState(() {});
            },
            decoration: InputDecoration(
              labelText: t('trip_distance_label'),
              suffixText: 'km',
              prefixIcon: const Icon(Icons.straighten_rounded),
            ),
          ),
          if (verifiedAddress != null) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              icon: isLoading
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
                    )
                  : const Icon(Icons.my_location_rounded, size: 18),
              label: Text(isLoading ? t('trip_calculating') : t('trip_use_location')),
              onPressed: isLoading ? null : () => _useMyLocation(verifiedAddress),
            ),
          ],
          if (trip.locationStatus == LocationStatus.error && trip.errorKey != null)
            _ErrorBlock(errorKey: trip.errorKey!),
          const SizedBox(height: 14),
          if (cost == null)
            Text(t('trip_enter_distance'), style: AppTextStyles.bodyMuted)
          else
            _ResultBlock(cost: cost, km: km!, modeLabel: _modeLabel(t, trip.mode)),
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
  const _ResultBlock({required this.cost, required this.km, required this.modeLabel});

  final TripCost cost;
  final double km;
  final String modeLabel;

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _line(Icons.commute_rounded, '${t('trip_vehicle')}: $modeLabel', bold: true),
          const SizedBox(height: 4),
          _line(Icons.straighten_rounded, '${t('trip_distance')}: ${Money.km(km)}'),
          if (cost.litres != null) ...[
            const SizedBox(height: 4),
            _line(
              Icons.local_gas_station_rounded,
              '${t('trip_fuel_used')}: ${cost.litres!.toStringAsFixed(2)} ${t('trip_litres')}',
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _figure(t('trip_one_way'), Money.rs(cost.oneWay))),
              Container(width: 1, height: 44, color: Colors.white24),
              const SizedBox(width: 16),
              Expanded(child: _figure(t('trip_round'), Money.rs(cost.roundTrip))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            t('trip_estimate_note'),
            style: AppTextStyles.caption.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _line(IconData icon, String text, {bool bold = false}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.highlight, size: 18),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _figure(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.overline.copyWith(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.figure.copyWith(color: AppColors.highlight)),
      ],
    );
  }
}
