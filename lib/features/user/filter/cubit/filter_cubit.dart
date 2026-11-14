import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/data_sourse/api_data_sourse.dart';
import 'package:rehla/features/user/filter/cubit/filter_states.dart';
import 'package:rehla/features/user/home/models/category_model.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';

class FilterCubit extends Cubit<FilterStates> {
  FilterCubit() : super(FilterInitState());

  final ApiDataSourse _apiDataSourse = ApiDataSourse();

  List<CategoryModel> categories = [];
  List<TripModel> allTrips = [];
  String? selectedCategoryId;
  String searchQuery = '';

  Future<void> loadFilterData({
    String? initialCategoryId,
    String? initialQuery,
  }) async {
    emit(FilterLoadingState());
    try {
      final results = await Future.wait([
        _apiDataSourse.getAllCategories(),
        _apiDataSourse.getAllTrips(),
      ]);

      categories = results[0] as List<CategoryModel>;
      allTrips = results[1] as List<TripModel>;
      selectedCategoryId = initialCategoryId;
      searchQuery = initialQuery ?? '';

      _applyFilters();
    } catch (e) {
      emit(FilterErrorState(errorMessage: e.toString()));
    }
  }

  void selectCategory(String? categoryId) {
    if (selectedCategoryId == categoryId) {
      selectedCategoryId = null;
    } else {
      selectedCategoryId = categoryId;
    }
    _applyFilters();
  }

  void updateSearch(String query) {
    searchQuery = query.trim();
    _applyFilters();
  }

  void clearFilter() {
    selectedCategoryId = null;
    searchQuery = '';
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchQuery.toLowerCase();

    final filtered = allTrips.where((trip) {
      // 1. Category Filter
      if (selectedCategoryId != null && selectedCategoryId!.isNotEmpty) {
        final matchesCategory = trip.category.id == selectedCategoryId ||
            trip.category.slug == selectedCategoryId ||
            trip.category.nameAr == selectedCategoryId ||
            trip.category.nameEn == selectedCategoryId;
        if (!matchesCategory) return false;
      }

      // 2. Search Query Filter (Name, Destination, From, Description)
      if (query.isNotEmpty) {
        final title = trip.title.toLowerCase();
        final destination = trip.destination.toLowerCase();
        final from = trip.from.toLowerCase();
        final description = trip.description.toLowerCase();
        final catAr = trip.category.nameAr.toLowerCase();
        final catEn = trip.category.nameEn.toLowerCase();

        final matchesSearch = title.contains(query) ||
            destination.contains(query) ||
            from.contains(query) ||
            description.contains(query) ||
            catAr.contains(query) ||
            catEn.contains(query);

        if (!matchesSearch) return false;
      }

      return true;
    }).toList();

    emit(FilterSuccessState(
      categories: categories,
      allTrips: allTrips,
      filteredTrips: filtered,
      selectedCategoryId: selectedCategoryId,
      searchQuery: searchQuery,
    ));
  }
}
