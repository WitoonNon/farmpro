import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/category_model.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        final categories = controller.categories;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section Header ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('หมวดหมู่', style: AppTextStyles.headlineSmall),
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to full category list
                    },
                    child: Row(
                      children: [
                        Text('ทั้งหมด', style: AppTextStyles.seeAllLink),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Horizontal Scrollable Tiles ─────────────────────────────────
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected =
                      controller.selectedCategoryId == category.id;

                  return _CategoryTile(
                    category: category,
                    isSelected: isSelected,
                    onTap: () => controller.selectCategory(category.id),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Individual Category Tile ─────────────────────────────────────────────────

class _CategoryTile extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 76,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon Circle ─────────────────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isSelected
                      ? category.iconColor.withOpacity(0.18)
                      : category.backgroundColor,
                  borderRadius: BorderRadius.circular(18),
                  border: isSelected
                      ? Border.all(
                          color: category.iconColor,
                          width: 2.5,
                        )
                      : Border.all(
                          color: category.backgroundColor,
                          width: 2.5,
                        ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: category.iconColor.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Center(
                  child: Text(
                    category.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ── Category Name ────────────────────────────────────────────
              Text(
                category.name,
                style: AppTextStyles.categoryName.copyWith(
                  color: isSelected
                      ? category.iconColor
                      : AppColors.textPrimary,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Compact Chip List variant (used in Product List Screen) ──────────────────

class CategoryChipList extends StatelessWidget {
  const CategoryChipList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        final categories = controller.categories;

        return SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // "ทั้งหมด" chip
              _buildChip(
                label: 'ทั้งหมด',
                emoji: '🛒',
                isSelected: controller.selectedCategoryId == null,
                iconColor: AppColors.primary,
                bgColor: AppColors.primaryContainer,
                onTap: controller.clearCategoryFilter,
              ),

              const SizedBox(width: 8),

              // Category chips
              ...List.generate(categories.length, (index) {
                final cat = categories[index];
                final isSelected = controller.selectedCategoryId == cat.id;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildChip(
                    label: cat.name,
                    emoji: cat.emoji,
                    isSelected: isSelected,
                    iconColor: cat.iconColor,
                    bgColor: cat.backgroundColor,
                    onTap: () => controller.selectCategory(cat.id),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip({
    required String label,
    required String emoji,
    required bool isSelected,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? iconColor : bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: iconColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
