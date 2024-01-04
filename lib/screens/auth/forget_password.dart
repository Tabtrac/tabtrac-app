// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/app_extensions.dart';

import '../../constants/app_routes.dart';
import '../../constants/colors.dart';
import '../../controllers/utl_controllers.dart';
import '../../helpers/app_fonts.dart';
import '../../helpers/functions.dart';
import '../../providers/providers.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/inputs.widgets.dart';
import '../../widgets/snackbars.dart';

class ForgottenPassword extends ConsumerStatefulWidget {
  const ForgottenPassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgottenPasswordState();
}

final emailControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);

class _ForgottenPasswordState extends ConsumerState<ForgottenPassword> {
  @override
  void initState() {
    changeBottomBarColor(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final email = ref.watch(emailControllerProvider);
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
                        IconButton(
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
                        ),
                        SizedBox(height: height * .02),
                        Text(
                          "${transH.forgetPass}?".capitalize(),
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.actionFont,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          transH.forgottenPassMessage,
                          style: TextStyle(
                            color: AppColors.greyColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        FormInput(
                          width,
                          controller: email,
                          hintText: transH.enterEmail.capitalize(),
                          isPassword: false,
                          isLast: true,
                        ),
                        SizedBox(height: 20.h),
                        CustomBtn(
                          onPressed: () {
                            ref
                                .read(buttonLoadingNotifierProvider.notifier)
                                .changeIndex(true);
                            ref
                                .read(currentPageProvider.notifier)
                                .changePage(0);
                            sendPasswordOTP(
                              email.text,
                              transH,
                            );
                          },
                          // width: width ,
                          btnColor: AppColors.primaryColor,
                          fontSize: 16.sp,
                          text: transH.sendCode.capitalizeAll(),
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
                          "${transH.rememberPass.capitalize()}?",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              navigateReplacementNamed(
                                  context, AppRoutes.splashRoute);
                            }
                          },
                          child: Text(
                            transH.loginNow.capitalizeAll(),
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

  void sendPasswordOTP(String email, AppLocalizations transH) async {
    if (email.isEmpty) {
      errorSnackBar(
        context: context,
        title: transH.error.capitalize(),
        message: transH.fieldsRequired.capitalize(),
      );
    } else if (!email.isEmail) {
      errorSnackBar(
        context: context,
        title: transH.inValidEmail.capitalize(),
        message: transH.fieldsRequired.capitalize(),
      );
    } else {
      final data = await ref
          .read(dataFetchControllerProvider.notifier)
          .sendPasswordOTP(email);
      final utilityController = UtitlityController();
      if (data['error'] == 'email not found') {
        errorSnackBar(
          title: transH.error.capitalize(),
          message: transH.inValidEmail.capitalize(),
        );
      } else if (data['response'] == 'otp sent') {
        utilityController.writeData('access_token', data['access_token']);
        utilityController.writeData('refresh_token', data['refresh_token']);
        successSnackBar(
          title: transH.success.capitalize(),
          message: transH.otpCodeSentToMail.capitalize(),
        );
        navigateNamed(context, AppRoutes.forgottenPasswordResetRoute);
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
