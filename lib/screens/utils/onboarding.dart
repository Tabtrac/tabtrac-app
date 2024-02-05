import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_routes.dart';
import '../../constants/colors.dart';
import '../../helpers/app_fonts.dart';
import '../../helpers/functions.dart';
import '../../providers/providers.dart';

// Providers
class CurrentIndexNotifier extends StateNotifier<int> {
  CurrentIndexNotifier() : super(0);

  void changeCurrentIndex(int index) {
    state = index;
  }
}

final currentIndexProvider =
    StateNotifierProvider<CurrentIndexNotifier, int>((ref) {
  return CurrentIndexNotifier();
});

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  ConsumerState<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  PageController controller = PageController();
  @override
  void initState() {
    changeBottomBarColor(false);
    final utlController = ref.read(utlControllerProvider.notifier);
    utlController.writeData('onBoardingShown', "yes");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final transH = AppLocalizations.of(context)!;
    List<OnbordingDataModel> onboardingData = [
      OnbordingDataModel(
        svg: 'assets/svgs/onboarding-1.svg',
        title: transH.onboardingMessageOneTitle,
        message: transH.onboardingMessageOneMessage,
      ),
      OnbordingDataModel(
        svg: 'assets/svgs/onboarding-2.svg',
        title: transH.onboardingMessageTwoTitle,
        message: transH.onboardingMessageTwoMessage,
      ),
      OnbordingDataModel(
        svg: 'assets/svgs/onboarding-3.svg',
        title: transH.onboardingMessageThreeTitle,
        message: transH.onboardingMessageThreeMessage,
      ),
    ];

    final currentIndex = ref.watch(currentIndexProvider);
    return Scaffold(
      backgroundColor: AppColors.lightThemeBg,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: width,
                height: height * .8,
                child: PageView.builder(
                  itemCount: onboardingData.length,
                  onPageChanged: (value) {
                    ref
                        .read(currentIndexProvider.notifier)
                        .changeCurrentIndex(value);
                  },
                  scrollDirection: Axis.horizontal,
                  controller: controller,
                  itemBuilder: (context, index) {
                    OnbordingDataModel data = onboardingData[index];
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 600) {
                          return TabletLayout(data: data, height: height).animate().scaleXY();
                        } else {
                          return MobileLayout(data: data, height: height).animate().scaleXY();
                        }
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: height * .02),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.only(bottom: 5.h),
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: List.generate(
                        onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: currentIndex == index ? 60 : 10,
                          margin: const EdgeInsets.only(right: 5),
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (currentIndex >= 2) {
                          navigateNamed(context, AppRoutes.getStartedRoute);
                        } else {
                          controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        }
                      },
                      shape: const CircleBorder(),
                      backgroundColor: AppColors.primaryColor,
                      child: const Icon(
                        CupertinoIcons.arrow_right,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({
    super.key,
    required this.data,
    required this.height,
  });

  final OnbordingDataModel data;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 300.h,
          height: 300.h,
          child: SvgPicture.asset(
            data.svg,
            semanticsLabel: data.title,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: height * .06),
        Text(
          data.title,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.actionFont,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: height * .01),
        Text(
          data.message,
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 14.sp,
            fontFamily: AppFonts.primaryFont,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class TabletLayout extends StatelessWidget {
  const TabletLayout({
    super.key,
    required this.data,
    required this.height,
  });

  final OnbordingDataModel data;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 350.w,
          height: 350.h,
          child: SvgPicture.asset(
            data.svg,
            semanticsLabel: data.title,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: height * .06),
        FittedBox(
          child: Text(
            data.title,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.actionFont,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: height * .01),
        Text(
          data.message,
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 8.sp,
            fontFamily: AppFonts.primaryFont,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class OnbordingDataModel {
  final String svg;
  final String title;
  final String message;

  OnbordingDataModel(
      {required this.svg, required this.title, required this.message});
}
