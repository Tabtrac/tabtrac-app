// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/constants/colors.dart';
import 'package:fundz_app/helpers/app_extensions.dart';

import '../../constants/app_routes.dart';
import '../../helpers/app_fonts.dart';
import '../../helpers/functions.dart';
import '../../providers/providers.dart';

// Providers
class NameControllerNotifier extends StateNotifier<String?> {
  NameControllerNotifier() : super(null);

  void changeState(String? value) {
    state = value;
  }
}

class EmailControllerNotifier extends StateNotifier<String?> {
  EmailControllerNotifier() : super(null);

  void changeState(String? value) {
    state = value;
  }
}

class IsLoadingControllerNotifier extends StateNotifier<bool> {
  IsLoadingControllerNotifier() : super(true);

  void changeState(bool value) {
    state = value;
  }
}

final nameStateProvider =
    StateNotifierProvider.autoDispose<NameControllerNotifier, String?>((ref) {
  return NameControllerNotifier();
});
final emailStateProvider =
    StateNotifierProvider.autoDispose<EmailControllerNotifier, String?>((ref) {
  return EmailControllerNotifier();
});
final isLoadingStateProvider =
    StateNotifierProvider.autoDispose<IsLoadingControllerNotifier, bool>((ref) {
  return IsLoadingControllerNotifier();
});

class MeData extends ConsumerStatefulWidget {
  const MeData({super.key});

  @override
  ConsumerState<MeData> createState() => _MeDataState();
}

class _MeDataState extends ConsumerState<MeData> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  // TODO: this needs to be worked on, due to error during multiple clicks
  void getData() async {
    var userData =
        await ref.read(userControllerProvider.notifier).getUserData();

    if (userData['response'] == 'done') {
      ref
          .read(nameStateProvider.notifier)
          .changeState(userData['data']['name']);
      ref
          .read(emailStateProvider.notifier)
          .changeState(userData['data']['email']);

      ref.read(isLoadingStateProvider.notifier).changeState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final transH = AppLocalizations.of(context)!;

    final name = ref.watch(nameStateProvider);
    final email = ref.watch(emailStateProvider);
    final isLoading = ref.watch(isLoadingStateProvider);
    return SizedBox(
      width: width,
      height: height,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: width * .3,
                  height: width * .3,
                  decoration: BoxDecoration(
                    // color: isDarkMode
                    //     ? AppColors.darkThemeShade
                    //     : AppColors.lightThemeShade,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    CupertinoIcons.person_circle,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    size: width * .05 + 72,
                  ),
                ),
                Text(
                  name.toString(),
                  style: TextStyle(
                    fontSize: width * .01 + 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.primaryFont2,
                  ),
                ),
                SizedBox(height: height * .02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.email,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    SizedBox(width: width * .008),
                    Text(
                      email.toString(),
                      style: TextStyle(
                        fontSize: width * .01 + 16,
                        fontWeight: FontWeight.normal,
                        fontFamily: AppFonts.primaryFont2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * .02),
                OutlinedButton(
                  onPressed: () {
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
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                    ),
                  ),
                  child: Text(
                    transH.logout.capitalizeFirst.toString(),
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: width * .01 + 14,
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(),
    );
  }
}
