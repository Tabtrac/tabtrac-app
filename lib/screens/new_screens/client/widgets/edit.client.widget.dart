import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/helpers/functions.dart';

import '../../../../constants/colors.dart';
import '../../../../providers/providers.dart';
import '../controller/client.controller.dart';
import '../providers/provider.client.dart';
import '../../../../widgets/custom_btn.dart';
import '../../../../widgets/inputs.widgets.dart';

class EditClientWidget extends ConsumerStatefulWidget {
  final String clientId;
  final bool? isDataSaved;
  const EditClientWidget({super.key, this.isDataSaved, required this.clientId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditClientWidgetState();
}

class _EditClientWidgetState extends ConsumerState<EditClientWidget> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController location = TextEditingController();
  late ClientController clientController;

  @override
  void initState() {
    super.initState();

    name.text = ref.read(currentCleintDetailsProvider)!.name;
    email.text = ref.read(currentCleintDetailsProvider)!.email == null
        ? ''
        : ref.read(currentCleintDetailsProvider)!.email.toString();
    location.text = ref.read(currentCleintDetailsProvider)!.location == null
        ? ''
        : ref.read(currentCleintDetailsProvider)!.location.toString();
    phoneNumber.text =
        ref.read(currentCleintDetailsProvider)!.phoneNumber == null
            ? ''
            : ref.read(currentCleintDetailsProvider)!.phoneNumber.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      clientController = ClientController(ref: ref, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
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
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                    text: transH.edit.capitalizeAll(),
                    textColor: AppColors.whiteColor,
                    btnColor: AppColors.primaryColor,
                    fontSize: 16.sp,
                    actionBtn: true,
                    onPressed: () async {
                      if (!buttonLoading) {
                        ref
                            .read(buttonLoadingNotifierProvider.notifier)
                            .changeIndex(true);
                        bool data = await clientController.updateClient(
                          clientId: widget.clientId,
                          name: name.value.text,
                          email: email.value.text,
                          phoneNumber: phoneNumber.value.text,
                          location: location.value.text,
                        );
                        if (data) {
                          // ignore: use_build_context_synchronously
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
