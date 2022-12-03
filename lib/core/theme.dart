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
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      floatingLabelStyle: const TextStyle(color: kPrimaryColor),
      filled: true,
      fillColor: Colors.grey[900],
      prefixIconColor: Colors.white,
      suffixIconColor: Colors.white,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: kPrimaryColor,
    ),
  );

  static TextTheme textTheme = const TextTheme(
    bodyText1: TextStyle(
      fontWeight: FontWeight.w300,
    ),
  );
}
