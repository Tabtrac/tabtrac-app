import 'package:flutter/material.dart';

import 'theme.dart';

class AppColors {
  static const Color lightTheme = Color(0xFFFFFFFF);

  // themeMode
  static const Color lightThemeBg = Color(0xFFFFFFFF);
  static const Color logoBg = Color.fromRGBO(30, 37, 47, 1);
  static const Color lightThemeColor = Colors.black;
  static const Color darkThemeBg = AppColors.blackColor;
  static const Color darkThemeColor = AppColors.whiteColor;
  static const Color darkThemeShade = AppColors.blackShade;
  static const Color lightThemeShade = AppColors.whiteShade;
  static const Color success = Color.fromARGB(255, 39, 204, 45);

  static const Color paidColor = Color(0xFF3F7109);
  static const Color unpaidColor = Color(0xFF8D1228);

  static const Color paidShade = Color(0xFFF2FFD6);
  static const Color unpaidShade = Color(0xFFFDE2E4);

  static const Color whiteShade = Color(0xFFE2DEFC);
  static const Color blackTheme = Color.fromARGB(255, 1, 8, 12);
  static const Color blackColor = Color(0xFF272727);
  static const Color primaryColor = Color(0xFFE67F00);
  static const Color primaryColorLight = Color(0xFFFBBB00);
  static const Color primaryColorTwo = Color(0xFF1e252f);
  static const Color blackShade = Color(0xFF353935);
  static const Color actionColor = Color.fromARGB(255, 71, 52, 241);
  static const Color actionColorTwo = Color.fromARGB(255, 72, 136, 231);
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Colors.grey;
  static const Color dangerColor = Colors.redAccent;
  static Color themeColor =
      AppTheme.theme == 'light' ? AppColors.blackColor : AppColors.whiteColor;
  static Color themeBackground =
      AppTheme.theme == 'light' ? AppColors.lightTheme : AppColors.blackTheme;
  static Color themeShade =
      AppTheme.theme == 'light' ? AppColors.whiteShade : AppColors.blackShade;
}
