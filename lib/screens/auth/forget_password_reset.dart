// ignore_for_file: use_build_context_synchronously

// TODO: Add persist state for users using phones with lesser RAM

import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/constants/app_routes.dart';
import 'package:fundz_app/helpers/functions.dart';

import '../../constants/colors.dart';
import '../../helpers/app_fonts.dart';
import '../../providers/providers.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/inputs.widgets.dart';
import '../../widgets/snackbars.dart';
import 'reset_success.dart';

class ForgottenPasswordResetScreen extends ConsumerStatefulWidget {
  const ForgottenPasswordResetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgottenPasswordResetScreenState();
}

final codeControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);

class _ForgottenPasswordResetScreenState
    extends ConsumerState<ForgottenPasswordResetScreen> {
  TextEditingController password = TextEditingController();
  late String code;

  @override
  void initState() {
    changeBottomBarColor(false);
    super.initState();
  }

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final transH = AppLocalizations.of(context)!;
    final currentPage = ref.watch(currentPageProvider);
    return WillPopScope(
      onWillPop: () async {
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
        if (currentPage == 1) {
          ref.read(currentPageProvider.notifier).changePage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return tabletLayout(
                      height, width, currentPage, context, transH);
                } else {
                  return mobileLayout(
                      height, width, currentPage, context, transH);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Container tabletLayout(double height, double width, int currentPage,
      BuildContext context, AppLocalizations transH) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * .02),
                IconButton(
                  onPressed: () {
                    ref
                        .read(buttonLoadingNotifierProvider.notifier)
                        .changeIndex(false);
                    if (currentPage == 1) {
                      ref.read(currentPageProvider.notifier).changePage(0);
                    } else {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        navigateReplacementNamed(
                            context, AppRoutes.splashRoute);
                      }
                    }
                  },
                  padding: const EdgeInsets.all(0),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.primaryColor,
                    size: 14.sp,
                  ),
                ),
                SizedBox(height: height * .02),
                if (currentPage == 1)
                  Text(
                    transH.resetPassword.capitalizeAll(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 14.sp,
                      fontFamily: AppFonts.actionFont,
                    ),
                  )
                else
                  Text(
                    transH.verifyOTP.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14.sp,
                      fontFamily: AppFonts.actionFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (currentPage == 0)
                  Text(
                    transH.otpMessage,
                    style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 8.sp,
                    ),
                  )
                else
                  Text(
                    transH.newPassMessage,
                    style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 8.sp,
                    ),
                  ),
                SizedBox(height: 30.h),
                if (currentPage == 0)
                  OtpTextField(
                    // handleControllers: (controllers) => controller.phoneOTPController,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    numberOfFields: 4,
                    fieldWidth: 60.w,
                    showFieldAsBox: true,
                    autoFocus: true,
                    borderRadius: BorderRadius.circular(15),
                    styles: List.generate(
                      4,
                      (index) => TextStyle(
                          color: AppColors.primaryColor, fontSize: 14.sp),
                    ),
                    focusedBorderColor: AppColors.primaryColor,
                    onSubmit: (String value) {
                      code = value;
                    },
                  )
                else
                  FormInput(
                    width,
                    controller: password,
                    hintText: transH.enterPassword,
                    isPassword: true,
                    isLast: true,
                  ),
                SizedBox(height: 20.h),
                if (currentPage == 0)
                  Align(
                    alignment: Alignment.center,
                    child: CustomBtn(
                      width: width * .3,
                      onPressed: () {
                        ref.read(currentPageProvider.notifier).changePage(1);
                      },
                      // width: width ,
                      btnColor: AppColors.primaryColor,
                      fontSize: 10.sp,
                      text: transH.reset.capitalizeAll(),
                      textColor: AppColors.whiteColor,
                    ),
                  )
                else
                  Align(
                    alignment: Alignment.center,
                    child: CustomBtn(
                      width: width * .3,
                      onPressed: () {
                        ref
                            .read(buttonLoadingNotifierProvider.notifier)
                            .changeIndex(true);

                        resetPassword(code, password.text, transH);
                      },
                      // width: width ,
                      btnColor: AppColors.primaryColor,
                      fontSize: 10.sp,
                      text: transH.reset.capitalizeAll(),
                      textColor: AppColors.whiteColor,
                      actionBtn: true,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container mobileLayout(double height, double width, int currentPage,
      BuildContext context, AppLocalizations transH) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * .02),
                IconButton(
                  onPressed: () {
                    ref
                        .read(buttonLoadingNotifierProvider.notifier)
                        .changeIndex(false);
                    if (currentPage == 1) {
                      ref.read(currentPageProvider.notifier).changePage(0);
                    } else {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        navigateReplacementNamed(
                            context, AppRoutes.splashRoute);
                      }
                    }
                  },
                  padding: const EdgeInsets.all(0),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.primaryColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(height: height * .02),
                if (currentPage == 1)
                  Text(
                    transH.resetPassword.capitalizeAll(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 24.sp,
                      fontFamily: AppFonts.actionFont,
                    ),
                  )
                else
                  Text(
                    transH.verifyOTP.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 24.sp,
                      fontFamily: AppFonts.actionFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (currentPage == 0)
                  Text(
                    transH.otpMessage,
                    style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 14.sp,
                    ),
                  )
                else
                  Text(
                    transH.newPassMessage,
                    style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 14.sp,
                    ),
                  ),
                SizedBox(height: 30.h),
                if (currentPage == 0)
                  OtpTextField(
                    // handleControllers: (controllers) => controller.phoneOTPController,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    numberOfFields: 4,
                    fieldWidth: 60.w,
                    showFieldAsBox: true,
                    autoFocus: true,
                    borderRadius: BorderRadius.circular(15),
                    styles: List.generate(
                      4,
                      (index) => TextStyle(
                          color: AppColors.primaryColor, fontSize: 14.sp),
                    ),
                    focusedBorderColor: AppColors.primaryColor,
                    onSubmit: (String value) {
                      code = value;
                    },
                  )
                else
                  FormInput(
                    width,
                    controller: password,
                    hintText: transH.enterPassword,
                    isPassword: true,
                    isLast: true,
                  ),
                SizedBox(height: 20.h),
                if (currentPage == 0)
                  CustomBtn(
                    onPressed: () {
                      ref.read(currentPageProvider.notifier).changePage(1);
                    },
                    // width: width ,
                    btnColor: AppColors.primaryColor,
                    fontSize: 16.sp,
                    text: transH.reset.capitalizeAll(),
                    textColor: AppColors.whiteColor,
                  )
                else
                  CustomBtn(
                    onPressed: () {
                      ref
                          .read(buttonLoadingNotifierProvider.notifier)
                          .changeIndex(true);

                      resetPassword(code, password.text, transH);
                    },
                    // width: width ,
                    btnColor: AppColors.primaryColor,
                    fontSize: 16.sp,
                    text: transH.reset.capitalizeAll(),
                    textColor: AppColors.whiteColor,
                    actionBtn: true,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void resetPassword(
      String code, String password, AppLocalizations transH) async {
    if (code.isEmpty || password.isEmpty || code.length < 4) {
      errorSnackBar(
        title: transH.error.capitalizeFirst.toString(),
        message: transH.fieldsRequired.capitalizeFirst.toString(),
      );
    } else if (!code.isNum) {
      errorSnackBar(
        title: transH.error.capitalizeFirst.toString(),
        message: transH.inValidEmail.capitalizeFirst.toString(),
      );
    } else if (password.length < 8) {
      errorSnackBar(
        title: transH.error.capitalizeFirst.toString(),
        message: transH.passwordinvalid.capitalizeFirst.toString(),
      );
    } else {
      final data = await ref
          .read(dataFetchControllerProvider.notifier)
          .resetPassword(code, password);
      if (data['response'] ==
              'otp already verified, new otp created check email' ||
          data['response'] == 'new otp created check email') {
        ref.read(currentPageProvider.notifier).changePage(0);
        errorSnackBar(
          title: transH.error.capitalizeFirst.toString(),
          message: transH.checkEmailForNewOTP.capitalizeFirst.toString(),
        );
      } else if (data['response'] ==
          'otp expired, new otp created check email') {
        ref.read(currentPageProvider.notifier).changePage(0);
        errorSnackBar(
          title: transH.error.capitalizeFirst.toString(),
          message:
              transH.otpExpiredcheckEmailForNewOTP.capitalizeFirst.toString(),
        );
      } else if (data['response'] == 'password reset successful') {
        navigateToPage(context, const PasswordResetSuccess());
      } else if (data['error'][0] == 'This password is too common.') {
        errorSnackBar(
          title: transH.error.capitalizeFirst.toString(),
          message: transH.pTooCommon.capitalizeFirst.toString(),
        );
      } else if (data['error'][0] ==
          'This password is too short. It must contain at least 8 characters.') {
        errorSnackBar(
          title: transH.error.capitalizeFirst.toString(),
          message: transH.pTooShort.capitalizeFirst.toString(),
        );
      } else if (data['error'] == 'network') {
        errorSnackBar(
          title: transH.error.capitalizeFirst.toString(),
          message: transH.network.capitalizeFirst.toString(),
        );
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
      } else if (data['error'] == 'invalid OTP code') {
        ref.read(currentPageProvider.notifier).changePage(0);
        errorSnackBar(
          title: transH.error.capitalizeFirst.toString(),
          message: transH.invalidOTPCode.capitalizeFirst.toString(),
        );
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
      } else {
        errorSnackBar(
          title: transH.error.capitalizeFirst.toString(),
          message: transH.unkownError.capitalizeFirst.toString(),
        );
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
      }
    }
    ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
  }
}
