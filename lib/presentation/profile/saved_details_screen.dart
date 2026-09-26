import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../data/models/user_profile_model.dart';
import '../../providers/profile_provider.dart';

/// "Saved Details (My Profile)" — every field is optional. Nothing is
/// uploaded; CNIC and dates are kept only in local encrypted storage.
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
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    if (!_initialized) {
      final p = profileProvider.profile;
      _name = TextEditingController(text: p.fullName);
      _father = TextEditingController(text: p.fatherName);
      _city = TextEditingController(text: p.city);
      _phone = TextEditingController(text: p.phone);
      _cnic = TextEditingController(text: p.cnic);
      _vehicleType = TextEditingController(text: p.vehicleType);
      _licenseExpiry = p.licenseExpiry;
      _passportExpiry = p.passportExpiry;
      _initialized = true;
    }

    final padding = Responsive.pagePadding(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Details')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(padding, 16, padding, 32),
        children: [
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.lock_outline_rounded, color: AppColors.accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Everything here stays on this device. Nothing is uploaded, and every field is optional.',
                    style: AppTextStyles.bodyMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppTextField(label: 'Full name', controller: _name),
          const SizedBox(height: 16),
          AppTextField(label: "Father's name", controller: _father),
          const SizedBox(height: 16),
          AppTextField(label: 'City / district', controller: _city),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Phone number',
            controller: _phone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'CNIC number',
            controller: _cnic,
            keyboardType: TextInputType.number,
            hint: 'Stored encrypted, never uploaded',
          ),
          const SizedBox(height: 16),
          AppTextField(label: 'Vehicle type', controller: _vehicleType),
          const SizedBox(height: 16),
          _DatePickerField(
            label: 'License expiry',
            value: _licenseExpiry,
            onChanged: (d) => setState(() => _licenseExpiry = d),
          ),
          const SizedBox(height: 16),
          _DatePickerField(
            label: 'Passport expiry',
            value: _passportExpiry,
            onChanged: (d) => setState(() => _passportExpiry = d),
          ),
          const SizedBox(height: 28),
          AppButton(label: 'Save details', onPressed: _save),
          const SizedBox(height: 12),
          AppButton(
            label: 'Erase all my data',
            variant: AppButtonVariant.text,
            onPressed: _confirmErase,
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved details updated')),
    );
  }

  Future<void> _confirmErase() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erase all my data?'),
        content: const Text(
          'This clears everything saved on this device, including your CNIC and reminders. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Erase', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await context.read<ProfileProvider>().eraseAll();
    if (!mounted) return;
    setState(() {
      _initialized = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All saved details erased')),
    );
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
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label  (optional)', style: AppTextStyles.title),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2040),
            );
            onChanged(picked);
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
                const Icon(Icons.event_outlined, size: 18, color: AppColors.inkFaint),
                const SizedBox(width: 10),
                Text(
                  value == null
                      ? 'Set a reminder date'
                      : DateFormat('d MMM yyyy').format(value!),
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
