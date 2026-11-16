import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'booking_states.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';
import 'package:rehla/core/storage/secure_storage_service.dart';
import 'package:flutter/material.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial()) {
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SecureStorageService.instance.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  static BookingCubit get(BuildContext context) => BlocProvider.of(context);

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://rehla-app-backend-api.vercel.app/',
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  int selectedFilterIndex = 0;
  final List<String> filters = ['الكل', 'مقبول', 'قيد الانتظار', 'ملغي'];

  int peopleCount = 1;
  double pricePerPerson = 0.0;
  List<TripModel> allTrips = [];

  void changeFilter(int index) {
    selectedFilterIndex = index;
    emit(BookingFilterChanged(selectedFilterIndex));
  }

  void setBasePrice(double price) {
    pricePerPerson = price;
    emit(BookingPeopleCountChanged(peopleCount, peopleCount * pricePerPerson));
  }

  void changePeopleCount(bool isIncrement) {
    if (isIncrement) {
      peopleCount++;
    } else if (peopleCount > 1) {
      peopleCount--;
    }
    emit(BookingPeopleCountChanged(peopleCount, peopleCount * pricePerPerson));
  }

  Future<void> getTrips() async {
    emit(GetTripsLoading());
    try {
      final response = await _dio.get('trips/');
      
      if (response.statusCode == 200) {
        allTrips = (response.data as List)
            .map((item) => TripModel.fromJson(item))
            .toList();
        emit(GetTripsSuccess(allTrips));
      } else {
        emit(GetTripsError("Failed to load trips"));
      }
    } catch (e) {
      emit(GetTripsError(e.toString()));
    }
  }
  
  Future<void> confirmBooking({required String tripId, String? notes}) async {
    emit(BookTripLoading());
    try {
      // هنا بيجيب ايرور انا مش عارف اكتب ايه
      final response = await _dio.post('booking/', data: {
        "tripId": tripId,
        "numberOfSeats": peopleCount, 
        "notes": notes ?? "",
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(BookTripSuccess());
      } else {
        emit(BookTripError("Failed to confirm booking"));
      }
    } catch (e) {
      emit(BookTripError(e.toString()));
    }
  }
}