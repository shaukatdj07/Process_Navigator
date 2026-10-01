import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/services/location_service.dart';
import '../../providers/profile_provider.dart';

class SavedDetailsScreen extends StatefulWidget {
  const SavedDetailsScreen({super.key});

  @override
  State<SavedDetailsScreen> createState() => _SavedDetailsScreenState();
}

class _SavedDetailsScreenState extends State<SavedDetailsScreen> {
  late final TextEditingController _name;
  late final TextEditingController _father;
  late final TextEditingController _city;
  late final TextEditingController _phone;
  late final TextEditingController _cnic;
  late final TextEditingController _vehicleType;
  DateTime? _licenseExpiry;
  DateTime? _passportExpiry;
  late bool _editing;

  @override
  void initState() {
    super.initState();
    final p = context.read<ProfileProvider>().profile;
    _editing = p.isEmpty;
    _name = TextEditingController(text: p.fullName);
    _father = TextEditingController(text: p.fatherName);
    _city = TextEditingController(text: p.city);
    _phone = TextEditingController(text: p.phone);
    _cnic = TextEditingController(text: p.cnic);
    _vehicleType = TextEditingController(text: p.vehicleType);
    _licenseExpiry = p.licenseExpiry;
    _passportExpiry = p.passportExpiry;
  }

  @override
  void dispose() {
    _name.dispose();
    _father.dispose();
    _city.dispose();
    _phone.dispose();
    _cnic.dispose();
    _vehicleType.dispose();
    super.dispose();
  }

  Future<void> _detectCity() async {
    final t = AppStrings.read(context);
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<ProfileProvider>();

    String message;
    try {
      final city = await provider.detectCity();
      if (city == null) {
        message = t('city_not_found');
      } else {
        _city.text = city;
        message = t.format('city_detected', {'city': city});
      }
    } on LocationException catch (e) {
      message = switch (e.reason) {
        LocationFailure.serviceOff => t('trip_location_off'),
        LocationFailure.denied => t('trip_location_denied'),
        LocationFailure.deniedForever => t('trip_location_denied_forever'),
        LocationFailure.unknown => t('trip_location_unknown'),
      };
    } catch (_) {
      message = t('trip_network_error');
    }
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    final t = AppStrings.read(context);
    final messenger = ScaffoldMessenger.of(context);
    final profile = UserProfileModel(
      fullName: _name.text.trim(),
      fatherName: _father.text.trim(),
      city: _city.text.trim(),
      phone: _phone.text.trim(),
      cnic: _cnic.text.trim(),
      vehicleType: _vehicleType.text.trim(),
      licenseExpiry: _licenseExpiry,
      passportExpiry: _passportExpiry,
    );
    await context.read<ProfileProvider>().save(profile);
    if (!mounted) return;
    setState(() => _editing = false);
    messenger.showSnackBar(SnackBar(content: Text(t('saved_snack'))));
  }

  void _startEditing() {
    final p = context.read<ProfileProvider>().profile;
    _name.text = p.fullName;
    _father.text = p.fatherName;
    _city.text = p.city;
    _phone.text = p.phone;
    _cnic.text = p.cnic;
    _vehicleType.text = p.vehicleType;
    setState(() {
      _licenseExpiry = p.licenseExpiry;
      _passportExpiry = p.passportExpiry;
      _editing = true;
    });
  }

