import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/user/home/cubit/home_cubit.dart';
import 'package:rehla/features/user/home/cubit/home_states.dart';
import 'package:rehla/features/user/home/models/category_model.dart';

class HomeCategoriesWidget extends StatelessWidget {
  const HomeCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.categories, style: AppTextStyles.titleMedium),
              GestureDetector(
                onTap: () => context.push(RouteNames.filter),
                child: Text(
                  AppStrings.viewAll,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (previous, current) =>
              current is HomeCategoryLoadingState ||
              current is HomeCategorySuccessState ||
              current is HomeCategoryErrorState,
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();

            if (state is HomeCategoryLoadingState ||
                (cubit.isCategoriesLoading && cubit.categories.isEmpty)) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (cubit.categories.isNotEmpty) {
              return SizedBox(
                height: 100,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: cubit.categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final CategoryModel category = cubit.categories[index];
                    return GestureDetector(
                      onTap: () {
                        context.push(
                          RouteNames.filter,
                          extra: category.id,
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: ClipOval(
                                  child: category.image.startsWith('http')
                                      ? Image.network(
                                          category.image,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return const Center(
                                              child: SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2),
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                            Icons.category_outlined,
                                            color: AppColors.primary,
                                            size: 24,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.category_outlined,
                                          color: AppColors.primary,
                                          size: 24,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.nameAr.isNotEmpty
                              ? category.nameAr
                              : category.nameEn,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }

            if (state is HomeCategoryErrorState) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Text(
                      "حدث خطأ أثناء تحميل الفئات",
                      style: TextStyle(color: AppColors.error),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          context.read<HomeCubit>().getAllCategories(),
                      child: const Text("إعادة المحاولة"),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
