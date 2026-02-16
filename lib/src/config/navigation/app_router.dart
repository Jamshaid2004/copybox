import 'package:copybox/src/core/constants/app_routes.dart';
import 'package:copybox/src/core/global/navigator_key.dart';
import 'package:copybox/src/features/home/view/home_screen.dart';
import 'package:copybox/src/features/language/view/language_screen.dart';
import 'package:copybox/src/features/settings/view/settings.dart';
import 'package:copybox/src/features/splash/view/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(navigatorKey: navigatorKey, initialLocation: AppRoutes.splash, routes: [
    /* ------------------------------ Splash Screen ----------------------------- */
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    /* ------------------------------- Home Screen ------------------------------ */
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    /* -------------------------------- Settings -------------------------------- */
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    /* -------------------------------- Language -------------------------------- */
    GoRoute(
      path: AppRoutes.language,
      builder: (context, state) => const LanguageScreen(),
    ),
  ]);
}
