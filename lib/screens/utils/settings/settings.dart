import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/app_fonts.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:ionicons/ionicons.dart';

import '../../../constants/app_routes.dart';
import '../../../constants/colors.dart';
import '../../../providers/providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    changeBottomBarColor(ref.read(isDarkModeProvider));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final transH = AppLocalizations.of(context)!;
    final isDarkMode = ref.watch(isDarkModeProvider);
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
                padding: isTablet() ? const EdgeInsets.only(left: 10) : const EdgeInsets.all(0),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryColor,
                  size: isTablet() ? 16.sp : 24.sp,
                ),
              )
            : null,
        centerTitle: true,
        title: Text(
          transH.settings.capitalizeFirst.toString(),
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: isTablet() ? 12.sp : 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: isTablet() ? 40.w : 15),
        width: width,
        height: height * .9,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: height * .03),
              Text(
                transH.security.toUpperCase(),
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 12,
                ),
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Ionicons.lock_closed_outline,
                    color: AppColors.primaryColor,
                  ),
                ),
                title: Text(
                  transH.changePassword.capitalizeAll(),
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.primaryFont,
                      fontSize: width * .01 + 14,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor,
                ),
                onTap: () {
                  navigateNamed(context, AppRoutes.changePasswordRoute);
                },
              ),
              // SizedBox(height: height * .02),
              // Text(
              //   transH.permisions.toUpperCase(),
              //   style: TextStyle(
              //     color: AppColors.greyColor,
              //     fontFamily: AppFonts.actionFont,
              //     fontSize: width * .01 + 12,
              //   ),
              // ),
              // ListTile(
              //   leading: Container(
              //     width: 50,
              //     height: 50,
              //     decoration: BoxDecoration(
              //       color: AppColors.primaryColor.withOpacity(.2),
              //       borderRadius: BorderRadius.circular(99),
              //     ),
              //     alignment: Alignment.center,
              //     child: const Icon(
              //       Ionicons.notifications_outline,
              //       color: AppColors.primaryColor,
              //     ),
              //   ),
              //   title: Text(
              //     transH.pushNotifications.capitalizeAll(),
              //     style: TextStyle(
              //         color: AppColors.primaryColor,
              //         fontFamily: AppFonts.primaryFont,
              //         fontSize: width * .01 + 14,
              //         fontWeight: FontWeight.w500),
              //   ),
              //   contentPadding:
              //       const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              //   trailing: const Icon(
              //     Icons.arrow_forward_ios,
              //     color: AppColors.primaryColor,
              //   ),
              //   onTap: () {
              //     navigateNamed(context, AppRoutes.pushNotificationRoute);
              //   },
              // ),
              SizedBox(height: height * .02),
              Text(
                transH.preferences.toUpperCase(),
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 12,
                ),
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Ionicons.language_outline,
                    color: AppColors.primaryColor,
                  ),
                ),
                title: Text(
                  transH.changeLanguage.capitalizeAll(),
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.primaryFont,
                      fontSize: width * .01 + 14,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor,
                ),
                onTap: () {
                  navigateNamed(context, AppRoutes.changeLangRoute);
                },
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Ionicons.moon_outline,
                    color: AppColors.primaryColor,
                  ),
                ),
                title: Text(
                  transH.darkMode.capitalizeAll(),
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.primaryFont,
                      fontSize: width * .01 + 14,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    ref
                        .read(isDarkModeProvider.notifier)
                        .changeTheme(!isDarkMode);
                    changeBottomBarColor(ref.read(isDarkModeProvider));
                  },
                ),
                onTap: () {
                  ref
                      .read(isDarkModeProvider.notifier)
                      .changeTheme(!isDarkMode);
                    changeBottomBarColor(ref.read(isDarkModeProvider));
                },
              ),
              SizedBox(height: height * .02),
              Text(
                transH.others.toUpperCase(),
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 12,
                ),
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Ionicons.document_lock_outline,
                    color: AppColors.primaryColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor,
                ),
                title: Text(
                  transH.privacyPolicy.capitalizeAll(),
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.primaryFont,
                      fontSize: width * .01 + 14,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                onTap: () {
                  navigateNamed(context, AppRoutes.privacyRoute);
                },
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Ionicons.document_outline,
                    color: AppColors.primaryColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor,
                ),
                title: Text(
                  transH.termsAndConditions.capitalizeAll(),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: AppFonts.primaryFont,
                    fontSize: width * .01 + 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                onTap: () {
                  navigateNamed(context, AppRoutes.termsRoute);
                },
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Ionicons.information_circle_outline,
                    color: AppColors.primaryColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor,
                ),
                title: Text(
                  transH.about.capitalizeAll(),
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.primaryFont,
                      fontSize: width * .01 + 14,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                onTap: () {
                  navigateNamed(context, AppRoutes.aboutRoute);
                },
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.feedback_outlined,
                    color: AppColors.primaryColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor,
                ),
                title: Text(
                  transH.feedback.capitalizeAll(),
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.primaryFont,
                      fontSize: width * .01 + 14,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                onTap: () {
                  launchEmail('tabtrac.business@gmail.com', 'Feedback on Tabtrac', '');
                },
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Ionicons.log_out_outline,
                    color: AppColors.primaryColor,
                  ),
                ),
                title: Text(
                  transH.logout.capitalizeAll(),
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.primaryFont,
                      fontSize: width * .01 + 14,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        title: Text(
                          transH.logout.capitalizeFirst.toString(),
                          style: TextStyle(
                            fontSize: width * .01 + 18,
                            fontFamily: AppFonts.actionFont,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        content: Text(
                          transH.logoutMessage.capitalizeFirst.toString(),
                          style: TextStyle(
                            fontSize: width * .01 + 16,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              transH.cancel.capitalizeFirst.toString(),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                                fontSize: width * .01 + 14,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              reLogout();
                              Navigator.of(context).pop();
                              navigateReplacementNamed(
                                  context, AppRoutes.loginRoute);
                            },
                            child: Text(
                              transH.logout.capitalizeFirst.toString(),
                              style: TextStyle(
                                color: AppColors.dangerColor,
                                fontSize: width * .01 + 14,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
