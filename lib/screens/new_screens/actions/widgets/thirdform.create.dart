import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/helpers/functions.dart';

import '../../../../constants/colors.dart';
import '../../../../helpers/app_fonts.dart';
import '../../../../providers/providers.dart';
import '../providers.dart';

class ThirdFormCreate extends ConsumerStatefulWidget {
  const ThirdFormCreate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ThirdFormCreateState();
}

class _ThirdFormCreateState extends ConsumerState<ThirdFormCreate> {
  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    final descriptionController = ref.watch(descriptionControllerProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          transH.recordDetail.capitalizeAll(),
          style: TextStyle(
              fontFamily: AppFonts.actionFont,
              color: AppColors.primaryColor,
              fontSize: 16.sp),
        ),
        SizedBox(height: 5.h),
        Container(
          height: 1.5.h,
          decoration: BoxDecoration(
            color: AppColors.greyColor.withOpacity(.2),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.darkThemeShade
                : AppColors.lightThemeShade,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: AppColors.greyColor.withOpacity(.2), width: .7),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: descriptionController,
            style: TextStyle(
              color: isDarkMode
                  ? AppColors.darkThemeColor
                  : AppColors.lightThemeColor,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
            maxLines: 5,
            minLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText:
                  '${transH.descriptionText.capitalizeFirst.toString()}...',
              hintStyle: TextStyle(
                color: isDarkMode
                    ? AppColors.darkThemeColor
                    : AppColors.lightThemeColor,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
