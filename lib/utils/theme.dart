import 'package:flutter/material.dart';

import '../constants/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimaryColor,
    dialogBackgroundColor: AppColors.lightBackgroundColor,
    scaffoldBackgroundColor: AppColors.lightBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: const ColorScheme.light(
        secondary: AppColors.lightSecondaryColor,
        primary: AppColors.lightPrimaryColor,
        surface: AppColors.lightBackgroundColor,
        secondaryContainer: AppColors.lightChartBackgroundColor,
        brightness: Brightness.light),
    checkboxTheme: ThemeData.light().checkboxTheme.copyWith(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimaryColor,
    dialogBackgroundColor: AppColors.darkBackgroundColor,
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: const ColorScheme.dark(
        secondary: AppColors.darkSecondaryColor,
        primary: AppColors.darkPrimaryColor,
        surface: AppColors.darkBackgroundColor,
        secondaryContainer: AppColors.darkChartBackgroundColor,
        brightness: Brightness.dark),
    checkboxTheme: ThemeData.dark().checkboxTheme.copyWith(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
  );
}
