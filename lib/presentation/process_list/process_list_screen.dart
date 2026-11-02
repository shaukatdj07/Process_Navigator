import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/localization/content_text.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/category_model.dart';
import '../../providers/process_provider.dart';
import '../process_detail/process_detail_screen.dart';
import 'widgets/process_tile.dart';

class ProcessListScreen extends StatelessWidget {
  const ProcessListScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final processes = context.watch<ProcessProvider>().processesFor(category.id);
    final padding = Responsive.pagePadding(context);

    return Scaffold(
      appBar: AppBar(title: Text(ContentText.categoryName(context, category))),
      body: processes.isEmpty
          ? EmptyState(
              icon: Icons.inbox_rounded,
              title: t('no_guides_title'),
              message: t('no_guides_message'),
            )
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(padding, 16, padding, 32),
              itemCount: processes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final process = processes[index];
                return ProcessTile(
                  process: process,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProcessDetailScreen(processId: process.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
