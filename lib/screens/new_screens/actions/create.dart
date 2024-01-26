import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../constants/colors.dart';
import '../../../helpers/app_fonts.dart';
import '../../../providers/providers.dart';
import '../../../widgets/custom_btn.dart';
import 'providers.dart';
import 'providers/actions.provider.dart';
import 'widgets/firstform.create.dart';
import 'widgets/secondform.create.dart';
import 'widgets/thirdform.create.dart';

class CreateScreen extends ConsumerStatefulWidget {
  const CreateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen> {
  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    final type = ref.watch(craeteScreenTypeNotifierProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final currentStage = ref.watch(currentStageProvider);
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;

    final nameController = ref.watch(nameControllerProvider);
    final descriptionController = ref.watch(descriptionControllerProvider);
    final priceController = ref.watch(priceControllerProvider);
    final paymentDateController = ref.watch(paymentDateControllerProvider);
    final phoneNumberController = ref.watch(phoneNumberControllerProvider);
    final emailController = ref.watch(emailControllerProvider);
    final client = ref.watch(selectedClient);
    final currency = ref.watch(currencyNotifierProvider);
    final currentPage = ref.watch(craeteScreenTypeNotifierProvider);
    return WillPopScope(
      onWillPop: () async {
        ref.read(currentPageProvider.notifier).changePage(0);
        return true;
      },
      child: Scaffold(
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
                ? "${transH.create} ${transH.debt}".capitalizeAll()
                : "${transH.create} ${transH.credit}".capitalizeAll(),
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              fontFamily: AppFonts.actionFont,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: width,
          height: height * .9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StepProgressIndicator(
                    totalSteps: 3,
                    currentStep: currentStage,
                    selectedColor: AppColors.primaryColorLight,
                    unselectedColor: isDarkMode
                        ? AppColors.darkThemeShade
                        : AppColors.lightThemeShade,
                  ),
                  SizedBox(height: 30.h),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (currentStage == 1)
                          const FirstFormCreate().animate().fade(delay: 500.ms),
                        if (currentStage == 2)
                          const SecondFormCreate()
                              .animate()
                              .fade(delay: 500.ms),
                        if (currentStage == 3)
                          const ThirdFormCreate().animate().fade(delay: 500.ms),
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  currentStage > 1
                      ? CustomBtn(
                          text: transH.back.capitalizeFirst.toString(),
                          textColor: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .color!
                              .withOpacity(.7),
                          btnColor: isDarkMode
                              ? AppColors.darkThemeShade
                              : AppColors.lightThemeShade,
                          fontSize: 16.sp,
                          borderRadius: BorderRadius.circular(10.0),
                          onPressed: () {
                            ref.read(currentStageProvider.notifier).removeStage(
                                  context,
                                  transH,
                                  currentStage,
                                  name: nameController.value.text,
                                  description: descriptionController.value.text,
                                  amounth: priceController.value.text,
                                  currency: currency,
                                  email: emailController.value.text,
                                  paymentDate: paymentDateController.value.text,
                                  phoneNumber: phoneNumberController.value.text,
                                );
                          },
                        ).animate().fade()
                      : const SizedBox(),
                  SizedBox(height: 10.h),
                  CustomBtn(
                    text: currentStage >= 3
                        ? transH.create.capitalizeFirst.toString()
                        : transH.next.capitalizeFirst.toString(),
                    textColor: AppColors.whiteColor,
                    btnColor: AppColors.primaryColor,
                    fontSize: 16.sp,
                    actionBtn: true,
                    borderRadius: BorderRadius.circular(10.0),
                    onPressed: () {
                      ref.read(currentStageProvider.notifier).addStage(
                          context, transH, ref, currentStage,
                          client: client,
                          name: nameController.value.text,
                          description: descriptionController.value.text,
                          amounth: priceController.value.text,
                          currency: currency,
                          email: emailController.value.text,
                          paymentDate: paymentDateController.value.text,
                          phoneNumber: phoneNumberController.value.text,
                          currentPage: currentPage);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
