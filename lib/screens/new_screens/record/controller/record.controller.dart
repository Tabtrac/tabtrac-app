// ignore_for_file: use_build_context_synchronously,

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_routes.dart';
import '../../../../constants/urls.dart';
import '../../../../controllers/utl_controllers.dart';
import '../../../../widgets/snackbars.dart';
import '../../../../models/record.model.dart';
import '../../home/models/overview.model.dart';
import '../../home/providers/provider.dart';
import '../providers/record.provider.dart';

class RecordController {
  final WidgetRef ref;
  final BuildContext context;

  RecordController({required this.ref, required this.context});
  UtitlityController utitlityController = UtitlityController();

  Future<void> onLoadData() async {
    final transH = AppLocalizations.of(context)!;
    if (await isOnline()) {
      ref.read(recentLoadingProvider.notifier).change(true);
      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');
        final response = await http.get(
          Uri.parse('$domainPortion/api/record/omega/'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        );
        var responseData = json.decode(response.body);

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
          // return CurrentState.none;
        } else if (statusCode == 200 || statusCode == 201) {
          // overview data
          OverviewData data = OverviewData.fromJson(responseData['overview']);
          ref.read(overviewDataProvider.notifier).setData(data);
          // end of overview data

          // all credit records
          List<UserRecord> creditRecord = [];
          responseData['records']['credit_all'].forEach((element) {
            creditRecord.add(UserRecord.fromJson(element));
          });
          ref.read(allCreditRecordsProvider.notifier).change(creditRecord);

          // all debt records
          List<UserRecord> debtRecord = [];
          responseData['records']['debt_all'].forEach((element) {
            debtRecord.add(UserRecord.fromJson(element));
          });
          ref.read(allDebtRecordsProvider.notifier).change(debtRecord);

          // Recent activities
          List<UserRecord> creditRecordsRecent = [];
          List<UserRecord> debtRecordsRecent = [];
          responseData['recent_activities']['credit'].forEach((element) {
            creditRecordsRecent.add(UserRecord.fromJson(element));
          });
          responseData['recent_activities']['debt'].forEach((element) {
            debtRecordsRecent.add(UserRecord.fromJson(element));
          });
          ref.read(recentDebtRecordProvider.notifier).change(debtRecordsRecent);
          ref
              .read(recentCreditRecordProvider.notifier)
              .change(creditRecordsRecent);
          ref.read(recentLoadingProvider.notifier).change(false);
          // end of recent activities

          // records actions
          // credit records actions
          List<UserRecord> pendingCreditRecordList = [];
          List<UserRecord> dueCreditRecordList = [];
          List<UserRecord> paidCreditRecordList = [];

          // debt records actions
          List<UserRecord> pendingDebtRecordList = [];
          List<UserRecord> dueDebtRecordList = [];
          List<UserRecord> paidDebtRecordList = [];

          // debt Handler
          // pending
          responseData['actions']['debt']['pending'].forEach((element) {
            pendingDebtRecordList.add(UserRecord.fromJson(element));
          });
          ref.read(pendingDebtRecordsProvider.notifier).change(pendingDebtRecordList);

          // due
          responseData['actions']['debt']['due'].forEach((element) {
            dueDebtRecordList.add(UserRecord.fromJson(element));
          });
          ref.read(dueDebtRecordsProvider.notifier).change(dueDebtRecordList);

          // paid
          responseData['actions']['debt']['paid'].forEach((element) {
            paidDebtRecordList.add(UserRecord.fromJson(element));
          });
          ref.read(paidDebtRecordsProvider.notifier).change(paidDebtRecordList);

          // credit Handler
          // pending
          responseData['actions']['credit']['pending'].forEach((element) {
            pendingCreditRecordList.add(UserRecord.fromJson(element));
          });
          ref.read(pendingCreditRecordsProvider.notifier).change(pendingCreditRecordList);

          // due
          responseData['actions']['credit']['due'].forEach((element) {
            dueCreditRecordList.add(UserRecord.fromJson(element));
          });
          ref.read(dueCreditRecordsProvider.notifier).change(dueCreditRecordList);

          // paid
          responseData['actions']['credit']['paid'].forEach((element) {
            paidCreditRecordList.add(UserRecord.fromJson(element));
          });
          ref.read(paidCreditRecordsProvider.notifier).change(paidCreditRecordList);

        } else {
          errorSnackBar(
              context: context,
              title: transH.error,
              message: transH.unkownError);
        }
      } catch (e) {
        if (e.toString().contains('SocketException')) {
          // return CurrentState.network;
          errorSnackBar(
              context: context, title: transH.error, message: transH.network);
        }
        errorSnackBar(
            context: context, title: transH.error, message: transH.unkownError);
      }
    }
  }

  Future getOverviewData() async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;
      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');
        final response = await http.get(
          Uri.parse('$domainPortion/api/record/overview/'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        );
        var responseData = json.decode(response.body);

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
          // return CurrentState.none;
        } else if (statusCode == 200 || statusCode == 201) {
          OverviewData data = OverviewData.fromJson(responseData);
          ref.read(overviewDataProvider.notifier).setData(data);
          // return CurrentState.done;
        } else {
          errorSnackBar(
              context: context,
              title: transH.error,
              message: transH.unkownError);
        }
      } catch (e) {
        if (e.toString().contains('SocketException')) {
          // return CurrentState.network;
          errorSnackBar(
              context: context, title: transH.error, message: transH.network);
        }
        errorSnackBar(
            context: context, title: transH.error, message: transH.unkownError);
      }
    }
  }

  Future<void> getAllCreditRecords() async {
    final transH = AppLocalizations.of(context)!;

    if (await isOnline()) {
      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');
        final response = await http.get(
          Uri.parse('$domainPortion/api/record/credit/'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        );
        var responseData = json.decode(response.body);

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
        } else if (statusCode == 200) {
          List<UserRecord> creditRecord = [];
          if (responseData['response'] == 'OK') {
            responseData['data'].forEach((element) {
              creditRecord.add(UserRecord.fromJson(element));
            });
            ref.read(allCreditRecordsProvider.notifier).change(creditRecord);
          } else {
            errorSnackBar(
                context: context,
                title: transH.error,
                message: transH.unkownError);
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
            title: transH.error.capitalizeFirst.toString(),
            message: transH.unkownError.capitalizeFirst.toString());
      }
    }
  }

  Future<void> getAllDebtRecords() async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;
      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');
        final response = await http.get(
          Uri.parse('$domainPortion/api/record/debt/'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        );
        var responseData = json.decode(response.body);

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
        } else if (statusCode == 200) {
          List<UserRecord> debtRecord = [];
          if (responseData['response'] == 'OK') {
            responseData['data'].forEach((element) {
              debtRecord.add(UserRecord.fromJson(element));
            });
            ref.read(allDebtRecordsProvider.notifier).change(debtRecord);
          } else {
            errorSnackBar(
                context: context,
                title: transH.error,
                message: transH.unkownError);
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
            title: transH.error.capitalizeFirst.toString(),
            message: transH.unkownError.capitalizeFirst.toString());
      }
    }
  }

  Future<void> getAllRecordActions(String actionType, String recordType) async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;
      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');
        final response = await http.get(
          Uri.parse('$domainPortion/api/record/get/$actionType/$recordType/'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        );
        var responseData = json.decode(response.body);

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
        } else if (statusCode == 200) {
          List<UserRecord> recordList = [];
          if (responseData['response'] == 'OK') {
            responseData['data'].forEach((element) {
              recordList.add(UserRecord.fromJson(element));
            });
            if (recordType == 'debt') {
              switch (actionType) {
                case 'pending':
                  ref
                      .read(pendingDebtRecordsProvider.notifier)
                      .change(recordList);
                  break;
                case 'due':
                  ref.read(dueDebtRecordsProvider.notifier).change(recordList);
                  break;
                case 'paid':
                  ref.read(paidDebtRecordsProvider.notifier).change(recordList);
                  break;
                default:
                  ref
                      .read(pendingDebtRecordsProvider.notifier)
                      .change(recordList);
                  break;
              }
            } else {
              switch (actionType) {
                case 'pending':
                  ref
                      .read(pendingCreditRecordsProvider.notifier)
                      .change(recordList);
                  break;
                case 'due':
                  ref
                      .read(dueCreditRecordsProvider.notifier)
                      .change(recordList);
                  break;
                case 'paid':
                  ref
                      .read(paidCreditRecordsProvider.notifier)
                      .change(recordList);
                  break;
                default:
                  ref
                      .read(pendingCreditRecordsProvider.notifier)
                      .change(recordList);
                  break;
              }
            }
            // ref.read(allDebtRecordsProvider.notifier).change(debtRecord);
          } else {
            errorSnackBar(
                context: context,
                title: transH.error,
                message: transH.unkownError);
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
            title: transH.error.capitalizeFirst.toString(),
            message: transH.unkownError.capitalizeFirst.toString());
      }
    }
  }

  Future<void> infiniteRecordFetch(
      String actionType, String recordType, int currentLoadCount) async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;
      if (ref.read(nextIntProvider) == null) {
        // done
      } else {
        try {
          // Code Area
          final accessToken = await utitlityController.getData('access_token');

          String ct = currentLoadCount.toString();
          final response = await http.get(
            Uri.parse(
                '$domainPortion/api/paginated/$recordType/$actionType/?page=$ct'),
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            },
          );
          var responseData = json.decode(response.body);

          var statusCode = response.statusCode;
          if (statusCode == 401) {
            utitlityController.writeData('needsLogOut', 'true');
            navigateReplacementNamed(context, AppRoutes.loginRoute);
          } else if (statusCode == 200) {
            List<UserRecord> recordList = [];
            if (currentLoadCount != 1 &&
                ref.read(infiniteRecordListProvider).isNotEmpty) {
              var existing = ref.read(infiniteRecordListProvider);
              recordList.addAll(existing);
            }
            responseData['results'].forEach((element) {
              recordList.add(UserRecord.fromJson(element));
            });
            if (responseData['next'] == null) {
              ref.read(nextIntProvider.notifier).change(null);
            }
            ref.read(infiniteRecordListProvider.notifier).change(recordList);
          } else if (statusCode == 404) {
            ref.read(nextIntProvider.notifier).change(null);
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
              title: transH.error.capitalizeFirst.toString(),
              message: transH.unkownError.capitalizeFirst.toString());
        }
      }
    }
  }

  Future<void> markRecordAsPaid(String recordType, UserRecord record) async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;
      ref.read(isLoadingProvider.notifier).change(true);

      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');

        String date = DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now());
        final response = await http.patch(
            Uri.parse('$domainPortion/api/record/$recordType/${record.id}/'),
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            },
            body: {
              'date_paid': date
            });

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
        } else if (statusCode == 200 || statusCode == 201) {
          record.status = 'paid';
          successSnackBar(
            title: transH.success.capitalizeFirst.toString(),
            message:
                "${transH.record} ${transH.paid}".capitalizeFirst.toString(),
          );
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
            title: transH.error.capitalizeFirst.toString(),
            message: transH.unkownError.capitalizeFirst.toString());
      }
      ref.read(isLoadingProvider.notifier).change(false);
    }
  }

  Future getRecentActivity() async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;
      ref.read(recentLoadingProvider.notifier).change(true);
      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');
        final response = await http.get(
          Uri.parse('$domainPortion/api/record/recent/'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        );
        var responseData = json.decode(response.body);

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
        } else if (statusCode == 200) {
          List<UserRecord> creditRecords = [];
          List<UserRecord> debtRecords = [];

          if (responseData['response'] == 'OK') {
            responseData['data']['credit'].forEach((element) {
              creditRecords.add(UserRecord.fromJson(element));
            });
            responseData['data']['debt'].forEach((element) {
              debtRecords.add(UserRecord.fromJson(element));
            });
            ref.read(recentDebtRecordProvider.notifier).change(debtRecords);
            ref.read(recentCreditRecordProvider.notifier).change(creditRecords);
          }
        } else {
          errorSnackBar(
              context: context,
              title: transH.error,
              message: transH.unkownError);
        }
      } catch (e) {
        if (e.toString().contains('SocketException')) {
          // return CurrentState.network;
          errorSnackBar(
              context: context, title: transH.error, message: transH.network);
        }
        errorSnackBar(
            context: context, title: transH.error, message: transH.unkownError);
      }
      ref.read(recentLoadingProvider.notifier).change(false);
    }
  }

  Future<void> deleteRecord(String recordType, UserRecord record) async {
    if (await isOnline()) {
      final transH = AppLocalizations.of(context)!;
      ref.read(isLoadingProvider.notifier).change(true);

      try {
        // Code Area
        final accessToken = await utitlityController.getData('access_token');

        String date = DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now());
        final response = await http.delete(
            Uri.parse('$domainPortion/api/record/$recordType/${record.id}/'),
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            },
            body: {
              'date_paid': date
            });

        var statusCode = response.statusCode;
        if (statusCode == 401) {
          utitlityController.writeData('needsLogOut', 'true');
          navigateReplacementNamed(context, AppRoutes.loginRoute);
        } else if (statusCode == 200 || statusCode == 201) {
          await onLoadData();
          successSnackBar(
            title: transH.success.capitalizeFirst.toString(),
            message:
                "${transH.record} ${transH.deleted}".capitalizeFirst.toString(),
          );
          Navigator.of(context).pop();
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
            title: transH.error.capitalizeFirst.toString(),
            message: transH.unkownError.capitalizeFirst.toString());
      }
      ref.read(isLoadingProvider.notifier).change(false);
    }
  }
}