  Future<void> _confirmErase() async {
    final t = AppStrings.read(context);
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<ProfileProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t('erase_confirm_title')),
        content: Text(t('erase_confirm_body')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t('erase'), style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await provider.eraseAll();
    _name.clear();
    _father.clear();
    _city.clear();
    _phone.clear();
    _cnic.clear();
    _vehicleType.clear();
    setState(() {
      _licenseExpiry = null;
      _passportExpiry = null;
      _editing = true;
    });
    messenger.showSnackBar(SnackBar(content: Text(t('erased_snack'))));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final padding = Responsive.pagePadding(context);
    final profileProvider = context.watch<ProfileProvider>();
    final detecting = profileProvider.isDetectingCity;

    if (!_editing) {
      return Scaffold(
        appBar: AppBar(title: Text(t('saved_details_title'))),
        body: _buildSummary(context, t, profileProvider.profile, padding),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(t('saved_details_title'))),
      body: ListView(
        padding: EdgeInsets.fromLTRB(padding, 16, padding, 32),
        children: [
          AppCard(
            child: Row(
              children: [
                Icon(Icons.lock_outline_rounded, color: AppColors.accent),
                const SizedBox(width: 12),
                Expanded(child: Text(t('saved_details_privacy'), style: AppTextStyles.bodyMuted)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppTextField(label: t('full_name'), optionalText: t('optional'), controller: _name),
          const SizedBox(height: 16),
          AppTextField(label: t('father_name'), optionalText: t('optional'), controller: _father),
          const SizedBox(height: 16),
          AppTextField(label: t('city_district'), optionalText: t('optional'), controller: _city),
          const SizedBox(height: 4),
          Text(t('city_helper'), style: AppTextStyles.caption),
          const SizedBox(height: 8),
          AppButton(
            label: t('use_my_location'),
            icon: Icons.my_location_rounded,
            variant: AppButtonVariant.secondary,
            isLoading: detecting,
            onPressed: _detectCity,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: t('phone_number'),
            optionalText: t('optional'),
            controller: _phone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: t('cnic_number'),
            optionalText: t('optional'),
            controller: _cnic,
            keyboardType: TextInputType.number,
            hint: t('cnic_hint'),
          ),
          const SizedBox(height: 16),
          AppTextField(label: t('vehicle_type'), optionalText: t('optional'), controller: _vehicleType),
          const SizedBox(height: 16),
          _DatePickerField(
            label: t('license_expiry'),
            optionalText: t('optional'),
            emptyText: t('set_reminder_date'),
            value: _licenseExpiry,
            onChanged: (d) => setState(() => _licenseExpiry = d),
          ),
          const SizedBox(height: 16),
          _DatePickerField(
            label: t('passport_expiry'),
            optionalText: t('optional'),
            emptyText: t('set_reminder_date'),
            value: _passportExpiry,
            onChanged: (d) => setState(() => _passportExpiry = d),
          ),
          const SizedBox(height: 28),
          AppButton(label: t('save_details'), onPressed: _save),
          if (!profileProvider.profile.isEmpty) ...[
            const SizedBox(height: 12),
            AppButton(
              label: t('cancel'),
              variant: AppButtonVariant.secondary,
              onPressed: () => setState(() => _editing = false),
            ),
          ],
          const SizedBox(height: 12),
          AppButton(
            label: t('erase_all'),
            variant: AppButtonVariant.text,
            onPressed: _confirmErase,
          ),
        ],
      ),
    );
  }
  String _mask(String cnic) {
    if (cnic.length <= 4) return cnic;
    return '${'•' * (cnic.length - 4)}${cnic.substring(cnic.length - 4)}';
  }

  Widget _buildSummary(BuildContext context, AppStrings t, UserProfileModel p, double padding) {
    final fmt = DateFormat('d MMM yyyy');
    final initial = p.fullName.trim().isEmpty ? '?' : p.fullName.trim()[0].toUpperCase();

    return ListView(
      padding: EdgeInsets.fromLTRB(padding, 16, padding, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Container(
                height: 56,
                width: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.highlight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  initial,
                  style: AppTextStyles.headline.copyWith(color: AppColors.onHighlight, fontSize: 24),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.fullName.isEmpty ? t('not_set') : p.fullName,
                      style: AppTextStyles.headline.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t('saved_details_ready'),
                      style: AppTextStyles.caption.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            children: [
              _SummaryRow(icon: Icons.family_restroom_rounded, label: t('father_name'), value: p.fatherName, empty: t('not_set')),
              _SummaryRow(icon: Icons.location_city_rounded, label: t('city_district'), value: p.city, empty: t('not_set')),
              _SummaryRow(icon: Icons.phone_rounded, label: t('phone_number'), value: p.phone, empty: t('not_set')),
              _SummaryRow(icon: Icons.badge_rounded, label: t('cnic_number'), value: _mask(p.cnic), empty: t('not_set'), isEmpty: p.cnic.isEmpty),
              _SummaryRow(icon: Icons.two_wheeler_rounded, label: t('vehicle_type'), value: p.vehicleType, empty: t('not_set')),
              _SummaryRow(
                icon: Icons.event_rounded,
                label: t('license_expiry'),
                value: p.licenseExpiry == null ? '' : fmt.format(p.licenseExpiry!),
                empty: t('not_set'),
              ),
              _SummaryRow(
                icon: Icons.flight_rounded,
                label: t('passport_expiry'),
                value: p.passportExpiry == null ? '' : fmt.format(p.passportExpiry!),
                empty: t('not_set'),
                last: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppButton(label: t('edit_details'), icon: Icons.edit_rounded, onPressed: _startEditing),
        const SizedBox(height: 12),
        AppButton(label: t('erase_all'), variant: AppButtonVariant.text, onPressed: _confirmErase),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.empty,
    this.isEmpty,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final String empty;
  final bool? isEmpty;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final blank = isEmpty ?? value.isEmpty;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label.toUpperCase(), style: AppTextStyles.overline),
                    const SizedBox(height: 2),
                    Text(
                      blank ? empty : value,
                      style: blank ? AppTextStyles.bodyMuted : AppTextStyles.title,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!last) const Divider(),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.optionalText,
    required this.emptyText,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String optionalText;
  final String emptyText;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label  ($optionalText)', style: AppTextStyles.title),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2050),
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.event_outlined, size: 18, color: AppColors.inkFaint),
                const SizedBox(width: 10),
                Text(
                  value == null ? emptyText : DateFormat('d MMM yyyy').format(value!),
                  style: value == null ? AppTextStyles.bodyMuted : AppTextStyles.body,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
