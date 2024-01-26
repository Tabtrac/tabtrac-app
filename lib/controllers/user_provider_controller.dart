// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:fundz_app/helpers/notification_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/app_routes.dart';
import '../constants/urls.dart';
import '../widgets/snackbars.dart';
import 'token_controller.dart';
import 'utl_controllers.dart';

class UserController extends StateNotifier<AsyncValue> {
  UserController() : super(const AsyncValue.loading());

  final utilityController = UtitlityController();
  final tokenValidatorController = TokenValidatorController();

  Future getUserData() async {
    var box = await Hive.openBox('user');
    bool isConnected = await utilityController.isConnected();

    // Offline check
    if (!isConnected) {
      late Object output;
      var data = box.get('data');
      if (data == null) {
        output = jsonDecode(json.encode({'error': 'network'}));
      } else {
        output = jsonDecode(jsonEncode(data));
      }
      return output;
    }

    try {
      late Object output;
      final accessToken = await utilityController.getData('access_token');
      final response = await http.get(
        Uri.parse('$domainPortion/user/data/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );
      output = json.decode(response.body);
      if (response.statusCode == 401) {
        utilityController.writeData('needsLogOut', 'true');
        output = jsonDecode(json.encode({'error': 'true'}));
      } else {
        var user = await Hive.openBox('user');
        user.put('data', output);
        return output;
      }
    } catch (e) {
      late Object output;
      if (e.toString().contains('SocketException')) {
        output = jsonDecode(json.encode({'error': 'network'}));
      }
      output = jsonDecode(json.encode({'error': 'true'}));
      return output;
    }
  }

  Future<bool> changePassword(BuildContext context, String oldPassword,
      String newPassword, AppLocalizations transH) async {
    bool isConnected = await utilityController.isConnected();
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      errorSnackBar(
        context: context,
        title: transH.error.capitalizeFirst.toString(),
        message: transH.fieldsRequired.capitalizeFirst.toString(),
      );
      return true;
    } else if (oldPassword.length < 8 || newPassword.length < 8) {
      errorSnackBar(
        context: context,
        title: transH.error.capitalizeFirst.toString(),
        message: transH.pTooShort.capitalizeFirst.toString(),
      );
      return true;
    } else {
      // Offline check
      if (!isConnected) {
        errorSnackBar(
          context: context,
          title: transH.error.capitalizeFirst.toString(),
          message: transH.network.capitalizeFirst.toString(),
        );
        return true;
      } else {
        try {
          final accessToken = await utilityController.getData('access_token');
          final response = await http.patch(
              Uri.parse('$domainPortion/user/change-password/'),
              headers: {
                HttpHeaders.authorizationHeader: 'Bearer $accessToken',
              },
              body: {
                'old_password': oldPassword,
                'new_password': newPassword
              });
          int status = response.statusCode;
          if (status == 401) {
            utilityController.writeData('needsLogOut', 'true');
            errorSnackBar(
              context: context,
              title: transH.error.capitalizeFirst.toString(),
              message: transH.unkownError.capitalizeFirst.toString(),
            );
            navigateReplacementNamed(context, AppRoutes.splashRoute);
            return true;
          } else {
            switch (status) {
              case 200:
                successSnackBar(
                  context: context,
                  title: transH.success.capitalizeFirst.toString(),
                  message: transH.passwordChanged.capitalizeFirst.toString(),
                );
                LocalNotifications.showNotification(
                  title: transH.success.capitalizeFirst.toString(),
                  body: transH.passwordChanged.capitalizeFirst.toString(),
                  payload: '',
                );
                Navigator.of(context).pop();
              case 400:
                errorSnackBar(
                  context: context,
                  title: transH.error.capitalizeFirst.toString(),
                  message: transH.invalidPass.capitalizeFirst.toString(),
                );
              case 405:
                errorSnackBar(
                  context: context,
                  title: transH.error.capitalizeFirst.toString(),
                  message: transH.pTooCommon.capitalizeFirst.toString(),
                );
              case 409:
                errorSnackBar(
                  context: context,
                  title: transH.error.capitalizeFirst.toString(),
                  message: transH.incorrectPassword.capitalizeFirst.toString(),
                );
              default:
                errorSnackBar(
                  context: context,
                  title: transH.error.capitalizeFirst.toString(),
                  message: transH.unkownError.capitalizeFirst.toString(),
                );
            }
            return true;
          }
        } catch (e) {
          if (e.toString().contains('SocketException')) {
            errorSnackBar(
              context: context,
              title: transH.error.capitalizeFirst.toString(),
              message: transH.unkownError.capitalizeFirst.toString(),
            );
          }
          errorSnackBar(
            context: context,
            title: transH.error.capitalizeFirst.toString(),
            message: transH.network.capitalizeFirst.toString(),
          );
          return true;
        }
      }
    }
  }
}
