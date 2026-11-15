import 'trip_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class GetTripsLoading extends BookingState {}

class GetTripsSuccess extends BookingState {
  final List<TripModel> trips;
  GetTripsSuccess(this.trips);
}

class GetTripsError extends BookingState {
  final String error;
  GetTripsError(this.error);
}

class BookingFilterChanged extends BookingState {
  final int selectedIndex;
  BookingFilterChanged(this.selectedIndex);
}

class BookingPeopleCountChanged extends BookingState {
  final int count;
  final double totalPrice;
  BookingPeopleCountChanged(this.count, this.totalPrice);
}

class BookTripLoading extends BookingState {}

class BookTripSuccess extends BookingState {}

class BookTripError extends BookingState {
  final String error;
  BookTripError(this.error);
}