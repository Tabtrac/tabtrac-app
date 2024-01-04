// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_routes.dart';
import '../../../../constants/urls.dart';
import '../../../../controllers/utl_controllers.dart';
import '../../../../helpers/notification_helpers.dart';
import '../../../../models/record.model.dart';
import '../../../../providers/providers.dart';
import '../../../../widgets/snackbars.dart';
import '../../client/models/client.model.dart';
import '../../record/controller/record.controller.dart';
import '../../record/providers/record.provider.dart';

class ActionController {
  final WidgetRef ref;
  final BuildContext context;

  ActionController({required this.ref, required this.context});
  UtitlityController utitlityController = UtitlityController();

  Future<bool> createRecord({
    required Client client,
    required String description,
    required String amount,
    required String currency,
    required String paymentDate,
    required String type,
  }) async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;

      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');
        String date = DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now());
        final response = await http.post(
          Uri.parse('$domainPortion/api/record/$type/'),
          body: {
            "client": client.id.toString(),
            "description": description,
            "amount": amount,
            "currency": currency,
            "payment_date": paymentDate,
            "created_date": date,
            "updated_date": date
          },
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        );

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
          ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
          return true;
        } else if (statusCode == 201) {
          final recordController = RecordController(ref: ref, context: context);
          await recordController.onLoadData();
          ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);

          LocalNotifications.showNotification(
              title: transH.success.capitalize(),
              body: transH.recordAdded.capitalize(),
              payload: '');
          return true;
        } else {
          errorSnackBar(
              title: transH.error.capitalize(),
              message: transH.unkownError.capitalize());
          ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
          return false;
        }
      } catch (e) {
        if (e.toString().contains('SocketException')) {
          errorSnackBar(
              title: transH.error.capitalize(),
              message: transH.network.capitalize());
        }
        errorSnackBar(
            context: context,
            title: transH.error.capitalize(),
            message: transH.unkownError.capitalize());

        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> depositeRecord({
    required String description,
    required String amount,
    required String currency,
    required String paymentDate,
    required String type,
    required String recordId,
  }) async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;
      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');
        String date = DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now());
        final response = await http.put(
          Uri.parse('$domainPortion/api/record/$type/$recordId/'),
          body: {
            "description": description,
            "amount": amount,
            "currency": currency,
            "payment_date": paymentDate,
            "deposited_date": date
          },
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        );

        var statusCode = response.statusCode;
        var responseData = json.decode(response.body);
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
          ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
          return true;
        } else if (statusCode == 201) {
          ref
              .read(currentRecordProvider.notifier)
              .change(UserRecord.fromJson(responseData['record']));
          final recordController = RecordController(ref: ref, context: context);
          await recordController.onLoadData();
          ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
          successSnackBar(
            title: transH.success.capitalize(),
            message: transH.depositSuccess.capitalize(),
          );
          return true;
        } else {
          errorSnackBar(
              title: transH.error.capitalize(),
              message: transH.unkownError.capitalize());
          ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
          return false;
        }
      } catch (e) {
        if (e.toString().contains('SocketException')) {
          errorSnackBar(
              title: transH.error.capitalize(),
              message: transH.network.capitalize());
        }
        errorSnackBar(
            context: context,
            title: transH.error.capitalize(),
            message: transH.unkownError.capitalize());

        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
        return false;
      }
    }else{
      return false;
    }
  }
}
