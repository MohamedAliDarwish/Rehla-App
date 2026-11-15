import '../models/admin_booking_model.dart';
import '../models/admin_stats_model.dart';

abstract class AdminState {}

class AdminInitialState extends AdminState {}

class AdminLoadingState extends AdminState {}

class AdminSuccessState extends AdminState {
  final AdminStatsModel stats;
  final List<AdminBookingModel> bookings;
  final String adminName;

  AdminSuccessState({
    required this.stats,
    required this.bookings,
    required this.adminName,
  });
}

class AdminErrorState extends AdminState {
  final String errorMessage;

  AdminErrorState({required this.errorMessage});
}
