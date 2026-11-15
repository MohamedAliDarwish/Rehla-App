import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'booking_states.dart';
import '../model/trip_model.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  static BookingCubit get(context) => BlocProvider.of(context);

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://rehla-app-backend-api.vercel.app/',
      headers: {
        'Accept': 'application/json',
        // انا سايب هنا مكان التوكن فاضي
        'Authorization': 'Bearer YOUR_TOKEN_HERE',
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
      final response = await _dio.post('api/bookings', data: {
        "tripId": tripId,
        "peopleCount": peopleCount,
        "totalPrice": peopleCount * pricePerPerson,
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