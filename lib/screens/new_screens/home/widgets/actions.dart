import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:heroicons/heroicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/colors.dart';
import '../../../../helpers/app_fonts.dart';
import '../../../../providers/providers.dart';
import '../../../../widgets/widgets.utils.dart';

class ActionWidgets extends ConsumerWidget {
  final double width;
  const ActionWidgets({super.key, required this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transH = AppLocalizations.of(context)!;
    final isDarkMode = ref.watch(isDarkModeProvider);
    return SizedBox(
      width: width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      AppWidgetsUtlis.showBottomSheet(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.darkThemeShade
                            : AppColors.lightThemeShade,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      margin: const EdgeInsets.only(right: 10.0),
                      child: HeroIcon(
                        HeroIcons.userPlus,
                        style: HeroIconStyle.outline,
                        color: AppColors.primaryColor,
                        size: isTablet() ? 14.sp : 24.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    transH.addNewClient.capitalizeAll(),
                    style: TextStyle(
                      fontFamily: AppFonts.actionFont,
                      fontSize: isTablet() ? 8.sp : 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      AppWidgetsUtlis.showRecordCreateBottomSheet(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.darkThemeShade
                            : AppColors.lightThemeShade,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      margin: const EdgeInsets.only(right: 10.0),
                      child: HeroIcon(
                        HeroIcons.documentPlus,
                        style: HeroIconStyle.outline,
                        color: AppColors.primaryColor,
                        size: isTablet() ? 14.sp : 24.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    transH.createNewRecord.capitalizeAll(),
                    style: TextStyle(
                      fontFamily: AppFonts.actionFont,
                      fontSize: isTablet() ? 8.sp : 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
