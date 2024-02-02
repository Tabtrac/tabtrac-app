// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/helpers/functions.dart';

import '../../../../constants/colors.dart';
import '../../../../providers/providers.dart';
import '../../../../widgets/custom_btn.dart';
import '../../../../widgets/inputs.widgets.dart';
import '../controller/client.controller.dart';

class NewClientWidget extends ConsumerStatefulWidget {
  final bool? isDataSaved;
  const NewClientWidget({super.key, this.isDataSaved});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewClientWidgetState();
}

class _NewClientWidgetState extends ConsumerState<NewClientWidget> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController location = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    phoneNumber.dispose();
    email.dispose();
    location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    ClientController clientController =
        ClientController(ref: ref, context: context);
    final buttonLoading = ref.watch(buttonLoadingNotifierProvider);
    return FittedBox(
      child: Container(
        width: width,
        constraints: BoxConstraints(
          minHeight: 350.h,
          maxHeight: keyboardHeight > 0 ? 350.h + (keyboardHeight) : 350.h,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 5.h),
            Container(
              width: 60.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(.6),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: isTablet() ? 30.w : 15.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FormInput(
                    width,
                    controller: name,
                    hintText: transH.clientName.capitalizeAll(),
                    isLast: false,
                    isPassword: false,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SizedBox(height: 10.h),
                  FormInput(
                    width,
                    controller: location,
                    hintText: transH.clientLocation.capitalizeAll(),
                    isLast: false,
                    isPassword: false,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SizedBox(height: 10.h),
                  FormInput(
                    width,
                    controller: email,
                    hintText: transH.clientEmail.capitalizeAll(),
                    isLast: false,
                    isPassword: false,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SizedBox(height: 10.h),
                  FormInput(
                    width,
                    controller: phoneNumber,
                    hintText: transH.clientPhonenumber.capitalizeAll(),
                    isLast: true,
                    isPassword: false,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SizedBox(height: 10.h),
                  CustomBtn(
                    text: transH.addNewClient.capitalizeAll(),
                    textColor: AppColors.whiteColor,
                    btnColor: AppColors.primaryColor,
                    fontSize: isTablet() ? 10.sp : 16.sp,
                    actionBtn: true,
                    onPressed: () async {
                      ref
                          .read(buttonLoadingNotifierProvider.notifier)
                          .changeIndex(true);
                      if (!buttonLoading) {
                        bool data = await clientController.createClient(
                          name: name.value.text,
                          email: email.value.text,
                          location: location.value.text,
                          phoneNumber: phoneNumber.value.text,
                          saveData: widget.isDataSaved,
                        );
                        if (data) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
