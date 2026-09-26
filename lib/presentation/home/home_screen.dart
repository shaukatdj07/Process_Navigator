import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/section_header.dart';
import '../../providers/process_provider.dart';
import '../process_detail/process_detail_screen.dart';
import '../process_list/process_list_screen.dart';
import '../process_list/widgets/process_tile.dart';
import '../profile/saved_details_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProcessProvider>();
    final padding = Responsive.pagePadding(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'Saved Details',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SavedDetailsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: provider.loadHome,
        child: switch (provider.status) {
          LoadStatus.loading || LoadStatus.idle => const LoadingIndicator(),
          LoadStatus.error => const EmptyState(
              icon: Icons.wifi_off_rounded,
              title: 'Something went wrong',
              message: 'Pull down to try loading guides again.',
            ),
          LoadStatus.loaded => _buildContent(context, provider, padding),
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProcessProvider provider,
    double padding,
  ) {
    final columns = Responsive.gridColumns(context);
    final isSearching = _searchController.text.trim().isNotEmpty;

    return ListView(
      padding: EdgeInsets.fromLTRB(padding, 16, padding, 32),
      children: [
        TextField(
          controller: _searchController,
          onChanged: provider.search,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search a process, e.g. "transfer vehicle"',
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.inkFaint),
            suffixIcon: isSearching
                ? IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _searchController.clear();
                      provider.clearSearch();
                      setState(() {});
                    },
                  )
                : null,
          ),
          onSubmitted: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),
        if (isSearching) ...[
          SectionHeader(title: 'Results for "${_searchController.text.trim()}"'),
          const SizedBox(height: 12),
          if (provider.searchResults.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: EmptyState(
                icon: Icons.search_off_rounded,
                title: 'No matching guide yet',
                message: 'Try a different keyword, like the office or document name.',
              ),
            )
          else
            ...provider.searchResults.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProcessTile(
                  process: p,
                  onTap: () => _openProcess(context, p.id),
                ),
              ),
            ),
        ] else ...[
          const SectionHeader(title: 'Categories'),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.25,
            ),
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              return CategoryCard(
                category: category,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProcessListScreen(category: category),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 28),
          const SectionHeader(title: 'Popular guides'),
          const SizedBox(height: 12),
          ...provider.allProcesses.take(4).map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProcessTile(
                    process: p,
                    onTap: () => _openProcess(context, p.id),
                  ),
                ),
              ),
        ],
      ],
    );
  }

  void _openProcess(BuildContext context, String processId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProcessDetailScreen(processId: processId),
      ),
    );
  }
}
