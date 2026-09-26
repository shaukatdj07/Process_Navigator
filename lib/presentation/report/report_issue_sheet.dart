import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';

/// "Report outdated info" in two taps, per the product spec.
class ReportIssueSheet extends StatefulWidget {
  const ReportIssueSheet({super.key, required this.processTitle});

  final String processTitle;

  static Future<void> show(BuildContext context, String processTitle) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReportIssueSheet(processTitle: processTitle),
    );
  }

  @override
  State<ReportIssueSheet> createState() => _ReportIssueSheetState();
}

class _ReportIssueSheetState extends State<ReportIssueSheet> {
  String? _selectedReason;
  bool _sent = false;

  static const _reasons = [
    'Fee amount is wrong',
    'Document requirement changed',
    'Office moved or closed',
    'Something else',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: _sent ? _buildConfirmation() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Report outdated info', style: AppTextStyles.headline),
        const SizedBox(height: 4),
        Text(widget.processTitle, style: AppTextStyles.bodyMuted),
        const SizedBox(height: 16),
        for (final reason in _reasons)
          RadioListTile<String>(
            value: reason,
            groupValue: _selectedReason,
            onChanged: (v) => setState(() => _selectedReason = v),
            title: Text(reason, style: AppTextStyles.body),
            activeColor: AppColors.accent,
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Send report',
          onPressed: _selectedReason == null
              ? null
              : () => setState(() => _sent = true),
        ),
      ],
    );
  }

  Widget _buildConfirmation() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 44),
        const SizedBox(height: 12),
        Text('Thanks — sent to the review team', style: AppTextStyles.title),
        const SizedBox(height: 6),
        Text(
          'We\'ll verify and update this guide.',
          style: AppTextStyles.bodyMuted,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Done',
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
