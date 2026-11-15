import '../models/admin_trip_model.dart';

abstract class AdminTripsState {}

class AdminTripsInitialState extends AdminTripsState {}

class AdminTripsLoadingState extends AdminTripsState {}

class AdminTripsSuccessState extends AdminTripsState {
  final List<AdminTripModel> allTrips;
  final List<AdminTripModel> filteredTrips;
  final String activeTab;

  AdminTripsSuccessState({
    required this.allTrips,
    required this.filteredTrips,
    required this.activeTab,
  });
}

class AdminTripsErrorState extends AdminTripsState {
  final String errorMessage;

  AdminTripsErrorState({required this.errorMessage});
}
