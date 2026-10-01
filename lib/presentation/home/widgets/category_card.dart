import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/content_text.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../data/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, required this.onTap});

  final CategoryModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);

    return AppCard(
      onTap: onTap,
      accentColor: AppColors.toneOf(category.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconBadge(icon: category.icon, color: AppColors.toneOf(category.id), size: 44),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ContentText.categoryName(context, category),
                style: AppTextStyles.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${category.processCount} ${t('guides_count')}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.toneOf(category.id),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
