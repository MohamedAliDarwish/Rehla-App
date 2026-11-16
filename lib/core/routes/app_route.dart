import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/features/admin/screens/add_trip_screen.dart';
import 'package:rehla/features/admin/screens/admin_bookings_screen.dart';
import 'package:rehla/features/admin/screens/admin_dashboard_screen.dart';
import 'package:rehla/features/admin/screens/admin_trips_screen.dart';
import 'package:rehla/features/auth/screens/login_screen.dart';
import 'package:rehla/features/auth/screens/signup_screen.dart';
import 'package:rehla/features/splash/splash_screen.dart';
import 'package:rehla/features/user/booking/booking_confirmation_screen.dart';
import 'package:rehla/features/user/booking/booking_details_screen.dart';
import 'package:rehla/features/user/booking/cubit/booking_cubit.dart';
import 'package:rehla/features/user/booking/model/trip_model.dart' as booking_trip;
import 'package:rehla/features/user/filter/filter_screen.dart';
import 'package:rehla/features/user/home/models/trip_models.dart' as home_trip;
import 'package:rehla/features/user/profile/profile_screen.dart';
import 'package:rehla/features/user/root.dart';
import 'package:rehla/features/user/trip_details/trip_details_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.adminBookings,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const RootScreen(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.adminBookings,
        builder: (context, state) => const AdminBookingsScreen(),
      ),
      GoRoute(
        path: RouteNames.adminTrips,
        builder: (context, state) => const AdminTripsScreen(),
      ),
      GoRoute(
        path: RouteNames.addTrip,
        builder: (context, state) => const AddTripScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.bookingConfirmation,
        builder: (context, state) {
          booking_trip.TripModel? trip;
          if (state.extra is booking_trip.TripModel) {
            trip = state.extra as booking_trip.TripModel;
          } else if (state.extra is home_trip.TripModel) {
            final h = state.extra as home_trip.TripModel;
            trip = booking_trip.TripModel.fromJson({
              'title': h.title,
              'from': h.from,
              'description': h.description,
              'destination': h.destination,
              'price': h.price,
              'capacity': h.capacity,
              'availableSeats': h.availableSeats,
              'startDate': h.startDate,
              'endDate': h.endDate,
              'status': h.status,
              'coverImage': h.coverImage,
              'included': h.included,
              'excluded': h.excluded,
              'cancelPolicy': h.cancelPolicy,
            });
          }
          trip ??= booking_trip.TripModel.fromJson({});
          return BlocProvider(
            create: (_) => BookingCubit(),
            child: BookingConfirmationScreen(trip: trip),
          );
        },
      ),
      GoRoute(
        path: RouteNames.bookingDetails,
        builder: (context, state) {
          booking_trip.TripModel? trip;
          if (state.extra is booking_trip.TripModel) {
            trip = state.extra as booking_trip.TripModel;
          } else if (state.extra is home_trip.TripModel) {
            final h = state.extra as home_trip.TripModel;
            trip = booking_trip.TripModel.fromJson({
              'title': h.title,
              'from': h.from,
              'description': h.description,
              'destination': h.destination,
              'price': h.price,
              'capacity': h.capacity,
              'availableSeats': h.availableSeats,
              'startDate': h.startDate,
              'endDate': h.endDate,
              'status': h.status,
              'coverImage': h.coverImage,
              'included': h.included,
              'excluded': h.excluded,
              'cancelPolicy': h.cancelPolicy,
            });
          }
          trip ??= booking_trip.TripModel.fromJson({});
          return BlocProvider(
            create: (_) => BookingCubit(),
            child: BookingDetailsScreen(trip: trip),
          );
        },
      ),
      GoRoute(
        path: RouteNames.filter,
        builder: (context, state) {
          String? categoryId;
          String? query;

          if (state.extra is String) {
            categoryId = state.extra as String;
          } else if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            categoryId = map['categoryId']?.toString();
            query = map['query']?.toString();
          }

          return FilterScreen(
            initialCategoryId: categoryId,
            initialQuery: query,
          );
        },
      ),
      GoRoute(
        path: RouteNames.tripDetails,
        builder: (context, state) {
          final tripId = (state.extra as String?) ?? '';
          return TripDetailsScreen(tripId: tripId);
        },
      ),
      GoRoute(
        path: '${RouteNames.tripDetails}/:id',
        builder: (context, state) {
          final tripId =
              state.pathParameters['id'] ?? (state.extra as String? ?? '');
          return TripDetailsScreen(tripId: tripId);
        },
      ),
    ],
  );
}
