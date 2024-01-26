import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_routes.dart';
import '../screens/auth/forget_password.dart';
import '../screens/auth/forget_password_reset.dart';
import '../screens/auth/login.dart';
import '../screens/auth/signup.dart';
import '../screens/auth/verify_otp.dart';
import '../screens/debts_/create_screen.dart';
import '../screens/debts_/debt_detail.dart';
import '../screens/debts_/deposite_screen.dart';
import '../screens/debts_/edit_screen.dart';
import '../screens/liability/create_screen.dart';
import '../screens/liability/deposite_screen.dart';
import '../screens/liability/edit_screen.dart';
import '../screens/liability/liability_detail.dart';
import '../screens/main/about.dart';
import '../screens/main/privacy_policy.dart';
import '../screens/main/statistics.dart';
import '../screens/main/terms_and_conditions.dart';
import '../screens/new_screens/actions/create.dart';
import '../screens/new_screens/actions/deposite.dart';
import '../screens/new_screens/actions/detailed.record.view.dart';
import '../screens/new_screens/client/widgets/client.details.dart';
import '../screens/new_screens/record/infinte.record.dart';
import '../screens/new_screens/root/root.dart';
import '../screens/utils/getstarted.dart';
import '../screens/utils/onboarding.dart';
import '../screens/utils/settings/change_language.dart';
import '../screens/utils/settings/change_password.dart';
import '../screens/utils/settings/push_notifications.dart';
import '../screens/utils/settings/settings.dart';
import '../screens/utils/splash_screen.dart';

class AppRouter {
  static Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
    AppRoutes.home: (context) => const RootHome(),
    AppRoutes.loginRoute: (context) => const LoginScreen(),
    AppRoutes.signupRoute: (context) => const SignUpScreen(),
    AppRoutes.onBoardingRoute: (context) => const OnBoardingScreen(),
    AppRoutes.splashRoute: (context) => const SplashScreen(),
    AppRoutes.debtDetailRoute: (context) => const DebtDetailedScreen(),
    AppRoutes.detailedLiabilityRoute: (context) =>
        const LiabilityDetailedScreen(),
    AppRoutes.createRoute: (context) => const CreateDebtScreen(),
    AppRoutes.otpRoute: (context) => const OTPVerificationPage(),
    AppRoutes.forgottenPasswordRoute: (context) => const ForgottenPassword(),
    AppRoutes.forgottenPasswordResetRoute: (context) =>
        const ForgottenPasswordResetScreen(),
    AppRoutes.settingsRoute: (context) => const SettingsScreen(),
    AppRoutes.debtEditRoute: (context) => const UpdateDebtScreen(),
    AppRoutes.depositeRoute: (context) => const DepositeDebtScreen(),
    AppRoutes.createLiabilityRoute: (context) => const CreateLiabilityScreen(),
    AppRoutes.updateLiabilityRoute: (context) => const UpdateLiabiltyScreen(),
    AppRoutes.depositeLiabilityRoute: (context) =>
        const DepositeLiabilityScreen(),
    AppRoutes.chartsRoute: (context) => const StatisticScreen(),
    AppRoutes.changeLangRoute: (context) => const Changelanguage(),
    AppRoutes.changePasswordRoute: (context) => const ChangePassword(),
    AppRoutes.pushNotificationRoute: (context) =>
        const PushNotifcationSetting(),
    AppRoutes.privacyRoute: (context) => const PrivacyPolicy(),
    AppRoutes.termsRoute: (context) => const TermsAndConditions(),
    AppRoutes.aboutRoute: (context) => const AboutScreen(),

