import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../constants/colors.dart';
import '../../../../helpers/app_fonts.dart';
import '../../../../providers/providers.dart';
import '../../../../widgets/widgets.utils.dart';
import '../providers.dart';
import '../providers/actions.provider.dart';

class SecondFormCreate extends ConsumerStatefulWidget {
  const SecondFormCreate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SecondFormCreateState();
}

class _SecondFormCreateState extends ConsumerState<SecondFormCreate> {
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
      ref.read(paymentDateProvider.notifier).change(formattedDate);
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
  Widget build(BuildContext context) {
    final priceController = ref.watch(priceControllerProvider);
    final paymentDateController = ref.watch(paymentDateControllerProvider);
    final transH = AppLocalizations.of(context)!;
    final isDarkMode = ref.watch(isDarkModeProvider);
    final currencies = ref.watch(currencyNotifierProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          transH.recordInfo.capitalizeAll(),
          style: TextStyle(
              fontFamily: AppFonts.actionFont,
              color: AppColors.primaryColor,
              fontSize: 16.sp),
        ),
        SizedBox(height: 5.h),
        Container(
          height: 1.5.h,
          decoration: BoxDecoration(
            color: AppColors.greyColor.withOpacity(.2),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          transH.paymentDate.capitalize(),
          style: TextStyle(
            fontFamily: AppFonts.actionFont,
            fontSize: 14.sp,
            color:
                Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.7),
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
                color: AppColors.greyColor.withOpacity(.2), width: .7),
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
          transH.price.capitalize(),
          style: TextStyle(
            fontFamily: AppFonts.actionFont,
            fontSize: 14.sp,
            color:
                Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.7),
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
                color: AppColors.greyColor.withOpacity(.2), width: .7),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  AppWidgetsUtlis.showCurrencyDialog(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Text(
                        returnCurrency(currencies),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
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
            ],
          ),
        ),
      ],
    );
  }
}
