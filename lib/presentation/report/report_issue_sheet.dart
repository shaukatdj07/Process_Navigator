import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';

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

  static const _reasonKeys = ['reason_fee', 'reason_document', 'reason_office', 'reason_other'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: _sent ? _buildConfirmation(context) : _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    final t = AppStrings.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t('report_title'), style: AppTextStyles.headline),
        const SizedBox(height: 4),
        Text(widget.processTitle, style: AppTextStyles.bodyMuted),
        const SizedBox(height: 16),
        for (final key in _reasonKeys)
          RadioListTile<String>(
            value: key,
            groupValue: _selectedReason,
            onChanged: (v) => setState(() => _selectedReason = v),
            title: Text(t(key), style: AppTextStyles.body),
            activeColor: AppColors.accent,
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        const SizedBox(height: 12),
        AppButton(
          label: t('send_report'),
          onPressed: _selectedReason == null ? null : () => setState(() => _sent = true),
        ),
      ],
    );
  }

  Widget _buildConfirmation(BuildContext context) {
    final t = AppStrings.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 44),
        const SizedBox(height: 12),
        Text(t('report_sent_title'), style: AppTextStyles.title),
        const SizedBox(height: 6),
        Text(t('report_sent_body'), style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        AppButton(
          label: t('done'),
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
