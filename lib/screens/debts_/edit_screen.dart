// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/colors.dart';
import '../../helpers/app_fonts.dart';
import '../../helpers/functions.dart';
import '../../helpers/notification_helpers.dart';
import '../../models/debt.dart';
import '../../providers/providers.dart';
import '../../providers/textfield_providers.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/snackbars.dart';

class UpdateDebtScreen extends ConsumerStatefulWidget {
  const UpdateDebtScreen({super.key});

  @override
  ConsumerState<UpdateDebtScreen> createState() => _UpdateDebtScreenState();
}

// Providers
final nameControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);
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
final phoneNumberControllerProvider =
    Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);
final emailControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);

class _UpdateDebtScreenState extends ConsumerState<UpdateDebtScreen> {
  @override
  void initState() {
    changeBottomBarColor(ref.read(isDarkModeProvider));
    fillData();
    super.initState();
  }

  late String currencies;

  void fillData() async {
    Debt debt = ref.read(debtNotifierProvider);

    ref.read(nameControllerProvider).text = debt.debtorName;
    ref.read(descriptionControllerProvider).text = debt.description;
    ref.read(priceControllerProvider).text = debt.amount;
    ref.read(paymentDateControllerProvider).text = debt.paymentDate;
    currencies = debt.currency;
    debt.phoneNumber != null
        ? ref.read(phoneNumberControllerProvider).text =
            debt.phoneNumber.toString()
        : null;
    debt.email != null
        ? ref.read(emailControllerProvider).text = debt.email.toString()
        : null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final transH = AppLocalizations.of(context)!;

    final nameController = ref.watch(nameControllerProvider);
    final descriptionController = ref.watch(descriptionControllerProvider);
    final priceController = ref.watch(priceControllerProvider);
    final paymentDateController = ref.watch(paymentDateControllerProvider);
    final phoneNumberController = ref.watch(phoneNumberControllerProvider);
    final emailController = ref.watch(emailControllerProvider);

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
          transH.editDebtRecord.toUpperCase(),
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
              SizedBox(height: height * .05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${transH.name.capitalizeAll()} *',
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
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkThemeColor
                            : AppColors.lightThemeColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'John Doe',
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
                ],
              ),
              SizedBox(height: height * .02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${transH.paymentDate.capitalizeAll()} *',
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
                          hintText: '${transH.descriptionText.capitalizeFirst.toString()}...',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    transH.phoneNumber.capitalizeAll(),
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
                    child: TextField(
                      controller: phoneNumberController,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkThemeColor
                            : AppColors.lightThemeColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '+234-801-234-5678',
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
                ],
              ),
              SizedBox(height: height * .02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    transH.email.capitalizeAll(),
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
                    child: TextField(
                      controller: emailController,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkThemeColor
                            : AppColors.lightThemeColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'example@gmail.com',
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
                    doneBtn(
                      width,
                      height,
                      transH,
                      nameController,
                      descriptionController,
                      priceController,
                      paymentDateController,
                      phoneNumberController,
                      emailController,
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
    TextEditingController nameController,
    TextEditingController descriptionController,
    TextEditingController priceController,
    TextEditingController paymentDateController,
    TextEditingController phoneNumberController,
    TextEditingController emailController,
  ) async {
    String debtorName = nameController.value.text;
    String paymentDate = paymentDateController.value.text;
    String price = priceController.value.text;
    String description = descriptionController.value.text;
    String phoneNumber = phoneNumberController.value.text;
    String emailAddress = emailController.value.text;

    if (debtorName.isEmpty ||
        paymentDate.isEmpty ||
        price.isEmpty ||
        description.isEmpty) {
      errorSnackBar(
        context: context,
        title: transH.error.capitalizeFirst.toString(),
        message: transH.fieldsRequired.capitalizeFirst.toString(),
      );
    } else if (emailAddress.isNotEmpty && !emailAddress.isEmail) {
      errorSnackBar(
        context: context,
        title: transH.error.capitalizeFirst.toString(),
        message: transH.inValidEmail.capitalizeFirst.toString(),
      );
    } else if (phoneNumber.isNotEmpty && !phoneNumber.isPhoneNumber) {
      AnimatedSnackBar.material(
        "${transH.error}, ${transH.inValidPhone}".capitalizeFirst.toString(),
        type: AnimatedSnackBarType.error,
      ).show(context);
    } else if (!price.isNumericOnly) {
      AnimatedSnackBar.material(
        "${transH.error}, ${transH.unkownError}".capitalizeFirst.toString(),
        type: AnimatedSnackBarType.error,
      ).show(context);
    } else {
      Debt debt = ref.read(debtNotifierProvider);
      String updatedDate =
          DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now());
      var data = await ref.read(debtControllerProvider.notifier).updateDebt(
            debt.id,
            debtorName,
            paymentDate,
            price,
            description,
            updatedDate,
            phoneNumber,
            emailAddress,
          );

      if (data['response'] == 'Validation error') {
        AnimatedSnackBar.material(
          "${transH.error}, ${transH.invalidCredentials}".capitalizeFirst.toString(),
          type: AnimatedSnackBarType.error,
        ).show(context);
      } else if (data['response'] == "Debt does not exists") {
        errorSnackBar(
          context: context,
          title: transH.error.capitalizeFirst.toString(),
          message: transH.unkownError.capitalizeFirst.toString(),
        );
      } else if (data['response'] == "user does not exist") {
        Navigator.pop(context);
        AnimatedSnackBar.material(
          "${transH.error}, ${transH.invalidUser}".capitalizeFirst.toString(),
          type: AnimatedSnackBarType.error,
        ).show(context);
      } else if (data['response'] == 'error') {
        errorSnackBar(
          context: context,
          title: transH.error.capitalizeFirst.toString(),
          message: transH.unkownError.capitalizeFirst.toString(),
        );
      } else if (data['error'] == 'network') {
        errorSnackBar(
          context: context,
          title: transH.error.capitalizeFirst.toString(),
          message: transH.network.capitalizeFirst.toString(),
        );
      } else if (data['response'] == "Debt Updated Successfully") {
        Debt debtRecord = Debt(
            id: debt.id,
            debtorName: debtorName,
            status: debt.status,
            currency: debt.currency,
            description: description,
            amount: price,
            paymentDate: paymentDate,
            createdDate: debt.createdDate,
            updatedDate: updatedDate,
            user: debt.user);
        ref.read(debtNotifierProvider.notifier).changeValues(debtRecord);
        LocalNotifications.showNotification(
            title: transH.success.capitalizeFirst.toString(),
            body: transH.debtUpdated.capitalizeFirst.toString(),
            payload: '');
        Navigator.pop(context);
        AnimatedSnackBar.material(
          "${transH.success}, ${transH.debtUpdated}".capitalizeFirst.toString(),
          type: AnimatedSnackBarType.success,
        ).show(context);
      } else {
        errorSnackBar(
          context: context,
          title: transH.error.capitalizeFirst.toString(),
          message: transH.unkownError.capitalizeFirst.toString(),
        );
      }
    }
    ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
  }
}
