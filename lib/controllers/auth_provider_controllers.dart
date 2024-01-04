// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/urls.dart';
import 'token_controller.dart';
import 'utl_controllers.dart';

class AuthController extends StateNotifier<AsyncValue> {
  AuthController() : super(const AsyncValue.loading());

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

  Future registerUser(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$domainPortion/register/'),
        body: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      var responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'error': 'network'}));
      }
      return jsonDecode(json.encode({'error': 'true'}));
    }
  }

  Future loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$domainPortion/login/'),
        body: {
          'email': email,
          'password': password,
        },
      );
      var responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'error': 'network'}));
      }
      return jsonDecode(json.encode({'error': 'true'}));
    }
  }


  Future getOTP() async {
    try {
      var dataToken = await tokenValidatorController.isAccessTokenValid();
      if (dataToken['response'] == 'true') {
        final accessToken = await getData('access_token');
        final response = await http.post(
          Uri.parse('$domainPortion/user/get-otp/'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
          body: {},
        );
        var responseData = json.decode(response.body);
        return responseData;
      } else if (dataToken['response'] == 'false') {
        return jsonDecode(json.encode({'error': 'true'}));
      } else if (dataToken['response'] == 'unknown') {
        utilityController.writeData('needsLogOut', 'true');
        return jsonDecode(json.encode({'error': 'true'}));
      } else {
        return jsonDecode(json.encode({'error': 'network'}));
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'error': 'network'}));
      }
      return jsonDecode(json.encode({'error': 'true'}));
    }
  }

  Future verifyOTP(String code) async {
    try {
      var dataToken = await tokenValidatorController.isAccessTokenValid();
      if (dataToken['response'] == 'true') {
        final accessToken = await getData('access_token');
        final response = await http.post(
          Uri.parse('$domainPortion/user/verify-otp/'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
          body: {
            'otp': code,
          },
        );
        var responseData = json.decode(response.body);
        return responseData;
      } else if (dataToken['response'] == 'false') {
        return jsonDecode(json.encode({'error': 'true'}));
      } else if (dataToken['response'] == 'unknown') {
        utilityController.writeData('needsLogOut', 'true');
        return jsonDecode(json.encode({'error': 'true'}));
      } else {
        return jsonDecode(json.encode({'error': 'network'}));
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'error': 'network'}));
      }
      return jsonDecode(json.encode({'error': 'true'}));
    }
  }

  writeData(String key, String value) async {
    await _secureStorage.write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
    );
  }



  Future sendPasswordOTP(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$domainPortion/user/forgotten-password/'),
        body: {
          'email': email,
        },
      );
      var responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'error': 'network'}));
      }
      return jsonDecode(json.encode({'error': 'true'}));
    }
  }

  Future resetPassword(String code, String password) async {
    try {
      var dataToken = await tokenValidatorController.isAccessTokenValid();
      if (dataToken['response'] == 'true') {
        final accessToken = await getData('access_token');
        final response = await http.put(
          Uri.parse('$domainPortion/user/forgotten-password/'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
          body: {
            'otp': code,
            'password': password,
          },
        );
        var responseData = json.decode(response.body);
        return responseData;
      } else if (dataToken['response'] == 'false') {
        return jsonDecode(json.encode({'error': 'true'}));
      } else if (dataToken['response'] == 'unknown') {
        utilityController.writeData('needsLogOut', 'true');
        return jsonDecode(json.encode({'error': 'true'}));
      } else {
        return jsonDecode(json.encode({'error': 'network'}));
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'error': 'network'}));
      }
      return jsonDecode(json.encode({'error': 'true'}));
    }
  }
}