    // new screens
    AppRoutes.getStartedRoute: (context) => const GetStarted(),
    AppRoutes.createNewRecord: (context) => const CreateScreen(),
    AppRoutes.detailedRecord: (context) => const DetailedRecordView(),
    AppRoutes.clientDetailsRoutes: (context) => const ClientDetails(),
    AppRoutes.recordDepositeRoutes: (context) => const DepositeScreen(),
    AppRoutes.infiniteRecord: (context) => const InfiniteRecord(),
  };
  // GoRouter router = GoRouter(
  //   initialLocation: AppRoutes.splashRoute,
  //   routes: [
  //     GoRoute(
  //       name:
  //           'home',
  //       path: AppRoutes.home,
  //       pageBuilder: (context, state) {
  //         return CustomTransitionPage(
  //           key: state.pageKey,
  //           child: const HomeScreen(),
  //           transitionsBuilder:
  //               (context, animation, secondaryAnimation, child) {
  //             const begin = Offset(1.0, 0.0);
  //             const end = Offset.zero;
  //             var tween = Tween(begin: begin, end: end);
  //             var offsetAnimation = animation.drive(tween);

  //             return SlideTransition(
  //               position: offsetAnimation,
  //               child: child,
  //             );
  //           },
  //         );
  //       },
  //     ),
  //     GoRoute(
  //       path: AppRoutes.onBoardingRoute,
  //       pageBuilder: (context, state) {
  //         return CustomTransitionPage(
  //           key: state.pageKey,
  //           child: const OnBoardingScreen(),
  //           transitionsBuilder:
  //               (context, animation, secondaryAnimation, child) {
  //             const begin = Offset(1.0, 0.0);
  //             const end = Offset.zero;
  //             var tween = Tween(begin: begin, end: end);
  //             var offsetAnimation = animation.drive(tween);

  //             return SlideTransition(
  //               position: offsetAnimation,
  //               child: child,
  //             );
  //           },
  //         );
  //       },
  //     ),
  //     GoRoute(
  //       path: AppRoutes.loginRoute,
  //       pageBuilder: (context, state) {
  //         return CustomTransitionPage(
  //           key: state.pageKey,
  //           child: const LoginScreen(),
  //           transitionsBuilder:
  //               (context, animation, secondaryAnimation, child) {
  //             const begin = Offset(1.0, 0.0);
  //             const end = Offset.zero;
  //             var tween = Tween(begin: begin, end: end);
  //             var offsetAnimation = animation.drive(tween);

  //             return SlideTransition(
  //               position: offsetAnimation,
  //               child: child,
  //             );
  //           },
  //         );
  //       },
  //     ),
  //     GoRoute(
  //       path: AppRoutes.signupRoute,
  //       pageBuilder: (context, state) {
  //         return CustomTransitionPage(
  //           key: state.pageKey,
  //           child: const SignUpScreen(),
  //           transitionsBuilder:
  //               (context, animation, secondaryAnimation, child) {
  //             const begin = Offset(1.0, 0.0);
  //             const end = Offset.zero;
  //             var tween = Tween(begin: begin, end: end);
  //             var offsetAnimation = animation.drive(tween);

  //             return SlideTransition(
  //               position: offsetAnimation,
  //               child: child,
  //             );
  //           },
  //         );
  //       },
  //     ),
  //     GoRoute(
  //       path: AppRoutes.splashRoute,
  //       pageBuilder: (context, state) {
  //         return CustomTransitionPage(
  //           key: state.pageKey,
  //           child: const SplashScreen(),
  //           transitionsBuilder:
  //               (context, animation, secondaryAnimation, child) {
  //             const begin = Offset(1.0, 0.0);
  //             const end = Offset.zero;
  //             var tween = Tween(begin: begin, end: end);
  //             var offsetAnimation = animation.drive(tween);

  //             return SlideTransition(
  //               position: offsetAnimation,
  //               child: child,
  //             );
  //           },
  //         );
  //       },
  //     ),
  //     GoRoute(
  //       name: 'profile',
  //       path: '/profile',
  //       pageBuilder: (context, state) => CustomTransitionPage(
  //         child: const ProfileScreen(),
  //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //           const begin = Offset(1.0, 0.0);
  //           const end = Offset.zero;
  //           var tween = Tween(begin: begin, end: end);
  //           var offsetAnimation = animation.drive(tween);

  //           return SlideTransition(
  //             position: offsetAnimation,
  //             child: child,
  //           );
  //         },
  //       ),
  //     ),
  //   ],
  // );
}
