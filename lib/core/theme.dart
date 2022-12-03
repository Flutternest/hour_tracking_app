import 'package:flutter/material.dart';
import 'package:flux_mvp/core/constants/colors.dart';

class AppThemes {
  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: kDarkBackground,
    primaryColor: kPrimaryColor,
    textTheme: textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    ),
  );

  static TextTheme textTheme = const TextTheme(
    bodyText1: TextStyle(
      fontWeight: FontWeight.w300,
    ),
  );
}
