import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRouter {
  // Route paths
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  static GoRouter router(WidgetRef ref) {
    return GoRouter(
      initialLocation: AppRouter.splash,
      routes: [
        GoRoute(
          path: AppRouter.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRouter.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRouter.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRouter.notifications,
          builder: (context, state) => const NotificationScreen(),
        ),
        GoRoute(
          path: AppRouter.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    );
  }
}
