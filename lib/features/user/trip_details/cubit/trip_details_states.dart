import 'package:rehla/features/user/home/models/trip_models.dart';

sealed class TripDetailsStates {}

class TripDetailsInitState extends TripDetailsStates {}

class TripDetailsLoadingState extends TripDetailsStates {}

class TripDetailsSuccessState extends TripDetailsStates {
  final TripModel trip;

  TripDetailsSuccessState({required this.trip});
}

class TripDetailsErrorState extends TripDetailsStates {
  final String errorMessage;

  TripDetailsErrorState({required this.errorMessage});
}
