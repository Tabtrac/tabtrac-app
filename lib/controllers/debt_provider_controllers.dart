import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants/urls.dart';
import 'token_controller.dart';
import 'utl_controllers.dart';

class DebtsController extends StateNotifier<AsyncValue> {
  DebtsController() : super(const AsyncValue.loading());

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
        print(currency);
    try {
      // Code Area
      final accessToken = await getData('access_token');
      String createdDate =
          DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now());
      String updatedDate =
          DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now());
      final response = await http.post(
        Uri.parse('$domainPortion/debt/actions/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
        body: {
          'email': email,
          'phone_number': phoneNumber,
          'debtorName': name,
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

  Future updateDebt(
      String id,
      String name,
      String paymentDate,
      String price,
      String description,
      String updatedDate,
      String? phoneNumber,
      String? email) async {
    try {
      // Code Area
      final accessToken = await getData('access_token');
      String createdDate =
          DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now());
      final response = await http.put(
        Uri.parse('$domainPortion/debt/action/$id/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
        body: {
          'email': email,
          'phone_number': phoneNumber,
          'debtorName': name,
          'description': description,
          'amount': price,
          'payment_date': paymentDate,
          'created_date': createdDate,
          'updated_date': updatedDate,
          'currency': 'naira'
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
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'error': 'network'}));
      }
      return jsonDecode(json.encode({'error': 'true'}));
    }
  }

  Future depositedOnDebt(String id, String paymentDate, String price,
      String description, String depositedDate) async {
    try {
      // Code Area
      final accessToken = await getData('access_token');
      final response = await http.patch(
        Uri.parse('$domainPortion/debt/action/$id/'),
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

  Future markAsPaid(String id, String datePaid) async {
    try {
      // Code Area
      final accessToken = await getData('access_token');
      final response = await http.patch(
        Uri.parse('$domainPortion/user/record-cleared/$id/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
        body: {'date_paid': datePaid, 'type': 'debt'},
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

  // TODO: this page still needs some amendment after the backend adds pagination

  Future getAllDebts() async {
    var box = await Hive.openBox('debts');
    bool isConnected = await utilityController.isConnected();

    // Offline check
    if (!isConnected) {
      late Object output;
      var allDebts = box.get('allDebts');
      if (allDebts == null) {
        output = jsonDecode(json.encode({'error': 'network', 'count': null}));
      } else {
        allDebts.sort((a, b) => DateTime.parse(b['created_date'])
            .compareTo(DateTime.parse(a['created_date'])));

        var data = {'count': allDebts.length, 'results': allDebts};
        output = jsonDecode(jsonEncode(data));
      }
      return output;
    }

    try {
      late Object output;
      final accessToken = await getData('access_token');
      final response = await http.get(
        Uri.parse('$domainPortion/debt/debts/'),
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

  Future getDueDebts() async {
    var box = await Hive.openBox('debts');
    bool isConnected = await utilityController.isConnected();

    // Offline check
    if (!isConnected) {
      late Object output;
      var dueDebts = box.get('dueDebts');
      if (dueDebts == null) {
        output = jsonDecode(json.encode({'error': 'network'}));
      } else {
        dueDebts.sort((a, b) => DateTime.parse(b['created_date'])
            .compareTo(DateTime.parse(a['created_date'])));
        var data = {'count': dueDebts.length, 'results': dueDebts};
        output = jsonDecode(jsonEncode(data));
      }

      return output;
    }

    try {
      late Object output;
      final accessToken = await getData('access_token');
      final response = await http.get(
        Uri.parse('$domainPortion/debt/due/'),
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

  Future getPendingDebts() async {
    var box = await Hive.openBox('debts');
    bool isConnected = await utilityController.isConnected();

    // Offline check
    if (!isConnected) {
      late Object output;
      var pendingDebts = box.get('pendingDebts');
      if (pendingDebts == null) {
        output = jsonDecode(json.encode({'error': 'network', 'count': null}));
      } else {
        pendingDebts.sort((a, b) => DateTime.parse(b['created_date'])
            .compareTo(DateTime.parse(a['created_date'])));
        var data = {'count': pendingDebts.length, 'results': pendingDebts};
        output = jsonDecode(jsonEncode(data));
      }
      return output;
    }
    try {
      late Object output;
      final accessToken = await getData('access_token');
      final response = await http.get(
        Uri.parse('$domainPortion/debt/pending/'),
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

  Future getPaidDebts() async {
    var box = await Hive.openBox('debts');
    bool isConnected = await utilityController.isConnected();

    // Offline check
    if (!isConnected) {
      late Object output;
      var paidDebts = box.get('paidDebts');
      if (paidDebts == null) {
        output = jsonDecode(json.encode({'error': 'network', 'count': null}));
      } else {
        paidDebts.sort((a, b) => DateTime.parse(b['created_date'])
            .compareTo(DateTime.parse(a['created_date'])));
        var data = {'count': paidDebts.length, 'results': paidDebts};
        output = jsonDecode(jsonEncode(data));
      }
      return output;
    }

    try {
      late Object output;
      final accessToken = await getData('access_token');
      final response = await http.get(
        Uri.parse('$domainPortion/debt/paid/'),
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

  Future deleteDebt(String debtId) async {
    try {
      late Object output;
      final accessToken = await getData('access_token');
      final response = await http.delete(
        Uri.parse('$domainPortion/debt/action/$debtId/'),
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
}
