import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/data_sourse/api_data_sourse.dart';
import 'package:rehla/features/user/home/cubit/home_states.dart';
import 'package:rehla/features/user/home/models/category_model.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitState());

  final ApiDataSourse _apiDataSourse = ApiDataSourse();

  List<CategoryModel> categories = [];
  List<TripModel> trips = [];

  bool isCategoriesLoading = false;
  bool isTripsLoading = false;

  Future<void> getHomeData() async {
    await Future.wait([
      getAllCategories(),
      getAllTrips(),
    ]);
  }

  // Categories
  Future<void> getAllCategories() async {
    isCategoriesLoading = true;
    emit(HomeCategoryLoadingState());
    try {
      final allCategories = await _apiDataSourse.getAllCategories();
      categories = allCategories;
      isCategoriesLoading = false;
      emit(HomeCategorySuccessState(categories: allCategories));
    } catch (e) {
      isCategoriesLoading = false;
      emit(HomeCategoryErrorState(errorMessage: e.toString()));
    }
  }

  // Trips
  Future<void> getAllTrips() async {
    isTripsLoading = true;
    emit(HomeTripsLoadingState());
    try {
      final allTrips = await _apiDataSourse.getAllTrips();
      trips = allTrips;
      isTripsLoading = false;
      emit(HomeTripsSuccessState(trips: allTrips));
    } catch (e) {
      isTripsLoading = false;
      emit(HomeTripsErrorState(errorMessage: e.toString()));
    }
  }
}
