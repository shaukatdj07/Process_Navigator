import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

/// Ordered step-by-step guide for a single process: documents, office,
/// fee, submit, and next-step — each with its own tab, matching the
/// product's five-part checklist.
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
    if (_loading) {
      return const Scaffold(body: LoadingIndicator());
    }
    final process = _process;
    if (process == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Guide not found',
          message: 'This guide may have been moved or renamed.',
        ),
      );
    }

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            process.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.inkMuted,
            indicatorColor: AppColors.accent,
            labelStyle: AppTextStyles.title,
            tabs: [
              Tab(text: 'Documents'),
              Tab(text: 'Office'),
              Tab(text: 'Fee'),
              Tab(text: 'Submit'),
              Tab(text: 'Next'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SourceBadge(
                source: process.source,
                onReport: () =>
                    ReportIssueSheet.show(context, process.title),
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
