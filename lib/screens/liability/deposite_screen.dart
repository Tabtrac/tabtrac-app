// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/colors.dart';
import '../../helpers/app_fonts.dart';
import '../../helpers/functions.dart';
import '../../helpers/app_extensions.dart';
import '../../helpers/notification_helpers.dart';
import '../../models/liability.dart';
import '../../providers/providers.dart';
import '../../providers/textfield_providers.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/snackbars.dart';

class DepositeLiabilityScreen extends ConsumerStatefulWidget {
  const DepositeLiabilityScreen({super.key});

  @override
  ConsumerState<DepositeLiabilityScreen> createState() =>
      _DepositeLiabilityScreenState();
}

// Providers
final descriptionControllerProvider =
    Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);
final priceControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);
final paymentDateControllerProvider =
    StateNotifierProvider.autoDispose<TextFieldNotifier, TextEditingController>(
        (ref) {
  return TextFieldNotifier();
});

class _DepositeLiabilityScreenState
    extends ConsumerState<DepositeLiabilityScreen> {
  @override
  void initState() {
    changeBottomBarColor(ref.read(isDarkModeProvider));
    fillData();
    super.initState();
  }
  late String currencies;

  void fillData() async {
    Liability liability = ref.read(liabilityNotifierProvider);

    currencies = liability.currency;
    ref.read(descriptionControllerProvider).text = liability.description;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final transH = AppLocalizations.of(context)!;

    final descriptionController = ref.watch(descriptionControllerProvider);
    final priceController = ref.watch(priceControllerProvider);
    final paymentDateController = ref.watch(paymentDateControllerProvider);
    final buttonLoadingProvider = ref.watch(buttonLoadingNotifierProvider);

    final isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            CupertinoIcons.arrow_left,
            color: isDarkMode
                ? AppColors.darkThemeColor
                : AppColors.lightThemeColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          transH.deposite.toUpperCase(),
          style: TextStyle(
            color: isDarkMode
                ? AppColors.darkThemeColor
                : AppColors.lightThemeColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: width,
        height: height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: height * .02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${transH.nextPaymentDate.capitalizeAll()} *',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.darkThemeColor
                          : AppColors.lightThemeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: width * .01 + 18,
                    ),
                  ),
                  SizedBox(height: height * .01),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkThemeShade
                          : AppColors.lightThemeShade,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            onTap: () {
                              pickDate();
                            },
                            controller: paymentDateController,
                            readOnly: true,
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.darkThemeColor
                                  : AppColors.lightThemeColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: 'YYYY-MM-DD',
                              hintStyle: TextStyle(
                                color: isDarkMode
                                    ? AppColors.darkThemeColor
                                    : AppColors.lightThemeColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            pickDate();
                          },
                          icon: Icon(
                            Ionicons.calendar_outline,
                            color: isDarkMode
                                ? AppColors.darkThemeColor
                                : AppColors.lightThemeColor,
                            size: 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * .02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${transH.price.capitalizeAll()} *',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.darkThemeColor
                          : AppColors.lightThemeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: width * .01 + 18,
                    ),
                  ),
                  SizedBox(height: height * .01),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkThemeShade
                          : AppColors.lightThemeShade,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            returnCurrency(currencies),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: priceController,
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.darkThemeColor
                                  : AppColors.lightThemeColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: '20,000',
                              hintStyle: TextStyle(
                                color: isDarkMode
                                    ? AppColors.darkThemeColor
                                    : AppColors.lightThemeColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp,
                              ),
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * .02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: height * .02),
                  Text(
                    '${transH.description.capitalizeAll()} *',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.darkThemeColor
                          : AppColors.lightThemeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: width * .01 + 18,
                    ),
                  ),
                  SizedBox(height: height * .01),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkThemeShade
                          : AppColors.lightThemeShade,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Expanded(
                      flex: 1,
                      child: TextField(
                        controller: descriptionController,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.darkThemeColor
                              : AppColors.lightThemeColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                        maxLines: 5,
                        minLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: '${transH.descriptionText.capitalize()}...',
                          hintStyle: TextStyle(
                            color: isDarkMode
                                ? AppColors.darkThemeColor
                                : AppColors.lightThemeColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * .02),
              Align(
                alignment: Alignment.center,
                child: CustomBtn(
                  onPressed: () {
                    ref
                        .read(buttonLoadingNotifierProvider.notifier)
                        .changeIndex(true);
                    buttonLoadingProvider
                        ? null
                        : doneBtn(
                            width,
                            height,
                            transH,
                            descriptionController,
                            priceController,
                            paymentDateController,
                          );
                  },
                  width: width * .65,
                  btnColor: AppColors.primaryColor,
                  fontSize: 18.sp,
                  text: transH.edit,
                  textColor: AppColors.blackColor,
                  actionBtn: true,
                ),
              ),
              SizedBox(height: height * .02),
            ],
          ),
        ),
      ),
    );
  }

  pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      ref.read(paymentDateControllerProvider.notifier).state.text =
          formattedDate;
    } else {}
  }

  void doneBtn(
    double width,
    double height,
    AppLocalizations transH,
    TextEditingController descriptionController,
    TextEditingController priceController,
    TextEditingController paymentDateController,
  ) async {
    Liability liability = ref.read(liabilityNotifierProvider);

    String paymentDate = paymentDateController.value.text;
    String price = priceController.value.text;
    String description = descriptionController.value.text;

    if (paymentDate.isEmpty || price.isEmpty || description.isEmpty) {
      errorSnackBar(
        context: context,
        title: transH.error.capitalize(),
        message: transH.fieldsRequired.capitalize(),
      );
      ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
    } else if (!price.isNumericOnly) {
      AnimatedSnackBar.material(
        "${transH.error}, ${transH.unkownError}".capitalize(),
        type: AnimatedSnackBarType.error,
      ).show(context);
      ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
    } else if (double.parse(liability.amount) <= double.parse(price)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              transH.warning.capitalizeFirst.toString(),
              style: TextStyle(
                fontSize: width * .01 + 18,
                fontFamily: AppFonts.actionFont,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            content: Text(
              transH.depositedAmountPastAmount.capitalizeFirst.toString(),
              style: TextStyle(
                fontSize: 18.sp,
                color: Theme.of(context).textTheme.bodyMedium!.color,
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
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    fontSize: width * .01 + 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  runPaid(liability, paymentDate, price, description, transH);
                },
                child: Text(
                  transH.continueWord.capitalizeFirst.toString(),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: width * .01 + 14,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      runPaid(liability, paymentDate, price, description, transH);
    }
  }

  void runPaid(Liability liability, paymentDate, price, String description,
      AppLocalizations transH) async {
    {
      String depositedDate =
          DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now());
      var data = await ref
          .read(liabilityControllerControllerProvider.notifier)
          .depositedOnLiability(
            liability.id,
            paymentDate,
            price,
            description,
            depositedDate,
          );

      if (data['response'] == 'Validation error') {
        AnimatedSnackBar.material(
          "${transH.error}, ${transH.invalidCredentials}".capitalize(),
          type: AnimatedSnackBarType.error,
        ).show(context);
      } else if (data['response'] == "Debt does not exists") {
        errorSnackBar(
          context: context,
          title: transH.error.capitalize(),
          message: transH.unkownError.capitalize(),
        );
      } else if (data['response'] == "user does not exist") {
        Navigator.pop(context);
        AnimatedSnackBar.material(
          "${transH.error}, ${transH.invalidUser}".capitalize(),
          type: AnimatedSnackBarType.error,
        ).show(context);
      } else if (data['response'] == 'error') {
        errorSnackBar(
          context: context,
          title: transH.error.capitalize(),
          message: transH.unkownError.capitalize(),
        );
      } else if (data['error'] == 'network') {
        errorSnackBar(
          context: context,
          title: transH.error.capitalize(),
          message: transH.network.capitalize(),
        );
      } else if (data['response'] == "Deposit Successful") {
        // TODO: remember to edit the error messages in this file and the backend too
        Liability debtRecord = liability.copyWith(
          amount: (int.parse(liability.amount) - int.parse(price)).toString(),
          depositedDate: depositedDate,
          description: description,
        );
        LocalNotifications.showNotification(
            title: transH.success.capitalize(),
            body: transH.depositSuccess.capitalize(),
            payload: '');
        ref.read(liabilityNotifierProvider.notifier).changeValues(debtRecord);
        Navigator.pop(context);
        AnimatedSnackBar.material(
          "${transH.success}, ${transH.depositSuccess}".capitalize(),
          type: AnimatedSnackBarType.success,
        ).show(context);
      } else {
        errorSnackBar(
          context: context,
          title: transH.error.capitalize(),
          message: transH.unkownError.capitalize(),
        );
      }
      ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
    }
  }
}
