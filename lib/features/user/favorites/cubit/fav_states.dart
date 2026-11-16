import 'package:rehla/features/user/home/models/trip_models.dart';

sealed class FavoritesStates {}

class FavoritesInitState extends FavoritesStates {}

class FavoritesLoadingState extends FavoritesStates {}

class FavoritesLoadedState extends FavoritesStates {
  final List<TripModel> trips;

  FavoritesLoadedState({required this.trips});
}

class FavoritesErrorState extends FavoritesStates {
  final String errorMessage;

  FavoritesErrorState({required this.errorMessage});
}
