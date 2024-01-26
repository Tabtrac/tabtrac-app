// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../constants/app_routes.dart';
import '../../constants/colors.dart';
import '../../helpers/app_enums.dart';
import '../../helpers/app_fonts.dart';
import '../../helpers/functions.dart';
import '../../providers/providers.dart';
import 'package:fundz_app/models/debt.dart';

enum MyStateUpdater {
  phoneNumber,
  email,
  none,
}

class DebtDetailedScreen extends ConsumerStatefulWidget {
  const DebtDetailedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DebtDetailedScreenState();
}

enum DebtActions {
  delete,
  edit,
  deposite,
  markAsPaid,
  email,
}

enum CurrentState { none, deleting, markingAsPaid }

class CurrentStateNotifier extends StateNotifier<CurrentState> {
  CurrentStateNotifier() : super(CurrentState.none);

  changeState(CurrentState newState) {
    state = newState;
  }
}

final currentStateProvider =
    StateNotifierProvider<CurrentStateNotifier, CurrentState>((ref) {
  return CurrentStateNotifier();
});

class _DebtDetailedScreenState extends ConsumerState<DebtDetailedScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final transH = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final debt = ref.watch(debtNotifierProvider);
    final currentState = ref.watch(currentStateProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          padding: const EdgeInsets.only(left: 10.0),
          icon: Icon(
            CupertinoIcons.arrow_left,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        title: Text(
          transH.debtDetail.capitalizeAll(),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
            fontFamily: AppFonts.actionFont,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
          textScaleFactor: 1.0,
        ),
        leadingWidth: width * .1,
        actions: <Widget>[
          if (debt.phoneNumber != '')
            IconButton(
              onPressed: () {
                final utilityController =
                    ref.read(utlControllerProvider.notifier);
                // TODO create a global instantiation of the user model
                switch (debt.currency) {
                  case 'dollar':
                    launchSMS(
                      debt.phoneNumber.toString(),
                      "${transH.reminderForThe} ${utilityController.getCurrency(Currencies.dollar)}${debt.amount} ${transH.youreOwing} Kelly Daniel\n${transH.servicedRendered} ${debt.description}",
                    );
                  default:
                    launchSMS(
                      debt.phoneNumber.toString(),
                      "${transH.reminderForThe} ${utilityController.getCurrency(Currencies.naira)}${debt.amount} ${transH.youreOwing} Kelly Daniel\n${transH.servicedRendered} ${debt.description}",
                    );
                }
              },
              icon: Icon(
                CupertinoIcons.envelope,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
              padding: const EdgeInsets.all(0),
            )
          else
            const SizedBox(),
          if (debt.phoneNumber != '')
            IconButton(
              onPressed: () {
                launchPhoneCall(debt.phoneNumber.toString());
              },
              icon: Icon(
                CupertinoIcons.phone,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
              padding: const EdgeInsets.all(0),
            )
          else
            const SizedBox(),
          popUpMenu(width, debt, transH, context),
        ],
        centerTitle: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: width,
        height: height,
        child: returnCurrentState(
            currentState, transH, width, height, debt, isDarkMode),
      ),
    );
  }

  PopupMenuButton<DebtActions> popUpMenu(
      double width, Debt debt, AppLocalizations transH, BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert_outlined,
        size: 23.sp,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context) {
        if (debt.status == 'unpaid') {
          return unpaidPopupWidgets(transH, width, debt);
        } else {
          return paidPopupWidgets(transH, width, debt);
        }
      },
      onSelected: (value) async {
        if (value == DebtActions.edit) {
          ref.read(editEebtNotifierProvider.notifier).changeValues(debt);
          navigateNamed(context, AppRoutes.debtEditRoute, debt);
        } else if (value == DebtActions.delete) {
          ref
              .read(currentStateProvider.notifier)
              .changeState(CurrentState.deleting);
          var data = await ref
              .read(debtControllerProvider.notifier)
              .deleteDebt(debt.id);
          if (data['response'] == 'Debt deleted Successfully') {
            AnimatedSnackBar.material(
              "${transH.success}, ${transH.debtDeleted}".capitalizeFirst.toString(),
              type: AnimatedSnackBarType.success,
            ).show(context);
            navigateReplacementNamed(context, AppRoutes.home);
          } else if (data['error'] == 'network') {
            AnimatedSnackBar.material(
              "${transH.error}, ${transH.network}".capitalizeFirst.toString(),
              type: AnimatedSnackBarType.error,
            ).show(context);
          } else {
            AnimatedSnackBar.material(
              "${transH.error}, ${transH.unkownError}".capitalizeFirst.toString(),
              type: AnimatedSnackBarType.error,
            ).show(context);
          }
          ref
              .read(currentStateProvider.notifier)
              .changeState(CurrentState.none);
        } else if (value == DebtActions.deposite) {
          navigateNamed(context, AppRoutes.depositeRoute, debt);
        } else if (value == DebtActions.email) {
          launchEmail(
            debt.email.toString(),
            "${transH.appName.capitalizeFirst} debt reminder",
            "message",
          );
        } else if (value == DebtActions.markAsPaid) {
          showDialog(
            context: context,
            builder: (contextT) {
              return AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  transH.confirm.capitalizeFirst.toString(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: AppFonts.actionFont,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                  textScaleFactor: 1.0,
                ),
                content: Text(
                  transH.confirmMarkAsPaid.capitalizeFirst.toString(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                  textScaleFactor: 1.0,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      transH.cancel.capitalizeFirst.toString(),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontSize: 14.sp,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      ref
                          .read(currentStateProvider.notifier)
                          .changeState(CurrentState.markingAsPaid);
                      String depositedDate =
                          DateFormat('yyyy-MM-dd').format(DateTime.now());
                      var data = await ref
                          .read(debtControllerProvider.notifier)
                          .markAsPaid(debt.id, depositedDate);
                      if (data['response'] == 'Validation error') {
                        AnimatedSnackBar.material(
                          "${transH.error}, ${transH.invalidCredentials}"
                              .capitalizeFirst.toString(),
                          type: AnimatedSnackBarType.error,
                        ).show(context);
                      } else if (data['response'] == "Debt does not exists") {
                        AnimatedSnackBar.material(
                          "${transH.error}, ${transH.unkownError}".capitalizeFirst.toString(),
                          type: AnimatedSnackBarType.error,
                        ).show(context);
                      } else if (data['response'] == "user does not exist") {
                        AnimatedSnackBar.material(
                          "${transH.error}, ${transH.invalidUser}".capitalizeFirst.toString(),
                          type: AnimatedSnackBarType.error,
                        ).show(context);
                      } else if (data['response'] == 'error') {
                        AnimatedSnackBar.material(
                          "${transH.error}, ${transH.unkownError}".capitalizeFirst.toString(),
                          type: AnimatedSnackBarType.error,
                        ).show(context);
                      } else if (data['error'] == 'network') {
                        AnimatedSnackBar.material(
                          "${transH.error}, ${transH.network}".capitalizeFirst.toString(),
                          type: AnimatedSnackBarType.error,
                        ).show(context);
                      } else if (data['response'] ==
                          "Successfully marked as paid") {
                        Debt debtRecord = debt.copyWith(status: 'paid');
                        ref
                            .read(debtNotifierProvider.notifier)
                            .changeValues(debtRecord);

                        AnimatedSnackBar.material(
                          "${transH.success}, ${transH.markedAsPaidSuccess}"
                              .capitalizeFirst.toString(),
                          type: AnimatedSnackBarType.success,
                        ).show(context);
                      } else {
                        AnimatedSnackBar.material(
                          "${transH.error}, ${transH.unkownError}".capitalizeFirst.toString(),
                          type: AnimatedSnackBarType.error,
                        ).show(context);
                      }

                      ref
                          .read(currentStateProvider.notifier)
                          .changeState(CurrentState.none);
                    },
                    child: Text(
                      transH.continueWord.capitalizeFirst.toString(),
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14.sp,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  List<PopupMenuItem<DebtActions>> paidPopupWidgets(
      AppLocalizations transH, double width, Debt debt) {
    if (debt.email != '') {
      return [
        PopupMenuItem<DebtActions>(
          value: DebtActions.email,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            transH.email.capitalizeAll(),
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppFonts.primaryFont,
            ),
          ),
        ),
        PopupMenuItem<DebtActions>(
          value: DebtActions.delete,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            transH.delete.capitalizeAll(),
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppFonts.primaryFont,
            ),
            textScaleFactor: 1.0,
          ),
        ),
      ];
    }
    return [
      PopupMenuItem<DebtActions>(
        value: DebtActions.delete,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Text(
          transH.delete.capitalizeAll(),
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: AppFonts.primaryFont,
          ),
          textScaleFactor: 1.0,
        ),
      ),
    ];
  }

  List<PopupMenuItem<DebtActions>> unpaidPopupWidgets(
      AppLocalizations transH, double width, Debt debt) {
    if (debt.email != '') {
      return [
        PopupMenuItem<DebtActions>(
          value: DebtActions.edit,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            transH.edit.capitalizeAll(),
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppFonts.primaryFont,
            ),
            textScaleFactor: 1.0,
          ),
        ),
        PopupMenuItem<DebtActions>(
          value: DebtActions.deposite,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            transH.deposite.capitalizeAll(),
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppFonts.primaryFont,
            ),
            textScaleFactor: 1.0,
          ),
        ),
        PopupMenuItem<DebtActions>(
          value: DebtActions.markAsPaid,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            transH.paid.capitalizeAll(),
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppFonts.primaryFont,
            ),
            textScaleFactor: 1.0,
          ),
        ),
        PopupMenuItem<DebtActions>(
          value: DebtActions.delete,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            transH.delete.capitalizeAll(),
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppFonts.primaryFont,
            ),
            textScaleFactor: 1.0,
          ),
        ),
        PopupMenuItem<DebtActions>(
          value: DebtActions.email,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            transH.email.capitalizeAll(),
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppFonts.primaryFont,
            ),
            textScaleFactor: 1.0,
          ),
        ),
      ];
    }
    return [
      PopupMenuItem<DebtActions>(
        value: DebtActions.edit,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Text(
          transH.edit.capitalizeAll(),
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: AppFonts.primaryFont,
          ),
          textScaleFactor: 1.0,
        ),
      ),
      PopupMenuItem<DebtActions>(
        value: DebtActions.deposite,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Text(
          transH.deposite.capitalizeAll(),
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: AppFonts.primaryFont,
          ),
          textScaleFactor: 1.0,
        ),
      ),
      PopupMenuItem<DebtActions>(
        value: DebtActions.markAsPaid,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Text(
          transH.paid.capitalizeAll(),
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: AppFonts.primaryFont,
          ),
          textScaleFactor: 1.0,
        ),
      ),
      PopupMenuItem<DebtActions>(
        value: DebtActions.delete,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Text(
          transH.delete.capitalizeAll(),
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: AppFonts.primaryFont,
          ),
          textScaleFactor: 1.0,
        ),
      ),
    ];
  }

  Widget returnCurrentState(CurrentState currentState, AppLocalizations transH,
      double width, double height, Debt debt, bool isDarkMode) {
    if (currentState == CurrentState.deleting) {
      return deletingPlaceholderWidget(transH, width, height).animate().fade();
    } else if (currentState == CurrentState.markingAsPaid) {
      return markingAsPaidPlaceholderWidget(transH, width, height)
          .animate()
          .fade();
    } else {
      return mainDataWidget(debt, transH, width, height, context, isDarkMode);
    }
  }

  Column mainDataWidget(Debt debt, AppLocalizations transH, double width,
      double height, BuildContext context, bool isDarkMode) {
    Locale currentLocale = getCurrentLocale(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              // TODO: For the name I need to remember to reduce the number of text that can be displayed to avoid overflow
              '${debt.debtorName.capitalizeFirst} ${transH.owesYou}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              textScaleFactor: 1.0,
            ),
            Text(
              moneyComma(debt.amount, debt.currency),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              textScaleFactor: 1.0,
            ),
          ],
        ),
        SizedBox(height: height * .005),
        RichText(
          text: TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: '${transH.description}: '.capitalizeFirst.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontFamily: AppFonts.actionFont,
                ),
              ),
              TextSpan(
                text: debt.description,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontFamily: AppFonts.primaryFont,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
        Container(
          width: width,
          height: 2,
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.darkThemeShade
                : AppColors.lightThemeShade,
          ),
        ),
        SizedBox(height: height * .005),
        Text(
          transH.details.capitalizeFirst.toString(),
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppFonts.actionFont,
            fontWeight: FontWeight.w700,
          ),
          textScaleFactor: 1.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: '${transH.status}: '.capitalizeFirst.toString(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontFamily: AppFonts.primaryFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: debt.status,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontFamily: AppFonts.primaryFont,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: '${transH.debtDesOne.capitalizeFirst}: ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontFamily: AppFonts.primaryFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: regularDateFormat(DateTime.parse(debt.createdDate), currentLocale.toString()),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontFamily: AppFonts.primaryFont,
                      ),
                    ),
                  ],
                ),
              ),
              if (debt.createdDate != debt.updatedDate)
                RichText(
                  text: TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: '${transH.debtDesTwo.capitalizeFirst}: ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontFamily: AppFonts.primaryFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            regularDateFormat(DateTime.parse(debt.updatedDate), currentLocale.toString()),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontFamily: AppFonts.primaryFont,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(),
              if (debt.depositedDate != null)
                RichText(
                  text: TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: '${transH.debtDesThree.capitalizeFirst}: ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontFamily: AppFonts.primaryFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: regularDateFormat(
                            DateTime.parse(debt.depositedDate.toString()), currentLocale.toString()),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontFamily: AppFonts.primaryFont,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Text(''),
            ],
          ),
        ),
      ],
    );
  }

  Column deletingPlaceholderWidget(
      AppLocalizations transH, double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          transH.deleting.capitalizeFirst.toString(),
          style: TextStyle(
            color: AppColors.dangerColor,
            fontFamily: AppFonts.actionFont,
            fontSize: width * .01 + 18,
          ),
        ),
        SizedBox(height: height * .02),
        const CircularProgressIndicator(
          color: AppColors.dangerColor,
        ),
      ],
    );
  }

  Column markingAsPaidPlaceholderWidget(
      AppLocalizations transH, double width, double height) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
      ],
    );
  }
}
