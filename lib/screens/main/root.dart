import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:fundz_app/helpers/notification_helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_routes.dart';
import '../../constants/colors.dart';
import '../../helpers/app_fonts.dart';
import '../../helpers/functions.dart';
import '../../providers/providers.dart';
import '../../widgets/snackbars.dart';
import 'liability_data.dart';
import 'home_data.dart';
import 'me_data.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // int currentIndex = 0;

  List<Widget> screens = [
    const HomeData(),
    const ActivityData(),
    const MeData(),
  ];

  @override
  void initState() {
    changeBottomBarColor(ref.read(isDarkModeProvider));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final transH = AppLocalizations.of(context)!;
    final isDarkMode = ref.watch(isDarkModeProvider);
    final currentIndex = ref.watch(currentIndexProvider);

    Color themeShade =
        isDarkMode ? AppColors.darkThemeShade : AppColors.lightThemeShade;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: pageTitle(transH, width, context),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                errorSnackBar(context: context, title: 'Error', message: 'All fields are required');
                // LocalNotifications.showNotification(title: 'Welcome notification', body: 'Welcome to tabtrac our extemed guest', payload: 'payload');
                // LocalNotifications.scheduleNotification(title: 'Welcome notification 2', body: 'Welcome to tabtrac our extemed guest 2', payload: 'payload');
              },
              icon: Icon(
                Ionicons.stats_chart_outline,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            IconButton(
              onPressed: () {
                navigateNamed(context, AppRoutes.settingsRoute);
              },
              padding: const EdgeInsets.all(0),
              icon: Icon(
                Ionicons.settings_outline,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                size: 25.sp,
              ),
            ),
          ],
        ),
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        floatingActionButton: currentIndex == 2
            ? null
            : FloatingActionButton(
                onPressed: () {
                  if (currentIndex == 0) {
                    navigateNamed(context, AppRoutes.createRoute);
                  } else if (currentIndex == 1) {
                    navigateNamed(context, AppRoutes.createLiabilityRoute);
                  }
                },
                backgroundColor: AppColors.primaryColor,
                child: Icon(
                  currentIndex == 0
                      ? Ionicons.add
                      : Ionicons.add_circle_outline,
                  color: AppColors.blackColor,
                  size: width * .01 + 32,
                ).animate().scale(),
              ),
        bottomNavigationBar: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Theme.of(context).colorScheme.background,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    ref.read(currentIndexProvider.notifier).changeIndex(0);
                  },
                  child: Container(
                    // duration: const Duration(seconds: 1),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      color:
                          currentIndex == 0 ? themeShade : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          currentIndex == 0
                              ? Ionicons.document
                              : Ionicons.document_outline,
                          color: currentIndex == 0
                              ? AppColors.primaryColor
                              : AppColors.greyColor,
                        ),
                        SizedBox(width: width * .01),
                        Text(
                          transH.debts,
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: currentIndex == 0
                                ? AppColors.primaryColor
                                : AppColors.greyColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(currentIndexProvider.notifier).changeIndex(1);
                  },
                  child: Container(
                    // duration: const Duration(seconds: 1),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      color:
                          currentIndex == 1 ? themeShade : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          currentIndex != 1
                              ? Ionicons.document_text
                              : Ionicons.document_text_outline,
                          color: currentIndex == 1
                              ? AppColors.primaryColor
                              : Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        SizedBox(width: width * .01),
                        Text(
                          transH.liabilities,
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: currentIndex == 1
                                ? AppColors.primaryColor
                                : Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(currentIndexProvider.notifier).changeIndex(2);
                  },
                  child: Container(
                    // duration: const Duration(seconds: 1),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                        color:
                            currentIndex == 2 ? themeShade : Colors.transparent,
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          currentIndex == 2
                              ? Ionicons.person
                              : Ionicons.person_outline,
                          color: currentIndex == 2
                              ? AppColors.primaryColor
                              : Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        SizedBox(width: width * .01),
                        Text(
                          transH.me,
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: currentIndex == 2
                                ? AppColors.primaryColor
                                : Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text pageTitle(AppLocalizations transH, double width, BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);

    switch (currentIndex) {
      case 0:
        return Text(
          transH.debts.capitalizeFirst.toString(),
          style: TextStyle(
            fontFamily: AppFonts.actionFont,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          textScaleFactor: 1.0,
        );
      case 1:
        return Text(
          transH.liabilities.capitalizeFirst.toString(),
          style: TextStyle(
            fontFamily: AppFonts.actionFont,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          textScaleFactor: 1.0,
        );
      case 2:
        return Text(
          transH.account.capitalizeFirst.toString(),
          style: TextStyle(
            fontFamily: AppFonts.actionFont,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          textScaleFactor: 1.0,
        );
      default:
        return Text(
          transH.appName.capitalizeFirst.toString(),
          style: TextStyle(
            fontFamily: AppFonts.actionFont,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          textScaleFactor: 1.0,
        );
    }
  }
}
