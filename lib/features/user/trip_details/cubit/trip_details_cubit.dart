import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/data_sourse/api_data_sourse.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';
import 'package:rehla/features/user/trip_details/cubit/trip_details_states.dart';

class TripDetailsCubit extends Cubit<TripDetailsStates> {
  TripDetailsCubit() : super(TripDetailsInitState());

  final ApiDataSourse _apiDataSourse = ApiDataSourse();
  TripModel? trip;
  bool isFavorite = false;

  Future<void> getTripDetails(String id) async {
    emit(TripDetailsLoadingState());
    try {
      final fetchedTrip = await _apiDataSourse.getTripById(id);
      trip = fetchedTrip;
      emit(TripDetailsSuccessState(trip: fetchedTrip));
    } catch (e) {
      emit(TripDetailsErrorState(errorMessage: e.toString()));
    }
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    if (trip != null) {
      emit(TripDetailsSuccessState(trip: trip!));
    }
  }
}
