import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/core/widgets/app_button.dart';
import 'package:rehla/core/widgets/app_text_feild.dart';
import 'package:rehla/features/user/filter/cubit/filter_cubit.dart';
import 'package:rehla/features/user/filter/cubit/filter_states.dart';
import 'package:rehla/features/user/filter/widgets/filter_category_bar.dart';
import 'package:rehla/features/user/filter/widgets/filter_trip_card.dart';

class FilterScreen extends StatelessWidget {
  final String? initialCategoryId;
  final String? initialQuery;

  const FilterScreen({
    super.key,
    this.initialCategoryId,
    this.initialQuery,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterCubit()
        ..loadFilterData(
          initialCategoryId: initialCategoryId,
          initialQuery: initialQuery,
        ),
      child: _FilterView(
        initialCategoryId: initialCategoryId,
        initialQuery: initialQuery,
      ),
    );
  }
}

class _FilterView extends StatefulWidget {
  final String? initialCategoryId;
  final String? initialQuery;

  const _FilterView({
    this.initialCategoryId,
    this.initialQuery,
  });

  @override
  State<_FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<_FilterView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FilterCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
            size: 18,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.filterTitle,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              cubit.clearFilter();
            },
            child: Text(
              AppStrings.clearFilter,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AppTextField(
              controller: _searchController,
              hintText: AppStrings.searchHint,
              type: AppTextFieldType.search,
              onChanged: (value) => cubit.updateSearch(value),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        cubit.updateSearch('');
                        setState(() {});
                      },
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 8),

          // Categories horizontal bar & Results
          Expanded(
            child: BlocBuilder<FilterCubit, FilterStates>(
              builder: (context, state) {
                if (state is FilterLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is FilterErrorState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 56,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.errorMessage,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 160,
                            child: AppMainButton(
                              txt: AppStrings.retry,
                              onPressed: () => cubit.loadFilterData(
                                initialCategoryId: widget.initialCategoryId,
                                initialQuery: widget.initialQuery,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is FilterSuccessState) {
                  final trips = state.filteredTrips;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Category Filter Bar
                      FilterCategoryBar(
                        categories: state.categories,
                        selectedCategoryId: state.selectedCategoryId,
                      ),

                      const SizedBox(height: 12),

                      // Result Count Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${AppStrings.searchResults} (${trips.length})',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (state.selectedCategoryId != null ||
                                state.searchQuery.isNotEmpty)
                              Text(
                                'تصفية نشطة',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Trips Grid or Empty State
                      Expanded(
                        child: trips.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.search_off_rounded,
                                        size: 64,
                                        color: AppColors.textHint,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        AppStrings.noTripsFound,
                                        style:
                                            AppTextStyles.titleMedium.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        AppStrings.noTripsFoundSubtitle,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: 140,
                                        child: AppMainButton(
                                          txt: AppStrings.clearFilter,
                                          onPressed: () {
                                            _searchController.clear();
                                            cubit.clearFilter();
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.72,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: trips.length,
                                itemBuilder: (context, index) {
                                  return FilterTripCard(trip: trips[index]);
                                },
                              ),
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
