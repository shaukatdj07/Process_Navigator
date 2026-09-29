import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/localization/content_text.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../data/models/process_model.dart';
import '../../data/repositories/process_repository.dart';
import '../../providers/checklist_provider.dart';
import '../report/report_issue_sheet.dart';
import 'widgets/source_badge.dart';
import 'widgets/step_tab_documents.dart';
import 'widgets/step_tab_fee.dart';
import 'widgets/step_tab_next.dart';
import 'widgets/step_tab_office.dart';
import 'widgets/step_tab_submit.dart';

class ProcessDetailScreen extends StatefulWidget {
  const ProcessDetailScreen({super.key, required this.processId});

  final String processId;

  @override
  State<ProcessDetailScreen> createState() => _ProcessDetailScreenState();
}

class _ProcessDetailScreenState extends State<ProcessDetailScreen> {
  ProcessModel? _process;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = context.read<ProcessRepository>();
    final process = await repo.getProcessById(widget.processId);
    if (!mounted) return;
    setState(() {
      _process = process;
      _loading = false;
    });
    if (process != null) {
      await context.read<ChecklistProvider>().loadFor(process.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);

    if (_loading) return const Scaffold(body: LoadingIndicator());

    final process = _process;
    if (process == null) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: Icons.error_outline_rounded,
          title: t('not_found_title'),
          message: t('not_found_message'),
        ),
      );
    }

    final title = ContentText.processTitle(context, process);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.inkMuted,
            indicatorColor: AppColors.accent,
            labelStyle: AppTextStyles.title,
            tabs: [
              Tab(text: t('tab_documents')),
              Tab(text: t('tab_office')),
              Tab(text: t('tab_fee')),
              Tab(text: t('tab_submit')),
              Tab(text: t('tab_next')),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SourceBadge(
                source: process.source,
                onReport: () => ReportIssueSheet.show(context, title),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  DocumentsTab(processId: process.id, documents: process.documents),
                  OfficeTab(office: process.office),
                  FeeTab(fee: process.fee),
                  SubmitTab(submit: process.submit),
                  NextStepTab(nextStep: process.nextStep),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
