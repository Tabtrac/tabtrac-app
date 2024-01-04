import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/helpers/app_extensions.dart';

import '../constants/colors.dart';
import '../helpers/app_fonts.dart';

Column deletePlaceholderWidget(
    AppLocalizations transH, double width, double height) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        transH.deleting.capitalizeFirst.toString(),
        style: TextStyle(
          color: AppColors.primaryColor,
          fontFamily: AppFonts.actionFont,
          fontSize: width * .01 + 18,
        ),
      ),
      SizedBox(height: height * .02),
      const CircularProgressIndicator(
        color: AppColors.primaryColor,
      ),
    ],
  );
}
Column loadingPlaceholderWidget(
    AppLocalizations transH, double width, double height) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(height: height * .02),
      const CircularProgressIndicator(
        color: AppColors.primaryColor,
      ),
    ],
  );
}
