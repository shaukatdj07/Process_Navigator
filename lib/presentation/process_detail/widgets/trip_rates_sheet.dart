import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/trip_settings_model.dart';
import '../../../providers/trip_provider.dart';

// Yahan user petrol ki qeemat, average aur rickshaw ya bus ka kiraya
// khud likhta hai, kyunke yeh cheezein rozana ya shehar ke hisab se badalti hain.
class TripRatesSheet extends StatefulWidget {
  const TripRatesSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const TripRatesSheet(),
    );
  }

  @override
  State<TripRatesSheet> createState() => _TripRatesSheetState();
}

class _TripRatesSheetState extends State<TripRatesSheet> {
  late final TextEditingController _petrol;
  late final TextEditingController _bike;
  late final TextEditingController _car;
  late final TextEditingController _rickshaw;
  late final TextEditingController _bus;

  @override
  void initState() {
    super.initState();
    final s = context.read<TripProvider>().settings;
    _petrol = TextEditingController(text: _show(s.petrolPrice));
    _bike = TextEditingController(text: _show(s.bikeKmPerLitre));
    _car = TextEditingController(text: _show(s.carKmPerLitre));
    _rickshaw = TextEditingController(text: s.rickshawRatePerKm == null ? '' : _show(s.rickshawRatePerKm!));
    _bus = TextEditingController(text: s.busFare == null ? '' : _show(s.busFare!));
  }

  String _show(double value) {
    return value == value.roundToDouble() ? value.toInt().toString() : value.toString();
  }

  double? _read(TextEditingController controller) {
    final text = controller.text.trim().replaceAll(',', '');
    if (text.isEmpty) return null;
    final value = double.tryParse(text);
    return (value == null || value <= 0) ? null : value;
  }

  Future<void> _save() async {
    final provider = context.read<TripProvider>();
    final current = provider.settings;
    final updated = TripSettingsModel(
      petrolPrice: _read(_petrol) ?? current.petrolPrice,
      bikeKmPerLitre: _read(_bike) ?? current.bikeKmPerLitre,
      carKmPerLitre: _read(_car) ?? current.carKmPerLitre,
      rickshawRatePerKm: _read(_rickshaw),
      busFare: _read(_bus),
    );
    await provider.saveSettings(updated);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _petrol.dispose();
    _bike.dispose();
    _car.dispose();
    _rickshaw.dispose();
    _bus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('trip_rates_title'), style: AppTextStyles.headline),
            const SizedBox(height: 16),
            _field(t('trip_petrol_price'), _petrol, note: t('trip_petrol_note')),
            _field(t('trip_bike_mileage'), _bike),
            _field(t('trip_car_mileage'), _car, note: t('trip_mileage_note')),
            _field(t('trip_rickshaw_rate'), _rickshaw, note: t('trip_rickshaw_note')),
            _field(t('trip_bus_fare'), _bus, note: t('trip_bus_note')),
            const SizedBox(height: 8),
            AppButton(label: t('trip_save'), onPressed: _save),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, {String? note}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.title),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          if (note != null) ...[
            const SizedBox(height: 4),
            Text(note, style: AppTextStyles.caption),
          ],
        ],
      ),
    );
  }
}
