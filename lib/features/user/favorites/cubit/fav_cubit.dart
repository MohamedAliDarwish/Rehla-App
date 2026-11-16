import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/data_sourse/api_data_sourse.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';
import 'package:rehla/features/user/favorites/cubit/fav_states.dart';

class FavoritesCubit extends Cubit<FavoritesStates> {
  FavoritesCubit() : super(FavoritesInitState());

  final ApiDataSourse _apiDataSourse = ApiDataSourse();
  List<TripModel> _trips = [];

  bool isFavorite(String tripId) => _trips.any((t) => t.id == tripId);

  Future<void> loadFavorites({bool showLoading = true}) async {
    if (showLoading) emit(FavoritesLoadingState());
    try {
      _trips = await _apiDataSourse.getFavorites();
      emit(FavoritesLoadedState(trips: _trips));
    } catch (e) {
      if (showLoading) {
        emit(FavoritesErrorState(errorMessage: _getErrorMessage(e)));
      }
    }
  }

  /// Updates the UI immediately, then syncs with the API.
  /// Reverts and returns false if the request fails.
  Future<bool> toggleFavorite(TripModel trip) async {
    final wasFavorite = isFavorite(trip.id);
    final previous = List<TripModel>.from(_trips);

    _trips = wasFavorite
        ? _trips.where((t) => t.id != trip.id).toList()
        : [..._trips, trip];
    emit(FavoritesLoadedState(trips: _trips));

    try {
      if (wasFavorite) {
        await _apiDataSourse.removeFavorite(trip.id);
      } else {
        await _apiDataSourse.addFavorite(trip.id);
      }
      return true;
    } catch (e) {
      _trips = previous;
      emit(FavoritesLoadedState(trips: _trips));
      return false;
    }
  }

  void clear() {
    _trips = [];
    emit(FavoritesInitState());
  }

  String _getErrorMessage(dynamic e) {
    if (e is DioException && e.response?.data is Map) {
      final msg = e.response?.data['message'] ?? e.response?.data['error'];
      if (msg != null) return msg.toString();
    }
    return 'تعذر تحميل المفضلة، تأكد من اتصالك بالإنترنت';
  }
}