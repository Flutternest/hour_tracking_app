import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flux_mvp/auth/auth_widget.dart';
import 'package:flux_mvp/views/admin/auth/admin_login_page.dart';
import 'package:flux_mvp/views/driver/auth/driver_login_page.dart';
import 'package:flux_mvp/views/driver/settings/analytics_page.dart';
import 'package:flux_mvp/views/driver/settings/my_earnings.dart';
import 'package:flux_mvp/views/driver/settings/profile_page.dart';
import 'package:flux_mvp/views/splash_page.dart';

import '../views/driver/dashboard/dashboad_page.dart';
import '../views/driver/dashboard/result_page.dart';
import '../views/welcome_page.dart';

class AppRoutes {
  static const splashPage = '/';
  static const welcomePage = '/welcome-page';

  //admin flow
  static const adminLoginPage = '/admin-login-page';

  //driver flow
  static const driverLoginPage = '/driver-login-page';
  static const driverDashboardPage = '/driver-dashboard-page';
  static const driverResultPage = '/driver-result-page';
  static const driverProfilePage = '/driver-profile-page';
  static const driverEarningsPage = '/driver-earnings-page';
  static const driverAnalyticsPage = '/driver-analytics-page';

  static const String authDecisionPage = '/auth-decision-page';
}

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static Future<dynamic> navigateToPage(String routeName,
      {bool replace = false, dynamic arguments}) async {
    log("Navigation: $routeName | Type: Push | Replace: $replace | Args: $arguments");

    if (replace) {
      return navigatorKey.currentState!
          .pushReplacementNamed(routeName, arguments: arguments);
    } else {
      return navigatorKey.currentState!
          .pushNamed(routeName, arguments: arguments);
    }
  }

  static void pop([dynamic result]) {
    log("Navigation | Type: Pop | Args: $result");
    navigatorKey.currentState!.pop(result);
  }

  static void maybePop([dynamic result]) {
    log("Navigation | Type: Maybe Pop | Args: $result");
    navigatorKey.currentState!.maybePop(result);
  }

  static void navigateAndRemoveUntil(String routeName, {dynamic arguments}) {
    log("Navigation | Type: Permanent Navigation | Args: No args");
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);
  }

  static void popUntil(bool Function(Route<dynamic>) route) {
    log("Navigation | Type: Pop (Until) | Pop Route: $route");
    navigatorKey.currentState!.popUntil(route);
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SplashPage(),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.authDecisionPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const AuthWidget(),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.welcomePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const WelcomePage(),
          settings: settings,
          fullscreenDialog: false,
        );

      //admin flow
      case AppRoutes.adminLoginPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const AdminLoginPage(),
          settings: settings,
          fullscreenDialog: false,
        );

      //driver flow
      case AppRoutes.driverLoginPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const DriverLoginPage(),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.driverDashboardPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const DashboardPage(),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.driverResultPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const DriverResultPage(),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.driverProfilePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const DriverProfilePage(),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.driverEarningsPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const DriverEarningsPage(),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.driverAnalyticsPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const DriverAnalyticsPage(),
          settings: settings,
          fullscreenDialog: false,
        );

      default:
        return null;
    }
  }
}
