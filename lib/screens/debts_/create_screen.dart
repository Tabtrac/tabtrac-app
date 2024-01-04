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

import '../../constants/app_contants.dart';
import '../../constants/app_routes.dart';
import '../../constants/colors.dart';
import '../../helpers/app_fonts.dart';
import '../../helpers/functions.dart';
import '../../helpers/app_extensions.dart';
import '../../helpers/notification_helpers.dart';
import '../../providers/providers.dart';
import '../../providers/textfield_providers.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/snackbars.dart';

class CreateDebtScreen extends ConsumerStatefulWidget {
  const CreateDebtScreen({super.key});

  @override
  ConsumerState<CreateDebtScreen> createState() => _CreateDebtScreenState();
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
// final paymentDateControllerProvider =
//     StateNotifierProvider.autoDispose<TextEditingController, TextEditingController>(
//   (ref) {
//     final controller = TextEditingController();
//     ref.onDispose(() {
//       controller.dispose();
//     });
//     return controller;
//   },
// );

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

class _CreateDebtScreenState extends ConsumerState<CreateDebtScreen> {
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

    final nameController = ref.watch(nameControllerProvider);
    final descriptionController = ref.watch(descriptionControllerProvider);
    final priceController = ref.watch(priceControllerProvider);
    final paymentDateController = ref.watch(paymentDateControllerProvider);
    final phoneNumberController = ref.watch(phoneNumberControllerProvider);
    final emailController = ref.watch(emailControllerProvider);

    final isDarkMode = ref.watch(isDarkModeProvider);

    final currencies = ref.watch(currencyNotifierProvider);

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
        leadingWidth: width * .1,
        centerTitle: true,
        title: Text(
          transH.createNewDept.toUpperCase(),
          style: TextStyle(
            color: isDarkMode
                ? AppColors.darkThemeColor
                : AppColors.lightThemeColor,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
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
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                double nWidth =
                                    MediaQuery.of(context).size.width;
                                return AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  title: Text(
                                    transH.selectCurrency.capitalizeFirst
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: AppFonts.actionFont,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                    ),
                                  ),
                                  content: SizedBox(
                                    width: nWidth,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dropdownItems.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            "${returnCurrency(dropdownItems[index].name)} (${dropdownItems[index].name.toUpperCase()})",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .color,
                                            ),
                                          ),
                                          leading: Radio(
                                            value: dropdownItems[index].name,
                                            groupValue: currencies,
                                            onChanged: (value) {
                                              ref
                                                  .read(currencyNotifierProvider
                                                      .notifier)
                                                  .changeSelectedIndex(value!);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        transH.cancel.capitalizeFirst
                                            .toString(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color,
                                          fontSize: width * .01 + 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Text(
                                  returnCurrency(currencies),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                ),
                              ],
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
                        currencies);
                  },
                  width: width * .65,
                  btnColor: AppColors.primaryColor,
                  fontSize: 18.sp,
                  text: transH.create,
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
    String currency,
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
        title: transH.error.capitalize(),
        message: transH.fieldsRequired.capitalize(),
      );
    } else if (emailAddress.isNotEmpty && !emailAddress.isEmail) {
      errorSnackBar(
        context: context,
        title: transH.error.capitalize(),
        message: transH.inValidEmail.capitalize(),
      );
    } else if (phoneNumber.isNotEmpty && !phoneNumber.isPhoneNumber) {
      AnimatedSnackBar.material(
        "${transH.error}, ${transH.inValidPhone}".capitalize(),
        type: AnimatedSnackBarType.error,
      ).show(context);
    } else if (!price.isNumericOnly) {
      // TODO: there need to be a validation on price vairiable
      AnimatedSnackBar.material(
        "${transH.error}, ${transH.unkownError}".capitalize(),
        type: AnimatedSnackBarType.error,
      ).show(context);
    } else {
      var data = await ref.read(debtControllerProvider.notifier).createDebt(
            debtorName,
            paymentDate,
            price,
            description,
            currency,
            phoneNumber,
            emailAddress,
          );

      if (data['response'] == 'Validation error') {
        AnimatedSnackBar.material(
          "${transH.error}, ${transH.invalidCredentials}".capitalize(),
          type: AnimatedSnackBarType.error,
        ).show(context);
      } else if (data['response'] == 'unexpected error') {
        errorSnackBar(
          context: context,
          title: transH.error.capitalize(),
          message: transH.unkownError.capitalize(),
        );
      } else if (data['response'] == 'user does not exist') {
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
      } else if (data['response'] == "Debt Added Successfully") {
        AnimatedSnackBar.material(
          "${transH.success}, ${transH.debtAdded}".capitalize(),
          type: AnimatedSnackBarType.success,
        ).show(context);
        LocalNotifications.showNotification(
            title: transH.success.capitalize(),
            body: transH.debtAdded.capitalize(),
            payload: '');
        ref.read(currentIndexProvider.notifier).changeIndex(0);
        navigateReplacementNamed(context, AppRoutes.home);
      } else {
        errorSnackBar(
          context: context,
          title: transH.error.capitalize(),
          message: transH.unkownError.capitalize(),
        );
      }
    }
    ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
  }
}
