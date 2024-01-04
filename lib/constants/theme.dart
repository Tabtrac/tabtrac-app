import 'package:flutter/material.dart';

import '../helpers/page_transitions.dart';
import 'colors.dart';

class AppTheme {
  static String theme = "light";
  Color? isDarkTheme() {
    if (theme == "light") {
      return Colors.white;
    } else {
      return Colors.white;
    }
  }

  static ThemeData get darkTheme => ThemeData.dark(useMaterial3: true).copyWith(
        brightness: Brightness.dark,
        primaryColor: AppColors
            .primaryColor, // You can adjust the darkness of the background
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: AppColors.darkThemeColor,
          ),
        ),

        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: const IconThemeData(color: AppColors.darkThemeColor),
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            iconColor: MaterialStatePropertyAll(
              AppColors.darkThemeColor,
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: InputBorder.none, enabledBorder: InputBorder.none),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkThemeBg,
          scrolledUnderElevation: 0,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CustomTransitionBuilder(),
            TargetPlatform.windows: CustomTransitionBuilder(),
            TargetPlatform.linux: CustomTransitionBuilder(),
          },
        ),
        scaffoldBackgroundColor: AppColors.darkThemeBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
        ).copyWith(
          background: AppColors.darkThemeBg,
        ),
      );
  static ThemeData get lightTheme =>
      ThemeData.light(useMaterial3: true).copyWith(
        brightness: Brightness.light,
        primaryColor: AppColors.primaryColor,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: AppColors.lightThemeColor,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.lightThemeColor),
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            iconColor: MaterialStatePropertyAll(
              AppColors.lightThemeColor,
            ),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: InputBorder.none, enabledBorder: InputBorder.none),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CustomTransitionBuilder(),
            TargetPlatform.windows: CustomTransitionBuilder(),
            TargetPlatform.linux: CustomTransitionBuilder(),
          },
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.lightThemeBg,
            scrolledUnderElevation: 0,
            elevation: 0),
        scaffoldBackgroundColor: AppColors.lightThemeBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
        ).copyWith(
          background: AppColors.lightThemeBg,
        ),
      );
}
