import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flux_mvp/views/splash_page.dart';

import '../views/welcome_page.dart';

class AppRoutes {
  static const splashPage = '/';
  static const welcomePage = '/welcome-page';
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
      case AppRoutes.welcomePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const WelcomePage(),
          settings: settings,
          fullscreenDialog: false,
        );

      default:
        return null;
    }
  }
}
