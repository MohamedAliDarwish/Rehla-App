import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/data_sourse/api_data_sourse.dart';
import 'package:rehla/core/storage/secure_storage_service.dart';

import '../models/admin_booking_model.dart';
import '../models/admin_stats_model.dart';
import 'admin_states.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitialState());

  final ApiDataSourse _apiDataSourse = ApiDataSourse();

  Future<void> loadDashboardData() async {
    emit(AdminLoadingState());
    try {
      final userData = await SecureStorageService.instance.getUserData();
      final adminName =
          (userData['name'] != null && userData['name']!.isNotEmpty)
          ? userData['name']!
          : 'ادمن';

      final statsRaw = await _apiDataSourse.getAdminDashboardStats();
      final stats = AdminStatsModel.fromJson(statsRaw);

      final bookingsRaw = await _apiDataSourse.getAdminBookings();
      final bookings = bookingsRaw
          .map((item) => AdminBookingModel.fromJson(item))
          .toList();

      emit(
        AdminSuccessState(
          stats: stats,
          bookings: bookings,
          adminName: adminName,
        ),
      );
    } catch (e) {
      emit(AdminErrorState(errorMessage: e.toString()));
    }
  }
}
