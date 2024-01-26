// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../constants/app_contants.dart';
import '../../constants/app_routes.dart';
import '../../constants/colors.dart';
import '../../controllers/utl_controllers.dart';
import '../../helpers/app_fonts.dart';
import '../../helpers/functions.dart';
import '../../helpers/notification_helpers.dart';
import '../../providers/providers.dart';
import '../../providers/textfield_providers.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/snackbars.dart';

class CreateLiabilityScreen extends ConsumerStatefulWidget {
  const CreateLiabilityScreen({super.key});

  @override
  ConsumerState<CreateLiabilityScreen> createState() =>
      _CreateLiabilityScreenState();
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

// @override
// void dispose() {
//   context.read(nameControllerProvider).dispose();

//   super.dispose();
// }

class _CreateLiabilityScreenState extends ConsumerState<CreateLiabilityScreen> {
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
        centerTitle: true,
        title: Text(
          transH.createLiability.toUpperCase(),
          style: TextStyle(
            color: isDarkMode
                ? AppColors.darkThemeColor
                : AppColors.lightThemeColor,
            fontWeight: FontWeight.bold,
            fontSize: width * .01 + 16,
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
                        fontSize: width * .01 + 16,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'John Doe',
                        hintStyle: TextStyle(
                          color: isDarkMode
                              ? AppColors.darkThemeColor
                              : AppColors.lightThemeColor,
                          fontWeight: FontWeight.w400,
                          fontSize: width * .01 + 16,
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
                              fontSize: width * .01 + 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'YYYY-MM-DD',
                              hintStyle: TextStyle(
                                color: isDarkMode
                                    ? AppColors.darkThemeColor
                                    : AppColors.lightThemeColor,
                                fontWeight: FontWeight.w400,
                                fontSize: width * .01 + 16,
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
                            size: width * .01 + 16,
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
                          fontSize: width * .01 + 16,
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
                            fontSize: width * .01 + 16,
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
                  // CountryCodePicker(
                  //   onChanged: (CountryCode countryCode) {
                  //     //TODO : manipulate the selected country code here
                  //     print("New Country selected: $countryCode");
                  //   },
                  //   // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  //   initialSelection: 'IT',
                  //   favorite: const ['+234', 'NG'],
                  //   // optional. Shows only country name and flag
                  //   showCountryOnly: false,
                  //   // optional. Shows only country name and flag when popup is closed.
                  //   showOnlyCountryWhenClosed: false,
                  //   // optional. aligns the flag and the Text left
                  //   alignLeft: false,
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkThemeShade
                          : AppColors.lightThemeShade,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        TextField(
                          controller: phoneNumberController,
                          style: TextStyle(
                            color: isDarkMode
                                ? AppColors.darkThemeColor
                                : AppColors.lightThemeColor,
                            fontWeight: FontWeight.w700,
                            fontSize: width * .01 + 16,
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
                              fontSize: width * .01 + 16,
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
                        fontSize: width * .01 + 16,
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
                          fontSize: width * .01 + 16,
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
                  fontSize: width * .01 + 16,
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
      String currency) async {
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
      final utilityController = UtitlityController();

      if (await utilityController.isConnected()) {
        makeCreationOnline(transH, debtorName, paymentDate, price, description,
            currency, phoneNumber, emailAddress);
      } else {
        makeCreationOffline(transH, debtorName, paymentDate, price, description,
            currency, phoneNumber, emailAddress);
      }
    }
    ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
  }

  // Make creation offline
  void makeCreationOffline(
    AppLocalizations transH,
    String debtorName,
    String paymentDate,
    String price,
    String description,
    String currency,
    String phoneNumber,
    String emailAddress,
  ) async {
    var offlineUser = await Hive.openBox('offlineUser');
    var uuid = const Uuid().v1();
    var uid = await UtitlityController().getUid();
    // TODO: these date time variables need further modifications
    String createdDate = DateTime.now().toString();
    String updatedDate = DateTime.now().toString();

    // DateFormat('yyyy-MM-ddH:mm:ss').format(DateTime.now());
    Object liabilityData = {
      'id': uuid,
      'currency': currency,
      'email': emailAddress,
      'phone_number': phoneNumber,
      'creditor_name': debtorName,
      'description': description,
      'status': 'unpaid',
      'amount': price,
      'payment_date': paymentDate,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'edited': false,
      'offline_data': true,
      'user': uid
    };

    var createdLiabilities = offlineUser.get('created-liabilities-id');
    // This is to check if there was no existing offline
    if (createdLiabilities == null) {
      // This is to stores all the id's for created liabilities
      List data = [uuid];
      offlineUser.put('created-liabilities-id', data);
      // This is to store liability with unique id's
      offlineUser.put(uuid, liabilityData);
    } else {
      // now select all the existing debt id's
      List getCreatedLiabilities = offlineUser.get('created-liabilities-id');
      // with list of selected ID's fix in a new ID
      getCreatedLiabilities.add(uuid);
      // then update the ID's
      offlineUser.put('created-liabilities-id', getCreatedLiabilities);
      // This is to store liability with unique id's
      offlineUser.put(uuid, liabilityData);
    }

    AnimatedSnackBar.material(
      "${transH.success}, ${transH.liabilityAdded}".capitalizeFirst.toString(),
      type: AnimatedSnackBarType.success,
    ).show(context);
    LocalNotifications.showNotification(
      title: transH.success.capitalizeFirst.toString(),
      body: transH.liabilityAdded.capitalizeFirst.toString(),
      payload: '',
    );
    ref.read(currentIndexProvider.notifier).changeIndex(1);
    navigateReplacementNamed(context, AppRoutes.home);
  }

  // Make Creation online
  void makeCreationOnline(
    AppLocalizations transH,
    String debtorName,
    String paymentDate,
    String price,
    String description,
    String currency,
    String phoneNumber,
    String emailAddress,
  ) async {
    var data = await ref
        .read(liabilityControllerControllerProvider.notifier)
        .createDebt(
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
        "${transH.error}, ${transH.invalidCredentials}".capitalizeFirst.toString(),
        type: AnimatedSnackBarType.error,
      ).show(context);
    } else if (data['response'] == 'unexpected error') {
      AnimatedSnackBar.material(
        "${transH.error}, ${transH.unkownError}".capitalizeFirst.toString(),
        type: AnimatedSnackBarType.error,
      ).show(context);
    } else if (data['response'] == 'user does not exist') {
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
    } else if (data['response'] == "Liability Added Successfully") {
      AnimatedSnackBar.material(
        "${transH.success}, ${transH.liabilityAdded}".capitalizeFirst.toString(),
        type: AnimatedSnackBarType.success,
      ).show(context);
      LocalNotifications.showNotification(
        title: transH.success.capitalizeFirst.toString(),
        body: transH.liabilityAdded.capitalizeFirst.toString(),
        payload: '',
      );
      ref.read(currentIndexProvider.notifier).changeIndex(1);
      navigateReplacementNamed(context, AppRoutes.home);
    } else {
      AnimatedSnackBar.material(
        "${transH.error}, ${transH.unkownError}".capitalizeFirst.toString(),
        type: AnimatedSnackBarType.error,
      ).show(context);
    }
  }
}
