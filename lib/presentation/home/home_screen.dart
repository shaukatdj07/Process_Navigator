import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/section_header.dart';
import '../../providers/process_provider.dart';
import '../../providers/profile_provider.dart';
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

  void _openSavedDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SavedDetailsScreen()),
    );
  }

  void _openProcess(String processId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProcessDetailScreen(processId: processId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final provider = context.watch<ProcessProvider>();
    final padding = Responsive.pagePadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t('home_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: t('saved_details_title'),
            onPressed: _openSavedDetails,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: t('settings_title'),
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
          LoadStatus.error => EmptyState(
              icon: Icons.wifi_off_rounded,
              title: t('loading_error_title'),
              message: t('loading_error_message'),
            ),
          LoadStatus.loaded => _buildContent(context, provider, padding),
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProcessProvider provider, double padding) {
    final t = AppStrings.of(context);
    final columns = Responsive.gridColumns(context);
    final query = _searchController.text.trim();
    final isSearching = query.isNotEmpty;
    final profileEmpty = context.watch<ProfileProvider>().profile.city.isEmpty;

    return ListView(
      padding: EdgeInsets.fromLTRB(padding, 16, padding, 32),
      children: [
        if (!isSearching) ...[
          _HeroBanner(title: t('app_name'), tagline: t('app_tagline')),
          const SizedBox(height: 16),
        ],
        TextField(
          controller: _searchController,
          onChanged: (value) {
            provider.search(value);
            setState(() {});
          },
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: t('search_hint'),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.inkFaint),
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
        ),
        const SizedBox(height: 16),
        if (profileEmpty && !isSearching) ...[
          AppCard(
            accentColor: AppColors.highlight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('complete_profile_title'), style: AppTextStyles.title),
                const SizedBox(height: 4),
                Text(t('complete_profile_message'), style: AppTextStyles.bodyMuted),
                const SizedBox(height: 12),
                AppButton(
                  label: t('complete_profile_action'),
                  expand: false,
                  onPressed: _openSavedDetails,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        if (isSearching) ...[
          SectionHeader(title: '${t('results_for')} "$query"'),
          const SizedBox(height: 12),
          if (provider.searchResults.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: EmptyState(
                icon: Icons.search_off_rounded,
                title: t('no_results_title'),
                message: t('no_results_message'),
              ),
            )
          else
            ...provider.searchResults.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProcessTile(process: p, onTap: () => _openProcess(p.id)),
              ),
            ),
        ] else ...[
          SectionHeader(title: t('categories')),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              return CategoryCard(
                category: category,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProcessListScreen(category: category)),
                ),
              );
            },
          ),
          const SizedBox(height: 28),
          SectionHeader(title: t('popular_guides')),
          const SizedBox(height: 12),
          ...provider.allProcesses.take(5).map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProcessTile(
                    process: p,
                    onTap: () => _openProcess(p.id),
                  ),
                ),
              ),
        ],
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.title, required this.tagline});

  final String title;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x330B6E4F), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -18,
            bottom: -26,
            child: Icon(
              Icons.explore_rounded,
              size: 120,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.highlight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, size: 14, color: AppColors.onHighlight),
                    SizedBox(width: 4),
                    Text(
                      'VERIFIED GUIDES',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: AppColors.onHighlight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyles.displayLarge.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 60),
                child: Text(
                  tagline,
                  style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
