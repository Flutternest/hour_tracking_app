import 'package:flutter/material.dart';
import 'package:flux_mvp/core/theme.dart';
import 'package:flux_mvp/routing/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flux MVP',
      theme: AppThemes.darkTheme,
      navigatorKey: AppRouter.navigatorKey,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
