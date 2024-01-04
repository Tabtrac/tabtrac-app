import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/helpers/app_fonts.dart';

import '../../constants/app_routes.dart';
import '../../constants/colors.dart';
import '../../helpers/functions.dart';
import '../../widgets/custom_btn.dart';

class PasswordResetSuccess extends ConsumerStatefulWidget {
  const PasswordResetSuccess({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PasswordResetSuccessState();
}

class _PasswordResetSuccessState extends ConsumerState<PasswordResetSuccess> {
  @override
  void initState() {
    changeBottomBarColor(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final transH = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/svgs/check.svg'),
            SizedBox(height: 20.h),
            Text(
              transH.passwordChang,
              style: TextStyle(
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
                fontFamily: AppFonts.actionFont,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              transH.passwordChangedMessage.capitalize(),
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 16.sp,
                fontFamily: AppFonts.primaryFont,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            CustomBtn(
              onPressed: () {
                navigateReplacementNamed(context, AppRoutes.loginRoute);
              },
              btnColor: AppColors.primaryColor,
              fontSize: 16.sp,
              text: transH.loginNow.capitalizeAll(),
              textColor: AppColors.whiteColor,
            )
          ],
        ),
      ),
    );
  }
}
