import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/data_sourse/api_data_sourse.dart';
import '../models/admin_trip_model.dart';
import 'admin_trips_states.dart';

class AdminTripsCubit extends Cubit<AdminTripsState> {
  AdminTripsCubit() : super(AdminTripsInitialState());

  final ApiDataSourse _apiDataSourse = ApiDataSourse();

  List<AdminTripModel> _allTrips = [];
  String _activeTab = 'الكل';

  Future<void> loadTrips() async {
    emit(AdminTripsLoadingState());
    try {
      final rawList = await _apiDataSourse.getAdminTrips();
      _allTrips = rawList.map((item) => AdminTripModel.fromJson(item)).toList();
      _emitSuccess();
    } catch (e) {
      emit(AdminTripsErrorState(errorMessage: e.toString()));
    }
  }

  void filterByTab(String tab) {
    _activeTab = tab;
    _emitSuccess();
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await _apiDataSourse.deleteTrip(tripId);
      _allTrips.removeWhere((t) => t.id == tripId);
      _emitSuccess();
    } catch (e) {
      await loadTrips();
    }
  }

  Future<void> togglePublishTrip(AdminTripModel trip) async {
    try {
      final newStatus = trip.isPublished ? 'غير منشورة' : 'منشورة';
      final newIsPublished = !trip.isPublished;
      await _apiDataSourse.togglePublishTrip(trip.id, newIsPublished);

      final index = _allTrips.indexWhere((t) => t.id == trip.id);
      if (index != -1) {
        _allTrips[index] = trip.copyWith(
          status: newStatus,
          isPublished: newIsPublished,
        );
      }
      _emitSuccess();
    } catch (e) {
      await loadTrips();
    }
  }

  void _emitSuccess() {
    List<AdminTripModel> filtered = [];
    if (_activeTab == 'الكل') {
      filtered = List.from(_allTrips);
    } else if (_activeTab == 'منشورة') {
      filtered = _allTrips.where((t) => t.status == 'منشورة' || t.isPublished).toList();
    } else if (_activeTab == 'غير منشورة') {
      filtered = _allTrips.where((t) => t.status == 'غير منشورة' || !t.isPublished).toList();
    } else if (_activeTab == 'مسودة') {
      filtered = _allTrips.where((t) => t.status == 'مسودة').toList();
    } else {
      filtered = List.from(_allTrips);
    }

    emit(AdminTripsSuccessState(
      allTrips: _allTrips,
      filteredTrips: filtered,
      activeTab: _activeTab,
    ));
  }
}
