import 'package:go_router/go_router.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/features/auth/screens/login_screen.dart';
import 'package:rehla/features/auth/screens/signup_screen.dart';
import 'package:rehla/features/splash/splash_screen.dart';
import 'package:rehla/features/user/root.dart';

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
    ],
  );
}
