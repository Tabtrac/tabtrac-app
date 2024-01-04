import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../../constants/colors.dart';
import '../../../helpers/app_fonts.dart';
import '../../../providers/providers.dart';
import '../../../widgets/custom_btn.dart';
import '../../../widgets/snackbars.dart';
import '../../../widgets/widgets.utils.dart';
import '../record/providers/record.provider.dart';
import 'controllers/action.controller.dart';
import 'providers.dart';

class DepositeScreen extends ConsumerStatefulWidget {
  const DepositeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DepositeScreenState();
}

class _DepositeScreenState extends ConsumerState<DepositeScreen> {
  late ActionController actionController;
  pickDate() async {
    String currentLocale = getCurrentLocale(context).toString();
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
      //     regularDateFormat(
      //   DateTime.parse(formattedDate),
      //   currentLocale,
      //   removeTime: true,
      // );
    } else {}
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      actionController = ActionController(context: context, ref: ref);
      final currentRecord = ref.read(currentRecordProvider);
      if (currentRecord != null) {
        ref
            .read(currencyNotifierProvider.notifier)
            .changeSelectedIndex(currentRecord.currency);
        ref.read(descriptionControllerProvider).text =
            currentRecord.description;
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    var currentRoute = ModalRoute.of(context);
    String? type = currentRoute?.settings.arguments as String?;
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    final isDarkMode = ref.watch(isDarkModeProvider);
    final paymentDateController = ref.watch(paymentDateControllerProvider);
    final priceController = ref.watch(priceControllerProvider);
    final currencies = ref.watch(currencyNotifierProvider);
    final descriptionController = ref.watch(descriptionControllerProvider);
    final currentRecord = ref.watch(currentRecordProvider);
    final buttonLoadingNotifier = ref.watch(buttonLoadingNotifierProvider);
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
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryColor,
                  size: 24.sp,
                ),
              )
            : null,
        centerTitle: true,
        title: Text(
          type == 'debt'
              ? "${transH.deposite} ${transH.debt}".capitalizeAll()
              : "${transH.deposite} ${transH.credit}".capitalizeAll(),
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          width: width,
          height: height * .89,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.h),
                  Text(
                    transH.nextPaymentDate.capitalize(),
                    style: TextStyle(
                      fontFamily: AppFonts.actionFont,
                      fontSize: 14.sp,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .color!
                          .withOpacity(.7),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkThemeShade
                          : AppColors.lightThemeShade,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.greyColor.withOpacity(.2),
                          width: .7),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
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
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: transH.paymentDate.capitalize(),
                              hintStyle: TextStyle(
                                color: isDarkMode
                                    ? AppColors.darkThemeColor
                                    : AppColors.lightThemeColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
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
                            size: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    transH.currentAmount.capitalize(),
                    style: TextStyle(
                      fontFamily: AppFonts.actionFont,
                      fontSize: 14.sp,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .color!
                          .withOpacity(.7),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkThemeShade
                          : AppColors.lightThemeShade,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.greyColor.withOpacity(.2),
                          width: .7),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Text(
                      moneyComma(currentRecord!.amount, currentRecord.currency),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    transH.amountDeposited.capitalize(),
                    style: TextStyle(
                      fontFamily: AppFonts.actionFont,
                      fontSize: 14.sp,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .color!
                          .withOpacity(.7),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkThemeShade
                          : AppColors.lightThemeShade,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.greyColor.withOpacity(.2),
                          width: .7),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            returnCurrency(currencies),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: TextField(
                              controller: priceController,
                              style: TextStyle(
                                color: isDarkMode
                                    ? AppColors.darkThemeColor
                                    : AppColors.lightThemeColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: transH.amount.capitalize(),
                                hintStyle: TextStyle(
                                  color: isDarkMode
                                      ? AppColors.darkThemeColor
                                      : AppColors.lightThemeColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    transH.description.capitalize(),
                    style: TextStyle(
                      fontFamily: AppFonts.actionFont,
                      fontSize: 14.sp,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .color!
                          .withOpacity(.7),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkThemeShade
                          : AppColors.lightThemeShade,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.greyColor.withOpacity(.2),
                          width: .7),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: descriptionController,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkThemeColor
                            : AppColors.lightThemeColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
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
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              CustomBtn(
                text: transH.deposite.capitalize(),
                textColor: AppColors.whiteColor,
                btnColor: AppColors.primaryColor,
                fontSize: 16.sp,
                actionBtn: true,
                borderRadius: BorderRadius.circular(10.0),
                onPressed: () async {
                  if (paymentDateController.value.text.isNotEmpty &&
                      priceController.value.text.isNotEmpty &&
                      descriptionController.value.text.isNotEmpty) {
                    if (!buttonLoadingNotifier) {
                      ref
                          .read(buttonLoadingNotifierProvider.notifier)
                          .changeIndex(true);

                      bool response = await actionController.depositeRecord(
                        description: descriptionController.value.text,
                        amount: priceController.value.text,
                        currency: currencies,
                        paymentDate: paymentDateController.value.text,
                        type: type.toString(),
                        recordId: currentRecord.id.toString(),
                      );
                      if (response) {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    }
                  } else {
                    errorSnackBar(
                      title: transH.error.capitalize(),
                      message: transH.fieldsRequired.capitalize(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
