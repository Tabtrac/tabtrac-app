import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/constants/app_routes.dart';

import '../../constants/colors.dart';
import '../../helpers/functions.dart';
import '../../widgets/custom_btn.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
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
      backgroundColor: AppColors.lightThemeBg,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/img1.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    tileMode: TileMode.clamp,
                    colors: [
                      Colors.white.withOpacity(.2),
                      AppColors.whiteColor,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: 150.w,
                      child: Image.asset('assets/images/splash.png'),
                    ),
                    SizedBox(height: height * .03),
                    CustomBtn(
                      text: transH.signUp,
                      textColor: AppColors.whiteColor,
                      btnColor: AppColors.primaryColor,
                      width: width * .9,
                      fontSize: 16.sp,
                      onPressed: () {
                        navigateNamed(context, AppRoutes.signupRoute);
                      },
                    ),
                    SizedBox(height: height * .02),
                    OutlinedCustomBtn(
                      text: transH.signIn,
                      btnColor: AppColors.primaryColor,
                      textColor: AppColors.primaryColor,
                      width: width * .9,
                      fontSize: 16.sp,
                      onPressed: () {
                        navigateNamed(context, AppRoutes.loginRoute);
                      },
                    ),
                    SizedBox(height: height * .02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
