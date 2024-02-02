import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/helpers/functions.dart';

import '../constants/app_routes.dart';
import '../constants/colors.dart';
import '../providers/providers.dart';
import '../screens/new_screens/actions/providers/actions.provider.dart';

class CreateRecordPopUp extends ConsumerStatefulWidget {
  const CreateRecordPopUp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateRecordPopUpState();
}

class _CreateRecordPopUpState extends ConsumerState<CreateRecordPopUp> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    return FittedBox(
      child: Container(
        width: width,
        constraints: BoxConstraints(
          minHeight: 165.h,
          maxHeight: 165.h,
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
                  InkWell(
                    onTap: () {
                      ref
                          .read(craeteScreenTypeNotifierProvider.notifier)
                          .change('debt');
                      ref.read(currentPageProvider.notifier).changePage(0);

                      ref.read(selectedClient.notifier).change(null);
                      Navigator.pop(context);
                      navigateNamed(context, AppRoutes.createNewRecord);
                    },
                    child: ListTile(
                      leading: Text(
                        transH.debt.capitalizeFirst.toString(),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontSize: isTablet() ? 10.sp : 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () {
                      ref
                          .read(craeteScreenTypeNotifierProvider.notifier)
                          .change('credit');

                      ref.read(selectedClient.notifier).change(null);
                      ref.read(currentPageProvider.notifier).changePage(0);
                      Navigator.pop(context);
                      navigateNamed(context, AppRoutes.createNewRecord);
                    },
                    child: ListTile(
                      leading: Text(
                        transH.credit.capitalizeFirst.toString(),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontSize: isTablet() ? 10.sp : 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
