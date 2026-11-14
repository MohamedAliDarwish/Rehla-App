import 'package:rehla/features/user/home/models/category_model.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';

sealed class HomeStates {}

class HomeInitState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeErrorState extends HomeStates {
  final String errorMessage;

  HomeErrorState({required this.errorMessage});
}

// Category States
class HomeCategoryLoadingState extends HomeStates {}

class HomeCategorySuccessState extends HomeStates {
  final List<CategoryModel> categories;

  HomeCategorySuccessState({required this.categories});
}

class HomeCategoryErrorState extends HomeStates {
  final String errorMessage;

  HomeCategoryErrorState({required this.errorMessage});
}

// Trip States
class HomeTripsLoadingState extends HomeStates {}

class HomeTripsSuccessState extends HomeStates {
  final List<TripModel> trips;

  HomeTripsSuccessState({required this.trips});
}

// Alias to maintain compatibility with any existing reference
typedef HomeTripsSucess = HomeTripsSuccessState;

class HomeTripsErrorState extends HomeStates {
  final String errorMessage;

  HomeTripsErrorState({required this.errorMessage});
}
