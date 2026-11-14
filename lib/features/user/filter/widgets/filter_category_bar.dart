import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/user/filter/cubit/filter_cubit.dart';
import 'package:rehla/features/user/home/models/category_model.dart';

class FilterCategoryBar extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selectedCategoryId;

  const FilterCategoryBar({
    super.key,
    required this.categories,
    this.selectedCategoryId,
  });

  bool _isSelected(String? categoryId) {
    if (categoryId == null) {
      return selectedCategoryId == null || selectedCategoryId!.isEmpty;
    }
    return selectedCategoryId == categoryId;
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    String? imageUrl,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty) ...[
              SizedBox(
                width: 18,
                height: 18,
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.category_outlined,
                      size: 14,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FilterCubit>();

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" chip
            final isAllSelected = _isSelected(null);
            return _buildChip(
              context: context,
              label: AppStrings.all,
              isSelected: isAllSelected,
              onTap: () => cubit.selectCategory(null),
            );
          }

          final category = categories[index - 1];
          final isSelected = _isSelected(category.id) ||
              _isSelected(category.nameAr) ||
              _isSelected(category.slug);

          final label = category.nameAr.isNotEmpty
              ? category.nameAr
              : category.nameEn;

          return _buildChip(
            context: context,
            label: label,
            imageUrl: category.image.startsWith('http') ? category.image : null,
            isSelected: isSelected,
            onTap: () => cubit.selectCategory(category.id),
          );
        },
      ),
    );
  }
}
