import 'package:rehla/features/user/home/models/category_model.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';

sealed class FilterStates {}

class FilterInitState extends FilterStates {}

class FilterLoadingState extends FilterStates {}

class FilterSuccessState extends FilterStates {
  final List<CategoryModel> categories;
  final List<TripModel> allTrips;
  final List<TripModel> filteredTrips;
  final String? selectedCategoryId;
  final String searchQuery;

  FilterSuccessState({
    required this.categories,
    required this.allTrips,
    required this.filteredTrips,
    this.selectedCategoryId,
    this.searchQuery = '',
  });

  FilterSuccessState copyWith({
    List<CategoryModel>? categories,
    List<TripModel>? allTrips,
    List<TripModel>? filteredTrips,
    String? selectedCategoryId,
    bool clearCategory = false,
    String? searchQuery,
  }) {
    return FilterSuccessState(
      categories: categories ?? this.categories,
      allTrips: allTrips ?? this.allTrips,
      filteredTrips: filteredTrips ?? this.filteredTrips,
      selectedCategoryId: clearCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class FilterErrorState extends FilterStates {
  final String errorMessage;

  FilterErrorState({required this.errorMessage});
}
