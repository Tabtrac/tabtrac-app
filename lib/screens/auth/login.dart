// ignore_for_file: use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/cli_commands.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/app_routes.dart';
import '../../constants/colors.dart';
import '../../helpers/app_fonts.dart';
import '../../helpers/functions.dart';
import '../../providers/providers.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/inputs.widgets.dart';
import '../../widgets/snackbars.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    changeBottomBarColor(false);
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final transH = AppLocalizations.of(context)!;
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
                        Navigator.canPop(context)
                            ? IconButton(
                                onPressed: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  } else {
                                    navigateReplacementNamed(
                                        context, AppRoutes.splashRoute);
                                  }
                                },
                                padding: const EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColors.primaryColor,
                                  size: 24.sp,
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(height: height * .02),
                        Text(
                          transH.welcomeBack,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                            fontFamily: AppFonts.actionFont,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        FormInput(
                          width,
                          controller: email,
                          hintText: transH.enterEmail,
                          isPassword: false,
                          isLast: false,
                        ),
                        SizedBox(height: 20.h),
                        FormInput(
                          width,
                          controller: password,
                          hintText: transH.enterPassword,
                          isPassword: true,
                          isLast: true,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              navigateNamed(
                                  context, AppRoutes.forgottenPasswordRoute);
                            },
                            child: Text(
                              "${transH.forgetPass.capitalize()}?",
                              style: TextStyle(
                                color: AppColors.blackColor.withOpacity(.7),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CustomBtn(
                          onPressed: () {
                            ref
                                .read(buttonLoadingNotifierProvider.notifier)
                                .changeIndex(true);
                            loginUser(
                              email.text,
                              password.text,
                              width,
                              transH,
                            );
                          },
                          // width: width ,
                          btnColor: AppColors.primaryColor,
                          fontSize: 16.sp,
                          text: transH.signIn,
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
                          "${transH.donHaveAcc.capitalize()}?",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            navigateNamed(context, AppRoutes.signupRoute);
                          },
                          child: Text(
                            transH.registerNow.capitalizeAll(),
                            style: TextStyle(
                              color: AppColors.primaryColor.withOpacity(.7),
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

  void loginUser(String email, String password, double width,
      AppLocalizations transH) async {
    if (email.isEmpty || password.isEmpty) {
      errorSnackBar(
        context: context,
        title: transH.error.capitalize(),
        message: transH.fieldsRequired.capitalize(),
      );
    } else if (!isEmail(email)) {
      errorSnackBar(
        context: context,
        title: transH.error.capitalize(),
        message: transH.inValidEmail.capitalize(),
      );
    } else if (password.length < 8) {
      errorSnackBar(
        context: context,
        title: transH.error.capitalize(),
        message: transH.passwordinvalid.capitalize(),
      );
    } else {
      final utlController = ref.read(utlControllerProvider.notifier);
      final data = await ref
          .read(dataFetchControllerProvider.notifier)
          .loginUser(email, password);
      if (data['error'] == 'none') {
        if (data['response'] == "successful") {
          utlController.writeData('uid', data['uid']);
          utlController.writeData('email', data['email']);
          utlController.writeData('name', data['name']);
          utlController.writeData('access_token', data['access_token']);
          utlController.writeData('refresh_token', data['refresh_token']);
          utlController.writeData('isLoggedIn', "yes");
          utlController.writeData('isVerified', "yes");
          successSnackBar(
              title: transH.success.capitalize(),
              message: transH.loginSuccess.capitalize());
          navigateReplacementNamed(context, AppRoutes.home);
        } else if (data['response'] == "not verified" ||
            data['response'] == "otp sent to email") {
          utlController.writeData('access_token', data['access_token']);
          utlController.writeData('refresh_token', data['refresh_token']);
          utlController.writeData('isLoggedIn', "yes");
          successSnackBar(
              title: transH.success.capitalize(),
              message: transH.loginSuccess.capitalize());
          navigateNamed(context, AppRoutes.otpRoute);
        }
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
      } else if (data['error'] == 'Invalid email') {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.inValidEmail.capitalize(),
        );
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
      } else if (data['error'] == 'Invalid password') {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.invalidPass.capitalize(),
        );
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
      } else if (data['error'][0] == 'This password is too common.') {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.pTooCommon.capitalize(),
        );

        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
      } else if (data['error'][0] ==
          'This password is too short. It must contain at least 8 characters.') {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.pTooShort.capitalize(),
        );
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
      } else if (data['error'] == 'network') {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.network.capitalize(),
        );
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
      } else {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.unkownError.capitalize(),
        );
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
      }
    }
    ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
  }
}
