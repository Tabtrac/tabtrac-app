import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/urls.dart';
import '../helpers/functions.dart';
import 'utl_controllers.dart';

class TokenValidatorController{

  // These blocks of code are very essential and should be careful when modifying
  // Else the whole code could go down
  final utilityController = UtitlityController();

    Future getNewAccessToken() async {
    try {
      final refreshToken = await utilityController.getData('refresh_token');
      final response = await http.post(
          Uri.parse('$domainPortion/token/token-refresh/'),
          body: {'refresh_token': refreshToken});

      var responseData = json.decode(response.body);
      if (responseData['error'] == 'Invalid refresh token') {
        return jsonDecode(json.encode({'response': 'invalid refresh token'}));
      } else if (responseData['error'] == 'Refresh token is required') {
        return jsonDecode(json.encode({'response': 'invalid refresh token'}));
      } else {
        utilityController.writeData('access_token', responseData['access_token']);
        return jsonDecode(json.encode({'response': 'true'}));
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'response': 'network'}));
      }
      return jsonDecode(json.encode({'response': 'true'}));
    }
  }

  Future isAccessTokenValid() async {
    final isValid = await _checkTokenValidity();

    if (isValid['response'] == 'unknown') {
      return jsonDecode(json.encode({'response': 'unknown'}));
    } else if (isValid['response'] == 'network') {
      return jsonDecode(json.encode({'response': 'network'}));
    } else if (isValid['response'] == 'false') {
      return jsonDecode(json.encode({'response': 'false'}));
    } else if (isValid['response'] == 'true') {
      return jsonDecode(json.encode({'response': 'true'}));
    }
  }

  Future _checkTokenValidity() async {
    try {
      final accessToken = await utilityController.getData('access_token');
      final response = await http.get(
        Uri.parse('$domainPortion/token/test_token/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );
      var responseData = json.decode(response.body);
      if (responseData['code'] == 'token_not_valid') {
        if (responseData['messages'][0]['token_type'] == 'access' ||
            responseData['messages'][0]['message'] ==
                'Token is invalid or expired') {
          final data = await getNewAccessToken();
          if (data['response'] == 'invalid refresh token') {
            reLogout();
            return jsonDecode(json.encode({'response': 'unknown'}));
          } else {
            return jsonDecode(json.encode({'response': 'true'}));
          }
        }
        return jsonDecode(json.encode({'response': 'false'}));
      } else {
        return jsonDecode(json.encode({'response': 'true'}));
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return jsonDecode(json.encode({'response': 'network'}));
      }
      return jsonDecode(json.encode({'response': 'true'}));
    }
  }

  tokenVerify(Function() code) async {
    try {
      var dataToken = await isAccessTokenValid();
      if (dataToken['response'] == 'true') {
        code;
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
  // The END of token validity
}