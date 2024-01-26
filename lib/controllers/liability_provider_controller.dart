// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/models/liability.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants/app_routes.dart';
import '../constants/urls.dart';
import '../helpers/functions.dart';
import '../helpers/notification_helpers.dart';
import '../widgets/snackbars.dart';
import 'token_controller.dart';
import 'utl_controllers.dart';

class LiabilityController extends StateNotifier<AsyncValue> {
  LiabilityController() : super(const AsyncValue.loading());

  final _secureStorage = const FlutterSecureStorage();
  final utilityController = UtitlityController();
  final tokenValidatorController = TokenValidatorController();

  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);
  Future<String?> getData(
    String key,
  ) async {
    var data = await _secureStorage.read(
      key: key,
      aOptions: _getAndroidOptions(),
    );
    return data.toString();
  }

  Future createDebt(
      String name,
      String paymentDate,
      String price,
      String description,
      String currency,
      String? phoneNumber,
      String? email) async {
    try {
      // Code Area
      final accessToken = await getData('access_token');
      String createdDate =
          DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now());
      String updatedDate =
          DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now());
      final response = await http.post(
        Uri.parse('$domainPortion/liability/actions/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
        body: {
          'email': email,
          'phone_number': phoneNumber,
          'creditor_name': name,
          'description': description,
          'amount': price,
          'payment_date': paymentDate,
          'created_date': createdDate,
          'updated_date': updatedDate,
          'currency': currency
        },
      );
      var responseData = json.decode(response.body);

      var statusCode = response.statusCode;
      if (statusCode == 401) {
        utilityController.writeData('needsLogOut', 'true');
        return jsonDecode(json.encode({'error': 'true'}));
      } else {
        utilityController.getBackgroundSync();
        return responseData;
      }
      // Code Area End
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'error': 'network'}));
      }
      return jsonDecode(json.encode({'error': 'true'}));
    }
  }

  Future updateLiability(
      String id,
      String name,
      String paymentDate,
      String price,
      String description,
      String currency,
      String updatedDate,
      String? phoneNumber,
      String? email) async {
    try {
      // Code Area
      final accessToken = await getData('access_token');
      String createdDate =
          DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now());
      final response = await http.put(
        Uri.parse('$domainPortion/liability/action/$id/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
        body: {
          'email': email,
          'phone_number': phoneNumber,
          'creditor_name': name,
          'description': description,
          'amount': price,
          'payment_date': paymentDate,
          'created_date': createdDate,
          'updated_date': updatedDate,
          'currency': currency
        },
      );
      var responseData = json.decode(response.body);

      var statusCode = response.statusCode;
      if (statusCode == 401) {
        utilityController.writeData('needsLogOut', 'true');
        return jsonDecode(json.encode({'error': 'true', 'count': null}));
      } else {
        utilityController.getBackgroundSync();
        return responseData;
      }
      // Code Area End
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'error': 'network', 'count': null}));
      }
      return jsonDecode(json.encode({'error': 'true', 'count': null}));
    }
  }

  Future depositedOnLiability(String id, String paymentDate, String price,
      String description, String depositedDate) async {
    try {
      // Code Area
      final accessToken = await getData('access_token');
      final response = await http.patch(
        Uri.parse('$domainPortion/liability/action/$id/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
        body: {
          'description': description,
          'new_amount': price,
          'next_payment_date': paymentDate,
          'deposited_date': depositedDate,
        },
      );
      var responseData = json.decode(response.body);

      var statusCode = response.statusCode;
      if (statusCode == 401) {
        utilityController.writeData('needsLogOut', 'true');
        return jsonDecode(json.encode({'error': 'true', 'count': null}));
      } else {
        utilityController.getBackgroundSync();
        return responseData;
      }
      // Code Area End
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'error': 'network', 'count': null}));
      }
      return jsonDecode(json.encode({'error': 'true', 'count': null}));
    }
  }

  Future markAsPaid(String id, String datePaid) async {
    try {
      // Code Area
      final accessToken = await getData('access_token');
      final response = await http.patch(
        Uri.parse('$domainPortion/user/record-cleared/$id/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
        body: {'date_paid': datePaid, 'type': 'liabilities'},
      );
      var responseData = json.decode(response.body);

      var statusCode = response.statusCode;
      if (statusCode == 401) {
        utilityController.writeData('needsLogOut', 'true');
        return jsonDecode(json.encode({'error': 'true', 'count': null}));
      } else {
        utilityController.getBackgroundSync();
        return responseData;
      }
      // Code Area End
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'error': 'network', 'count': null}));
      }
      return jsonDecode(json.encode({'error': 'true', 'count': null}));
    }
  }

  Future getAllLiabilities() async {
    var box = await Hive.openBox('liabilities');
    var offlineUser = await Hive.openBox('offlineUser');
    bool isConnected = await utilityController.isConnected();

    // offlineUser.delete('created-liabilities-id');
    // Offline check
    if (!isConnected) {
      late Object output;
      var createdLiabilities = offlineUser.get('created-liabilities-id');
      var allLiabilities = box.get('allLiabilities');
      List responseData = [];
      responseData.addAll(allLiabilities);
      if (createdLiabilities != null) {
        createdLiabilities.forEach((id) {
          responseData.add(offlineUser.get(id));
        });
      }
      if (responseData.isEmpty) {
        output = jsonDecode(json.encode({'error': 'network', 'count': null}));
      } else {
        responseData.sort((a, b) => DateTime.parse(b['created_date'])
            .compareTo(DateTime.parse(a['created_date'])));
        var data = {'count': responseData.length, 'results': responseData};
        output = jsonDecode(jsonEncode(data));
      }
      return output;
    }

    try {
      late Object output;
      final accessToken = await getData('access_token');
      final response = await http.get(
        Uri.parse('$domainPortion/liability/liabilities/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );

      var statusCode = response.statusCode;
      if (statusCode == 401) {
        utilityController.writeData('needsLogOut', 'true');
        return jsonDecode(json.encode({'error': 'true', 'count': null}));
      } else {
        output = json.decode(response.body);
        return output;
      }
      // Code Area End
    } catch (e) {
      late Object output;
      if (e.toString().contains('SocketException')) {
        output = jsonDecode(json.encode({'error': 'network', 'count': null}));
      }
      output = jsonDecode(json.encode({'error': 'true', 'count': null}));
      return output;
    }
  }

  Future getDueLiabilities() async {
    var box = await Hive.openBox('liabilities');
    bool isConnected = await utilityController.isConnected();

    // Offline check
    if (!isConnected) {
      late Object output;
      var dueLiabilities = box.get('dueLiabilities');
      if (dueLiabilities == null) {
        output = jsonDecode(json.encode({'error': 'network', 'count': null}));
      } else {
        dueLiabilities.sort((a, b) => DateTime.parse(b['created_date'])
            .compareTo(DateTime.parse(a['created_date'])));
        var data = {'count': dueLiabilities.length, 'results': dueLiabilities};
        output = jsonDecode(jsonEncode(data));
      }
      return output;
    }

    try {
      late Object output;
      final accessToken = await getData('access_token');
      final response = await http.get(
        Uri.parse('$domainPortion/liability/due/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );

      var statusCode = response.statusCode;
      if (statusCode == 401) {
        utilityController.writeData('needsLogOut', 'true');
        return jsonDecode(json.encode({'error': 'true', 'count': null}));
      } else {
        output = json.decode(response.body);
        return output;
      }
      // Code Area End
    } catch (e) {
      late Object output;
      if (e.toString().contains('SocketException')) {
        output = jsonDecode(json.encode({'error': 'network', 'count': null}));
      }
      output = jsonDecode(json.encode({'error': 'true', 'count': null}));
      return output;
    }
  }

  Future getPendingLiabilities() async {
    var box = await Hive.openBox('liabilities');
    bool isConnected = await utilityController.isConnected();

    // Offline check
    if (!isConnected) {
      late Object output;
      var pendingLiabilities = box.get('pendingLiabilities');

      if (pendingLiabilities == null) {
        output = jsonDecode(json.encode({'error': 'network', 'count': null}));
      } else {
        pendingLiabilities.sort((a, b) => DateTime.parse(b['created_date'])
            .compareTo(DateTime.parse(a['created_date'])));
        var data = {
          'count': pendingLiabilities.length,
          'results': pendingLiabilities
        };
        output = jsonDecode(jsonEncode(data));
      }
      return output;
    }

    try {
      late Object output;
      final accessToken = await getData('access_token');
      final response = await http.get(
        Uri.parse('$domainPortion/liability/pending/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );

      var statusCode = response.statusCode;
      if (statusCode == 401) {
        utilityController.writeData('needsLogOut', 'true');
        return jsonDecode(json.encode({'error': 'true', 'count': null}));
      } else {
        output = json.decode(response.body);
        return output;
      }
      // Code Area End
    } catch (e) {
      late Object output;
      if (e.toString().contains('SocketException')) {
        output = jsonDecode(json.encode({'error': 'network', 'count': null}));
      }
      output = jsonDecode(json.encode({'error': 'true', 'count': null}));
      return output;
    }
  }

  Future getPaidLiabilities() async {
    var box = await Hive.openBox('liabilities');
    bool isConnected = await utilityController.isConnected();

    // Offline check
    if (!isConnected) {
      late Object output;
      var paidLiabilities = box.get('paidLiabilities');
      if (paidLiabilities == null) {
        output = jsonDecode(json.encode({'error': 'network', 'count': null}));
      } else {
        paidLiabilities.sort((a, b) => DateTime.parse(b['created_date'])
            .compareTo(DateTime.parse(a['created_date'])));
        var data = {
          'count': paidLiabilities.length,
          'results': paidLiabilities
        };
        output = jsonDecode(jsonEncode(data));
      }
      return output;
    }

    try {
      late Object output;
      final accessToken = await getData('access_token');
      final response = await http.get(
        Uri.parse('$domainPortion/liability/paid/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );

      var statusCode = response.statusCode;
      if (statusCode == 401) {
        utilityController.writeData('needsLogOut', 'true');
        return jsonDecode(json.encode({'error': 'true', 'count': null}));
      } else {
        output = json.decode(response.body);
        return output;
      }
      // Code Area End
    } catch (e) {
      late Object output;
      if (e.toString().contains('SocketException')) {
        output = jsonDecode(json.encode({'error': 'network', 'count': null}));
      }
      output = jsonDecode(json.encode({'error': 'true', 'count': null}));
      return output;
    }
  }

  Future deleteLiability(String debtId) async {
    try {
      late Object output;
      final accessToken = await getData('access_token');
      final response = await http.delete(
        Uri.parse('$domainPortion/liability/action/$debtId/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );

      var statusCode = response.statusCode;
      if (statusCode == 401) {
        utilityController.writeData('needsLogOut', 'true');
        return jsonDecode(json.encode({'error': 'true'}));
      } else {
        output = json.decode(response.body);
        utilityController.getBackgroundSync();
        return output;
      }
      // Code Area End
    } catch (e) {
      late Object output;
      if (e.toString().contains('SocketException')) {
        output = jsonDecode(json.encode({'error': 'network'}));
      }
      output = jsonDecode(json.encode({'error': 'true'}));
      return output;
    }
  }

  // delete offlineData
  Future<bool> deleteOffline(
    BuildContext context,
    Liability liability,
    AppLocalizations transH,
  ) async {
    var offlineUser = await Hive.openBox('offlineUser');
    var createdLiabilities = offlineUser.get('created-liabilities-id');
    List newData = [];
    if (createdLiabilities != null) {
      createdLiabilities.forEach((id) {
        if (id != liability.id) {
          newData.add(id);
        }
      });
      if (newData.isNotEmpty) {
        offlineUser.put('created-liabilities-id', newData);
      } else {
        offlineUser.delete('created-liabilities-id');
      }
      offlineUser.delete(liability.id);
      successSnackBar(
        context: context,
        title: transH.success.capitalizeFirst.toString(),
        message: transH.deleted.capitalizeFirst.toString(),
      );
      LocalNotifications.showNotification(
        title: transH.success.capitalizeFirst.toString(),
        body: transH.deleted.capitalizeFirst.toString(),
        payload: '',
      );
      navigateReplacementNamed(context, AppRoutes.home);
    } else {
      errorSnackBar(
        context: context,
        title: transH.error.capitalizeFirst.toString(),
        message: transH.unkownError.capitalizeFirst.toString(),
      );
    }
    return true;
  }

  // Edit offline data
  Future<bool> editOfflineData(
    BuildContext context,
    Liability liability,
    AppLocalizations transH,
  ) async {
    var offlineUser = await Hive.openBox('offlineUser');

    Object liabilityData = {
      'id': liability.id,
      'currency': liability.currency,
      'email': liability.email,
      'phone_number': liability.phoneNumber,
      'creditor_name': liability.creditorName,
      'description': liability.description,
      'status': liability.status,
      'amount': liability.amount,
      'payment_date': liability.paymentDate,
      'created_date': liability.createdDate,
      'updated_date': liability.updatedDate,
      'edited': false,
      'offline_data': true,
      'user': liability.user
    };

    offlineUser.put(liability.id, liabilityData);

    LocalNotifications.showNotification(
      title: transH.success.capitalizeFirst.toString(),
      body: transH.liabilityUpdated.capitalizeFirst.toString(),
      payload: '',
    );
    Navigator.pop(context);
    return true;
  }
}
