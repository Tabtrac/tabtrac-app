import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/functions.dart';

import 'package:fundz_app/helpers/app_extensions.dart';

import '../../../../constants/colors.dart';
import '../../../../helpers/app_fonts.dart';
import '../../../../providers/providers.dart';
import '../../../../widgets/inputs.widgets.dart';
import '../../../../widgets/widgets.utils.dart';
import '../providers.dart';
import '../providers/actions.provider.dart';

class FirstFormCreate extends ConsumerStatefulWidget {
  const FirstFormCreate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FirstFormCreateState();
}

class _FirstFormCreateState extends ConsumerState<FirstFormCreate> {
  @override
  Widget build(BuildContext context) {
    final phoneNumberController = ref.watch(phoneNumberControllerProvider);
    final emailController = ref.watch(emailControllerProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final transH = AppLocalizations.of(context)!;
    final client = ref.watch(selectedClient);
    ref.listen(selectedClient, (previous, next) {
      ref.read(emailControllerProvider).text =
          next!.email != null ? next.email.toString() : '';
      ref.read(phoneNumberControllerProvider).text =
          next.phoneNumber != null ? next.phoneNumber.toString() : '';
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          transH.clientInfo.capitalizeAll(),
          style: TextStyle(
            fontFamily: AppFonts.actionFont,
            color: AppColors.primaryColor,
            fontSize: isTablet() ? 10.sp : 16.sp,
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          height: 1.5.h,
          decoration: BoxDecoration(
            color: AppColors.greyColor.withOpacity(.2),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          transH.client.capitalizeFirst.toString(),
          style: TextStyle(
            fontFamily: AppFonts.actionFont,
            fontSize: isTablet() ? 8.sp : 14.sp,
            color:
                Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.7),
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.darkThemeShade.withOpacity(.3)
                  : AppColors.lightThemeShade.withOpacity(.3),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  color: AppColors.greyColor.withOpacity(.2), width: .7)),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          width: ScreenUtil().screenWidth,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.search_outlined,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withOpacity(.4),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    AppWidgetsUtlis.searchClientList(context, saveData: true);
                  },
                  child: TextField(
                    // controller: controller,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: isTablet() ? 8.sp : 14.sp,
                    ),
                    enabled: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      hintText:
                          transH.searchClientList.capitalizeFirst.toString(),
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: isTablet() ? 8.sp : 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  AppWidgetsUtlis.showBottomSheet(context, saveData: true);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                child: Text(
                  transH.addNew.capitalizeFirst.toString(),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: isTablet() ? 8.sp : 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        client != null
            ? FittedBox(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "${transH.clientName.capitalizeAll()}:",
                        style: TextStyle(
                          fontFamily: AppFonts.actionFont,
                          fontSize: isTablet() ? 8.sp : 14.sp,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: ScreenUtil().screenWidth * .7),
                        child: Text(
                          client.name,
                          style: TextStyle(
                            fontFamily: AppFonts.actionFont,
                            fontSize: isTablet() ? 8.sp : 14.sp,
                            color: AppColors.whiteColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().scaleXY(delay: 500.ms)
            : const SizedBox(),
        SizedBox(height: 5.h),
        Text(
          transH.clientEmail.capitalizeFirst.toString(),
          style: TextStyle(
            fontFamily: AppFonts.actionFont,
            fontSize: isTablet() ? 8.sp : 14.sp,
            color:
                Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.7),
          ),
        ),
        SizedBox(height: 5.h),
        FormInput(
          ScreenUtil().screenWidth,
          controller: emailController,
          hintText: transH.clientEmail,
          isLast: false,
          isPassword: false,
          disabled: true,
          borderRadius: BorderRadius.circular(10.0),
        ),
        SizedBox(height: 10.h),
        Text(
          transH.clientPhonenumber.capitalizeFirst.toString(),
          style: TextStyle(
            fontFamily: AppFonts.actionFont,
            fontSize: isTablet() ? 8.sp : 14.sp,
            color:
                Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.7),
          ),
        ),
        SizedBox(height: 5.h),
        FormInput(
          ScreenUtil().screenWidth,
          controller: phoneNumberController,
          hintText: transH.clientPhonenumber,
          isLast: true,
          isPassword: false,
          disabled: true,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ],
    );
  }
}
