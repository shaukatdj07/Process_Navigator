import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/document_item_model.dart';
import '../../../providers/checklist_provider.dart';

class DocumentsTab extends StatelessWidget {
  const DocumentsTab({
    super.key,
    required this.processId,
    required this.documents,
  });

  final String processId;
  final List<DocumentItemModel> documents;

  @override
  Widget build(BuildContext context) {
    final checklist = context.watch<ChecklistProvider>();
    final checkedCount = checklist.checkedFor(processId).length;
    final progress = documents.isEmpty ? 0.0 : checkedCount / documents.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Your progress', style: AppTextStyles.title),
                  Text('$checkedCount / ${documents.length}',
                      style: AppTextStyles.bodyMuted),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceMuted,
                  valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...documents.map((doc) {
          final checked = checklist.isChecked(processId, doc.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              onTap: () => checklist.toggle(processId, doc.id),
              child: Row(
                children: [
                  Checkbox(
                    value: checked,
                    onChanged: (_) => checklist.toggle(processId, doc.id),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.title,
                          style: AppTextStyles.body.copyWith(
                            decoration:
                                checked ? TextDecoration.lineThrough : null,
                            color: checked
                                ? AppColors.inkFaint
                                : AppColors.ink,
                          ),
                        ),
                        Text(
                          '${doc.copies} ${doc.copies == 1 ? 'copy' : 'copies'}'
                          '${doc.attestationRequired ? ' • attestation required' : ''}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
