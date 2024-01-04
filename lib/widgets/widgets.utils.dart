import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:fundz_app/models/record.model.dart';

import '../constants/colors.dart';
import '../helpers/app_fonts.dart';
import '../screens/new_screens/client/controller/client.controller.dart';
import '../screens/new_screens/client/providers/provider.client.dart';
import '../screens/new_screens/record/controller/record.controller.dart';
import '../screens/new_screens/record/providers/record.provider.dart';
import 'create.record.popup.dart';
import 'currency.dialog.widget.dart';
import '../screens/new_screens/client/widgets/edit.client.widget.dart';
import '../screens/new_screens/client/widgets/new.client.widget.dart';
import 'currency.pick.widget.dart';
import 'record.actions.dart';
import '../screens/new_screens/client/widgets/search.client.widget.dart';

class AppWidgetsUtlis {
  static void showBottomSheet(BuildContext context, {bool? saveData}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return NewClientWidget(
          isDataSaved: saveData,
        );
      },
    );
  }

  static void showEditClientBottomSheet(BuildContext context,
      {bool? saveData, required String clientId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EditClientWidget(
          isDataSaved: saveData,
          clientId: clientId,
        );
      },
    );
  }

  static void showRecordCreateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const CreateRecordPopUp();
      },
    );
  }

  static void searchClientList(BuildContext context, {bool? saveData}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return SearchClientWidget(
          isDataSaved: saveData,
        );
      },
    );
  }

  static void showCurrencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const CurrencyDialogWidget();
      },
    );
  }

  static void showRecordActionsDialog(BuildContext contextT, String type, WidgetRef ref) {
    showDialog(
      context: contextT,
      builder: (context) {
        return RecordActionsWidgets(
          type: type,
          mainContext: contextT,
          mainWidgetRef: ref,
        );
      },
    );
  }

  static Future<dynamic> deleteConfirmation(
    BuildContext context,
    AppLocalizations transH,
    ClientController clientController,
    WidgetRef ref,
    String? clientId,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "${transH.delete} ${transH.client} ${transH.record}".capitalize(),
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: AppFonts.actionFont,
              color: AppColors.primaryColor,
            ),
          ),
          content: FittedBox(
            child: Column(
              children: <Widget>[
                Text(
                  transH.clientDeleteConfirmation.capitalize(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: AppFonts.actionFont,
                  ),
                )
              ],
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(isDeletingProvider.notifier).change(true);
                clientController.deleteClient(clientId.toString());
              },
              child: Text(
                transH.delete.capitalizeFirst.toString(),
                style: TextStyle(
                  color: AppColors.dangerColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<dynamic> markAsPaidConfirmation(
    BuildContext context,
    AppLocalizations transH,
    RecordController recordController,
    WidgetRef ref,
    UserRecord record,
    String type,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            transH.notice.capitalize(),
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: AppFonts.actionFont,
              color: AppColors.primaryColor,
            ),
          ),
          content: FittedBox(
            child: Column(
              children: <Widget>[
                Text(
                  transH.markAsPaidConfirmation.capitalize(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: AppFonts.actionFont,
                  ),
                )
              ],
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
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                ref.read(isLoadingProvider.notifier).change(true);
                recordController.markRecordAsPaid(type, record);
              },
              child: Text(
                transH.paid.capitalizeFirst.toString(),
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<dynamic> deleteRecordConfirmation(
    BuildContext context,
    AppLocalizations transH,
    RecordController recordController,
    WidgetRef ref,
    UserRecord record,
    String type,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            transH.notice.capitalize(),
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: AppFonts.actionFont,
              color: AppColors.primaryColor,
            ),
          ),
          content: FittedBox(
            child: Column(
              children: <Widget>[
                Text(
                  transH.deleteConfirmation.capitalize(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: AppFonts.actionFont,
                  ),
                )
              ],
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
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                ref.read(isLoadingProvider.notifier).change(true);
                recordController.deleteRecord(type, record);
              },
              child: Text(
                transH.delete.capitalizeFirst.toString(),
                style: TextStyle(
                  color: AppColors.dangerColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void homeCurrencyPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const HomeCurrencyPicker();
      },
    );
  }
}
