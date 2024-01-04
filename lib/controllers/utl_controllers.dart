// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/urls.dart';
import '../helpers/functions.dart';
import '../helpers/notification_helpers.dart';
import '../models/debt.dart';

class UtitlityController {
  final _secureStorage = const FlutterSecureStorage();
  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  Future<void> setTheme(String mode) async {
    await _secureStorage.write(
      key: "theme",
      value: mode,
      aOptions: _getAndroidOptions(),
    );
  }

  List<Debt> parseDebts(String responseBody) {
    final parsed =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed.map<Debt>((json) => Debt.fromJson(json)).toList();
  }

  writeData(String key, String value) async {
    await _secureStorage.write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
    );
  }

  deleteData(String key) async {
    await _secureStorage.delete(
      key: key,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<String?> getData(
    String key,
  ) async {
    var data = await _secureStorage.read(
      key: key,
      aOptions: _getAndroidOptions(),
    );
    return data.toString();
  }

  Future<String?> getUid() async {
    return await _secureStorage.read(
        key: 'uid', aOptions: _getAndroidOptions());
  }

  Future<bool> isConnected() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }

  Future<void> getBackgroundSync() async {
    var debts = await Hive.openBox('debts');
    var liabilities = await Hive.openBox('liabilities');

    try {
      final accessToken = await getData('access_token');
      final response = await http.get(
        Uri.parse('$domainPortion/user/offline-data/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );

      var statusCode = response.statusCode;
      if (statusCode == 401) {
        writeData('needsLogOut', 'true');
      } else {
        var data = json.decode(response.body)['data'];
        var debtsData = data['debts'];
        var liabilitiesData = data['liabilities'];

        // Handling background sync for debts
        debts.put('allDebts', debtsData['all']);
        debts.put('dueDebts', debtsData['due']);
        debts.put('pendingDebts', debtsData['pending']);
        debts.put('paidDebts', debtsData['paid']);

        // Handling background sync for liabilities
        liabilities.put('allLiabilities', liabilitiesData['all']);
        liabilities.put('dueLiabilities', liabilitiesData['due']);
        liabilities.put('pendingLiabilities', liabilitiesData['pending']);
        liabilities.put('paidLiabilities', liabilitiesData['paid']);
      }
      // Code Area End
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> loadNotifications(BuildContext context, WidgetRef ref) async {
    final transH = AppLocalizations.of(context)!;
    String currentLocale = getCurrentLocale(context).toString();
    try {
      final accessToken = await getData('access_token');
      final response = await http.get(
        Uri.parse('$domainPortion/api/record/notifications/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );

      var statusCode = response.statusCode;
      if (statusCode == 401) {
      } else if (statusCode == 200) {
        var data = json.decode(response.body);
        if (data['response'] == 'OK') {
          if (data['type'] == 'pending') {
            var creditRecords = data['data']['credit'];
            creditRecords.forEach((value) async {
              int id = randomInRange(0, 4);
              await LocalNotifications.showNotification(
                id: id,
                title:
                    "${transH.youOwe.capitalize()} ${value['client_name'].toString().capitalizeAll()} ${moneyComma(value['amount'], value['currency'])}",
                body:
                    '${transH.toBePaidBefore.capitalize()} ${regularDateFormat(DateTime.parse(value['payment_date']), currentLocale)}',
                payload: value['id'].toString(),
              );
            });
            var debtRecords = data['data']['debt'];
            debtRecords.forEach((value) async {
              int id = randomInRange(0, 5);
              await LocalNotifications.showNotification(
                id: id,
                title:
                    "${value['client_name'].toString().capitalizeAll()} ${transH.owesYou}  ${moneyComma(value['amount'], value['currency'])}",
                body:
                    '${transH.toBePaidBefore.capitalize()} ${regularDateFormat(DateTime.parse(value['payment_date']), currentLocale)}',
                payload: value['id'].toString(),
              );
            });
          } else {
            var creditRecords = data['data']['credit'];
            creditRecords.forEach((value) async {
              int id = randomInRange(0, 7);
              await LocalNotifications.showNotification(
                id: id,
                title:
                    "${transH.youOwe.capitalize()} ${value['client_name'].toString().capitalizeAll()} ${moneyComma(value['amount'], value['currency'])}",
                body:
                    '${transH.toBePaidBefore.capitalize()} ${regularDateFormat(DateTime.parse(value['payment_date']), currentLocale)}',
                payload: value['id'].toString(),
              );
            });
            var debtRecords = data['data']['debt'];
            debtRecords.forEach((value) async {
              int id = randomInRange(0, 9);
              await LocalNotifications.showNotification(
                id: id,
                title:
                    "${value['client_name'].toString().capitalizeAll()} ${transH.owesYou}  ${moneyComma(value['amount'], value['currency'])}",
                body:
                    '${transH.toBePaidBefore.capitalize()} ${regularDateFormat(DateTime.parse(value['payment_date']), currentLocale)}',
                payload: value['id'].toString(),
              );
            });
          }
        }
      } else {
        // pass
      }
      // Code Area End
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
