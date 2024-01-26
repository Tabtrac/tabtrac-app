import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/constants/colors.dart';

import '../constants/app_routes.dart';
import '../helpers/app_fonts.dart';
import '../helpers/functions.dart';
import '../screens/new_screens/record/controller/record.controller.dart';
import '../screens/new_screens/record/providers/record.provider.dart';
import 'widgets.utils.dart';

class RecordActionsWidgets extends ConsumerWidget {
  final String type;
  final BuildContext mainContext;
  final WidgetRef mainWidgetRef;
  const RecordActionsWidgets({super.key, required this.type, required this.mainContext, required this.mainWidgetRef});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transH = AppLocalizations.of(context)!;
    double nWidth = MediaQuery.of(context).size.width;
    final currentRecord = ref.watch(currentRecordProvider);
    RecordController recordController = RecordController(ref: ref, context: context);
    String status = currentRecord!.status;
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        transH.actions.capitalizeFirst.toString(),
        style: TextStyle(
          fontSize: 20.sp,
          fontFamily: AppFonts.actionFont,
          color: AppColors.primaryColor,
        ),
      ),
      content: FittedBox(
        child: SizedBox(
          width: nWidth,
          child: Column(
            children: <Widget>[
              // if (status == 'unpaid')
              //   ListTile(
              //     onTap: () {},
              //     leading: Text(
              //       transH.edit.capitalizeFirst.toString(),
              //       style: TextStyle(
              //         fontSize: 20.sp,
              //         color: Theme.of(context).textTheme.bodyMedium!.color,
              //       ),
              //     ),
              //   ),
              if (status == 'unpaid')
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    navigateNamed(
                        context, AppRoutes.recordDepositeRoutes, type);
                  },
                  leading: Text(
                    transH.deposite.capitalizeFirst.toString(),
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ),
              if (status == 'unpaid')
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    AppWidgetsUtlis.markAsPaidConfirmation(context, transH, recordController, mainWidgetRef, currentRecord, type);
                    
                  },
                  leading: Text(
                    transH.paid.capitalizeFirst.toString(),
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ),
              ListTile(
                onTap: () {},
                leading: Text(
                  transH.delete.capitalizeFirst.toString(),
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ),
            ],
          ),
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
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
