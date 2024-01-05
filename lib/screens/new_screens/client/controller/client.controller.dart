// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/app_routes.dart';
import '../../../../constants/urls.dart';
import '../../../../controllers/utl_controllers.dart';
import '../../../../helpers/notification_helpers.dart';
import '../../../../models/record.model.dart';
import '../../../../providers/providers.dart';
import '../../../../widgets/snackbars.dart';
import '../../actions/providers/actions.provider.dart';
import '../models/client.model.dart';
import '../providers/provider.client.dart';

class ClientController {
  final WidgetRef ref;
  final BuildContext context;

  ClientController({required this.ref, required this.context});
  UtitlityController utitlityController = UtitlityController();

  Future<void> getAllClients() async {
    if (await isOnline()) {
      ref.read(allClientLoadingProvider.notifier).change(true);
      final transH = AppLocalizations.of(context)!;
      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');
        final response = await http.get(
          Uri.parse('$domainPortion/api/client/'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        );
        var responseData = json.decode(response.body);

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
        } else if (statusCode == 200 || statusCode == 201) {
          List<Client> clients = [];
          // clientListProvider
          if (responseData['response'] == 'OK') {
            responseData['client'].forEach((element) {
              clients.add(Client.fromJson(element));
            });
            ref.read(clientListProvider.notifier).change(clients);
          }
        } else {
          errorSnackBar(
              context: context,
              title: transH.error,
              message: transH.unkownError);
        }
      } catch (e) {
        if (e.toString().contains('SocketException')) {
          errorSnackBar(
              context: context, title: transH.error, message: transH.network);
        }
        errorSnackBar(
            context: context,
            title: transH.error.capitalize(),
            message: transH.unkownError.capitalize());
      }
      ref.read(allClientLoadingProvider.notifier).change(false);
    }
  }

  Future<void> searchClients() async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;
      final searchString = ref.read(searchStringProvider);
      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');
        final response = await http.get(
          Uri.parse('$domainPortion/api/search/client/?q=$searchString'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        );
        var responseData = json.decode(response.body);

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
        } else if (statusCode == 200 || statusCode == 201) {
          List<Client> clients = [];
          ref.read(searchedClientListProvider.notifier).change(clients);
          // searchedClientListProvider
          if (responseData['response'] == 'OK') {
            responseData['data'].forEach((element) {
              clients.add(Client.fromJson(element));
            });
            ref.read(isSearchingProvider.notifier).change(false);
            ref.read(searchedClientListProvider.notifier).change(clients);
          }
        } else {
          errorSnackBar(
              context: context,
              title: transH.error.capitalize(),
              message: transH.unkownError.capitalize());
        }
      } catch (e) {
        if (e.toString().contains('SocketException')) {
          errorSnackBar(
              context: context,
              title: transH.error.capitalize(),
              message: transH.network.capitalize());
        }
        errorSnackBar(
            context: context,
            title: transH.error.capitalize(),
            message: transH.unkownError.capitalize());
      }
    }
  }

  Future<bool> createClient(
      {required String name,
      String? email,
      String? phoneNumber,
      String? location,
      bool? saveData}) async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;

      if (name.isEmpty) {
        errorSnackBar(
            context: context,
            title: transH.error.capitalize(),
            message: transH.clientNameExists.capitalize());
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
        return false;
      } else {
        try {
          // Code Area
          final accessToken = await utitlityController.getData('access_token');
          final response = await http.post(
            Uri.parse('$domainPortion/api/client/'),
            body: {
              "name": name,
              "location": location,
              "email": email,
              "phone_number": phoneNumber
            },
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            },
          );
          var responseData = json.decode(response.body);

          var statusCode = response.statusCode;
          if (statusCode == 401) {
            utitlityController.writeData('needsLogOut', 'true');
            navigateReplacementNamed(context, AppRoutes.loginRoute);
            ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
            return true;
          } else if (statusCode == 201) {
            LocalNotifications.showNotification(
                title: transH.success.capitalize(),
                body: transH.clientCreated.capitalize(),
                payload: '');
            Client client = Client.fromJson(responseData['client']);
            if (saveData != null) {
              ref.read(selectedClient.notifier).change(client);
            }
            await getAllClients();
            ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
            return true;
          } else if (statusCode == 409) {
            errorSnackBar(
                context: context,
                title: transH.error.capitalize(),
                message: transH.clientNameExists.capitalize());
            ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);

            return false;
          } else {
            errorSnackBar(
                context: context,
                title: transH.error.capitalize(),
                message: transH.unkownError.capitalize());
            ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
            return false;
          }
        } catch (e) {
          if (e.toString().contains('SocketException')) {
            errorSnackBar(
                context: context,
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
      }
    } else {
      return false;
    }
  }

  Future<bool> updateClient({
    required String clientId,
    required String name,
    String? email,
    String? phoneNumber,
    String? location,
  }) async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;

      if (name.isEmpty) {
        errorSnackBar(
            context: context,
            title: transH.error.capitalize(),
            message: transH.clientNameExists.capitalize());
        ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
        return false;
      } else {
        try {
          // Code Area
          final accessToken = await utitlityController.getData('access_token');
          final response = await http.put(
            Uri.parse('$domainPortion/api/client/$clientId/'),
            body: {
              "name": name,
              "location": location,
              "email": email,
              "phone_number": phoneNumber
            },
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            },
          );
          var responseData = json.decode(response.body);

          var statusCode = response.statusCode;
          if (statusCode == 401) {
            utitlityController.writeData('needsLogOut', 'true');
            navigateReplacementNamed(context, AppRoutes.loginRoute);
            ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
            return true;
          } else if (statusCode == 201) {
            LocalNotifications.showNotification(
              title: transH.success.capitalize(),
              body: transH.clientUpdated.capitalize(),
              payload: '',
            );
            Client client = Client.fromJson(responseData['client']);
            getAllClients();
            await getDetailedClientData(client.id.toString());
            ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
            return true;
          } else {
            errorSnackBar(
                context: context,
                title: transH.error.capitalize(),
                message: transH.unkownError.capitalize());
            ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(false);
            return false;
          }
        } catch (e) {
          if (e.toString().contains('SocketException')) {
            errorSnackBar(
                context: context,
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
      }
    } else {
      return false;
    }
  }

  Future<void> getDetailedClientData(String clientId) async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;
      ref.read(clientLoadingProvider.notifier).change(true);

      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');
        final response = await http.get(
          Uri.parse('$domainPortion/api/client/$clientId/'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        );
        var responseData = json.decode(response.body);

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
        } else if (statusCode == 200 || statusCode == 201) {
          List<UserRecord> clientDebtRecords = [];
          List<UserRecord> clientCreditRecords = [];

          if (responseData['response'] == 'OK') {
            responseData['records']['debt'].forEach((element) {
              clientDebtRecords.add(UserRecord.fromJson(element));
            });
            responseData['records']['credit'].forEach((element) {
              clientCreditRecords.add(UserRecord.fromJson(element));
            });
            Client client = Client.fromJson(responseData['client']);
            ref
                .read(clientDebtRecordProvider.notifier)
                .change(clientDebtRecords);
            ref
                .read(clientCreditRecordProvider.notifier)
                .change(clientCreditRecords);
            ref.read(currentCleintDetailsProvider.notifier).change(client);
          }
        } else {
          errorSnackBar(
              context: context,
              title: transH.error.capitalize(),
              message: transH.unkownError.capitalize());
        }
      } catch (e) {
        if (e.toString().contains('SocketException')) {
          errorSnackBar(
              context: context,
              title: transH.error.capitalize(),
              message: transH.network.capitalize());
        }
        errorSnackBar(
            context: context,
            title: transH.error.capitalize(),
            message: transH.unkownError.capitalize());
      }
      ref.read(clientLoadingProvider.notifier).change(false);
    }
  }

  Future<void> deleteClient(String clientId) async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;
      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');
        final response = await http.delete(
          Uri.parse('$domainPortion/api/client/$clientId/'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        );

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
        } else if (statusCode == 200) {
          await getAllClients();
          ref.read(isDeletingProvider.notifier).change(false);
          Navigator.pop(context);
        } else {
          errorSnackBar(
              context: context,
              title: transH.error.capitalize(),
              message: transH.unkownError.capitalize());
        }
      } catch (e) {
        if (e.toString().contains('SocketException')) {
          errorSnackBar(
              context: context,
              title: transH.error.capitalize(),
              message: transH.network.capitalize());
        }
        errorSnackBar(
            context: context,
            title: transH.error.capitalize(),
            message: transH.unkownError.capitalize());
      }
    }
  }
}
