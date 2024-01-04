// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/constants/colors.dart';
import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:fundz_app/helpers/functions.dart';

import '../../constants/app_routes.dart';
import '../../helpers/app_fonts.dart';
import '../../providers/providers.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/snackbars.dart';

class OTPVerificationPage extends ConsumerStatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OTPVerificationPageState();
}

class _OTPVerificationPageState extends ConsumerState<OTPVerificationPage> {
  late String code;

  @override
  void initState() {
    changeBottomBarColor(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final verifyLoading = ref.watch(verifyLoadingProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);

        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: height,
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * .02),
                        Text(
                          transH.verifyOTP.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                            fontSize: 24.sp,
                            fontFamily: AppFonts.actionFont,
                          ),
                        ),
                        Text(
                          transH.otpMessage,
                          style: TextStyle(
                            color: AppColors.greyColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        OtpTextField(
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
                        ),
                        SizedBox(height: 20.h),
                        CustomBtn(
                          onPressed: () {
                            ref
                                .read(buttonLoadingNotifierProvider.notifier)
                                .changeIndex(true);
                            verifyOTP(code, transH);
                          },
                          // width: width ,
                          btnColor: AppColors.primaryColor,
                          fontSize: 16.sp,
                          text: transH.verify.capitalizeAll(),
                          textColor: AppColors.whiteColor,
                          actionBtn: true,
                        ),
                      ],
                    ),
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${transH.didRecieveCode.capitalize()}?",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(verifyLoadingProvider.notifier)
                                .changeIndex(true);
                            resendOTP(transH);
                          },
                          child: verifyLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.primaryColor)
                              : Text(
                                  transH.resend.capitalizeAll(),
                                  style: TextStyle(
                                    color:
                                        AppColors.primaryColor.withOpacity(.7),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resendOTP(AppLocalizations transH) async {
    final data = await ref.read(dataFetchControllerProvider.notifier).getOTP();
    if (data['error'] == 'network') {
      AnimatedSnackBar.material(
        "${transH.error}, ${transH.network}".capitalize(),
        type: AnimatedSnackBarType.error,
      ).show(context);
      ref.read(verifyLoadingProvider.notifier).changeIndex(false);
    } else if (data['error'] == 'none') {
      if (data['response'] == 'otp sent to email') {
        AnimatedSnackBar.material(
          "${transH.success}, ${transH.otpSentToMail}".capitalize(),
          type: AnimatedSnackBarType.success,
        ).show(context);
        ref.read(verifyLoadingProvider.notifier).changeIndex(false);
      }
    } else {
      AnimatedSnackBar.material(
        "${transH.error}, ${transH.unkownError}".capitalize(),
        type: AnimatedSnackBarType.error,
      ).show(context);
      ref.read(verifyLoadingProvider.notifier).changeIndex(false);
    }
  }

  void verifyOTP(String code, AppLocalizations transH) async {
    if (code.isEmpty) {
      errorSnackBar(
        context: context,
        title: transH.error.capitalize(),
        message: transH.fieldsRequired.capitalize(),
      );
    } else if (!code.isNum) {
      AnimatedSnackBar.material(
        "${transH.error}, ${transH.invalidOTPCode}".capitalize(),
        type: AnimatedSnackBarType.error,
      ).show(context);
    } else if (code.length < 4) {
      AnimatedSnackBar.material(
        "${transH.error}, ${transH.invalidOTPCode}".capitalize(),
        type: AnimatedSnackBarType.error,
      ).show(context);
    } else {
      final utlController = ref.read(utlControllerProvider.notifier);
      final data =
          await ref.read(dataFetchControllerProvider.notifier).verifyOTP(code);
      if (data['error'] == 'invalid OTP code') {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.invalidOTPCode.capitalize(),
        );
      } else if (data['response'] == 'otp already verified') {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.otpAlreadyVerified.capitalize(),
        );
      } else if (data['response'] ==
          'otp expired, new otp created check email') {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.otpAlreadyExpired.capitalize(),
        );
      } else if (data['response'] == 'new otp created check email') {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.newOTPSent.capitalize(),
        );
      } else if (data['error'] == 'unknown') {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.unkownError.capitalize(),
        );
      } else if (data['error'] == 'network') {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.network.capitalize(),
        );
      } else if (data['response'] == 'otp verification successful') {
        utlController.writeData('isVerified', 'yes');
        successSnackBar(
          title: transH.success.capitalize(),
          message: transH.otpVerified.capitalize(),
        );
        navigateReplacementNamed(context, AppRoutes.home);
      } else {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.unkownError.capitalize(),
        );
      }
    }

    ref.read(verifyLoadingProvider.notifier).changeIndex(false);
  }
}

final verifyBtnProvider = StateNotifierProvider<VerifyBtnNotifier, bool>((ref) {
  return VerifyBtnNotifier();
});
final verifyLoadingProvider =
    StateNotifierProvider<VerifyLoadingNotifier, bool>((ref) {
  return VerifyLoadingNotifier();
});

class VerifyBtnNotifier extends StateNotifier<bool> {
  VerifyBtnNotifier() : super(false);

  void changeIndex(bool value) {
    state = value;
  }
}

class VerifyLoadingNotifier extends StateNotifier<bool> {
  VerifyLoadingNotifier() : super(false);

  void changeIndex(bool value) {
    state = value;
  }
}
