import 'package:go_router/go_router.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/features/auth/screens/login_screen.dart';
import 'package:rehla/features/auth/screens/signup_screen.dart';
import 'package:rehla/features/splash/splash_screen.dart';
import 'package:rehla/features/user/filter/filter_screen.dart';
import 'package:rehla/features/user/root.dart';
import 'package:rehla/features/user/trip_details/trip_details_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
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
