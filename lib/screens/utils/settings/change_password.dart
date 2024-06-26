import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/functions.dart';

import '../../../constants/colors.dart';
import '../../../helpers/app_fonts.dart';
import '../../../providers/providers.dart';
import '../../../widgets/custom_btn.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();

  @override
  void dispose() {
    oldPassword.dispose();
    newPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final obSecure = ref.watch(obSecureProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    Color? bodyColor = Theme.of(context).textTheme.bodyMedium!.color;
    final buttonLoading = ref.watch(buttonLoadingNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                padding: isTablet()
                    ? const EdgeInsets.only(left: 10)
                    : const EdgeInsets.all(0),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryColor,
                  size: isTablet() ? 16.sp : 24.sp,
                ),
              )
            : null,
        centerTitle: true,
        title: Text(
          transH.changePassword.capitalizeFirst.toString(),
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: isTablet() ? 12.sp : 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: isTablet() ? 30.w : 20),
        width: width,
        height: height * .9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              transH.changePassMessage.capitalizeFirst.toString(),
              style: TextStyle(
                  fontFamily: AppFonts.primaryFont2,
                  fontSize: isTablet() ? 8.sp : 14.sp,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(height: height * .02),
            Text(
              transH.oldPassword.capitalizeAll(),
              style: TextStyle(
                fontFamily: AppFonts.primaryFont2,
                fontSize: isTablet() ? 8.sp : 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: height * .005),
            Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkThemeShade
                    : AppColors.lightThemeShade,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: oldPassword,
                      style: TextStyle(
                        color: bodyColor,
                        fontSize: isTablet() ? 8.sp : 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textInputAction: TextInputAction.next,
                      obscureText: obSecure,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        hintText: '${transH.oldPassword}...',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(
                          color: bodyColor,
                          fontSize: isTablet() ? 8.sp : 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref
                          .read(obSecureProvider.notifier)
                          .changeState(!obSecure);
                    },
                    icon: Icon(
                      obSecure ? Icons.visibility_off : Icons.visibility,
                      color: bodyColor,
                      size: width * .01 + 20,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: height * .02),
            Text(
              transH.newPassword.capitalizeAll(),
              style: TextStyle(
                fontFamily: AppFonts.primaryFont2,
                fontSize: isTablet() ? 8.sp : 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: height * .005),
            Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkThemeShade
                    : AppColors.lightThemeShade,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: newPassword,
                      style: TextStyle(
                        color: bodyColor,
                        fontSize: isTablet() ? 8.sp : 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textInputAction: TextInputAction.go,
                      obscureText: obSecure,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        hintText: '${transH.newPassword}...',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(
                          color: bodyColor,
                          fontSize: isTablet() ? 8.sp : 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref
                          .read(obSecureProvider.notifier)
                          .changeState(!obSecure);
                    },
                    icon: Icon(
                      obSecure ? Icons.visibility_off : Icons.visibility,
                      color: bodyColor,
                      size: width * .01 + 20,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: height * .02),
            Center(
              child: CustomBtn(
                onPressed: () async {
                  if (!buttonLoading) {
                    ref
                        .read(buttonLoadingNotifierProvider.notifier)
                        .changeIndex(true);

                    var data = await ref
                        .read(userControllerProvider.notifier)
                        .changePassword(
                          context,
                          oldPassword.value.text,
                          newPassword.value.text,
                          transH,
                        );

                    if (data) {
                      ref
                          .read(buttonLoadingNotifierProvider.notifier)
                          .changeIndex(false);
                    }
                  }
                },
                width: isTablet() ? width * .35 : width * .5,
                btnColor: AppColors.primaryColor,
                fontSize: isTablet() ? 8.sp : 14.sp,
                text: transH.changePassword.capitalizeAll(),
                textColor: AppColors.whiteColor,
                actionBtn: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
