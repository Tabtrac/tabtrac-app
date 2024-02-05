// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/app_routes.dart';
import '../../constants/colors.dart';
import '../../controllers/utl_controllers.dart';
import '../../helpers/functions.dart';
import '../../providers/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  
  late Timer k;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.whiteColor,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.whiteColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final utlController = ref.read(utlControllerProvider.notifier);
      String? loggedIn = await utlController.getData('isLoggedIn');
      String? isVerified = await utlController.getData('isVerified');
      if (loggedIn == 'yes' && isVerified == 'yes') {
        UtitlityController().loadNotifications(context, ref);
      }
    });
    Future.delayed(
      const Duration(seconds: 2),
      () {
        isLoggedIn();
      },
    );

    super.initState();
  }

  void isLoggedIn() async {
    final utlController = ref.read(utlControllerProvider.notifier);
    String? loggedIn = await utlController.getData('isLoggedIn');
    String? isVerified = await utlController.getData('isVerified');
    String? needsLogOut = await utlController.getData('needsLogOut');
    String? onBoardingShown = await utlController.getData('onBoardingShown');
    String? darkMode = await utlController.getData('darkMode');
    String? lang = await utlController.getData('lang');

    if (needsLogOut == 'yes') {
      reLogout();
      navigateNamed(context, AppRoutes.loginRoute);
    }
    if (darkMode == 'yes') {
      ref.read(isDarkModeProvider.notifier).changeTheme(true);
    } else {
      ref.read(isDarkModeProvider.notifier).changeTheme(false);
    }

    switch (lang) {
      case 'fr':
        ref
            .read(languageNotifierProvider.notifier)
            .setLocale(const Locale('fr'));
      case 'hi':
        // Nigerian Pidgin
        ref
            .read(languageNotifierProvider.notifier)
            .setLocale(const Locale('hi'));
      default:
        ref
            .read(languageNotifierProvider.notifier)
            .setLocale(const Locale('en'));
    }
    
    if (loggedIn == 'null' && onBoardingShown == 'null') {
      navigateReplacementNamed(context, AppRoutes.onBoardingRoute);
    } else if (loggedIn == 'null') {
      navigateReplacementNamed(context, AppRoutes.loginRoute);
    } else if (loggedIn == 'yes' && isVerified == null || isVerified != 'yes') {
      navigateReplacementNamed(context, AppRoutes.otpRoute);
    } else if (loggedIn == 'yes' && isVerified == 'yes') {
      navigateReplacementNamed(context, AppRoutes.home);
    }
  }

  backgroundSync() async {
    final utilityController = UtitlityController();
    await utilityController.getBackgroundSync();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width * .7,
              child: Image.asset(
                'assets/images/splash.png',
                fit: BoxFit.cover,
              ),
            ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }
}
