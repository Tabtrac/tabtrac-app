// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/app_routes.dart';
import '../../../../constants/urls.dart';
import '../../../../controllers/utl_controllers.dart';
import '../../../../models/record.model.dart';
import '../../../../widgets/snackbars.dart';
import '../models/overview.model.dart';
import '../providers/provider.dart';
import '../widgets/hero_card.dart';

class HomeController {
  final WidgetRef ref;
  final BuildContext context;

  HomeController({required this.ref, required this.context});
  UtitlityController utitlityController = UtitlityController();
  Future getOverviewData() async {
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
        ref.read(overviewDataProvider.notifier).setData(data);
        // return CurrentState.done;
      } else {
        errorSnackBar(
            context: context, title: transH.error, message: transH.unkownError);
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

  List<Widget> getHeroWidgets(AppLocalizations transH, double width) {
    OverviewData? overviewData = ref.watch(overviewDataProvider);
    CurrencyList currentHeroCurrency = ref.watch(currentHeroCurrencyProvider);
    List<Widget> heroWidgets = [];
    switch (currentHeroCurrency) {
      case CurrencyList.naira:
        if (overviewData != null) {
          heroWidgets.addAll([
            HeroCard(
              currency: 'naira',
              totalAmount: overviewData.debt.naira.all.toString(),
              dueAmount: overviewData.debt.naira.due.toString(),
              pendingAmount: overviewData.debt.naira.pending.toString(),
              messae: transH.debtTotal,
              width: width,
            ),
            HeroCard(
              currency: 'naira',
              totalAmount: overviewData.credit.naira.all.toString(),
              dueAmount: overviewData.credit.naira.due.toString(),
              pendingAmount: overviewData.credit.naira.pending.toString(),
              messae: transH.creditTotal,
              width: width,
            ),
          ]);
        } else {
          heroWidgets.addAll([
            HeroCard(
              currency: 'naira',
              totalAmount: '0.00',
              dueAmount: '0.00',
              pendingAmount: '0.00',
              messae: transH.debtTotal,
              width: width,
            ),
            HeroCard(
              currency: 'naira',
              totalAmount: '0.00',
              dueAmount: '0.00',
              pendingAmount: '0.00',
              messae: transH.creditTotal,
              width: width,
            ),
          ]);
        }
        break;
      case CurrencyList.dollar:
        if (overviewData != null) {
          heroWidgets.addAll([
            HeroCard(
              currency: 'dollar',
              totalAmount: overviewData.debt.dollar.all.toString(),
              dueAmount: overviewData.debt.dollar.due.toString(),
              pendingAmount: overviewData.debt.dollar.pending.toString(),
              messae: transH.debtTotal,
              width: width,
            ),
            HeroCard(
              currency: 'dollar',
              totalAmount: overviewData.credit.dollar.all.toString(),
              dueAmount: overviewData.credit.dollar.due.toString(),
              pendingAmount: overviewData.credit.dollar.pending.toString(),
              messae: transH.creditTotal,
              width: width,
            ),
          ]);
        } else {
          heroWidgets.addAll([
            HeroCard(
              currency: 'dollar',
              totalAmount: '0.00',
              dueAmount: '0.00',
              pendingAmount: '0.00',
              messae: transH.debtTotal,
              width: width,
            ),
            HeroCard(
              currency: 'dollar',
              totalAmount: '0.00',
              dueAmount: '0.00',
              pendingAmount: '0.00',
              messae: transH.creditTotal,
              width: width,
            ),
          ]);
        }
        break;
      case CurrencyList.rands:
        if (overviewData != null) {
          heroWidgets.addAll([
            HeroCard(
              currency: 'rands',
              totalAmount: overviewData.debt.rands.all.toString(),
              dueAmount: overviewData.debt.rands.due.toString(),
              pendingAmount: overviewData.debt.rands.pending.toString(),
              messae: transH.debtTotal,
              width: width,
            ),
            HeroCard(
              currency: 'rands',
              totalAmount: overviewData.credit.rands.all.toString(),
              dueAmount: overviewData.credit.rands.due.toString(),
              pendingAmount: overviewData.credit.rands.pending.toString(),
              messae: transH.creditTotal,
              width: width,
            ),
          ]);
        } else {
          heroWidgets.addAll([
            HeroCard(
              currency: 'rands',
              totalAmount: '0.00',
              dueAmount: '0.00',
              pendingAmount: '0.00',
              messae: transH.debtTotal,
              width: width,
            ),
            HeroCard(
              currency: 'rands',
              totalAmount: '0.00',
              dueAmount: '0.00',
              pendingAmount: '0.00',
              messae: transH.creditTotal,
              width: width,
            ),
          ]);
        }
        break;
      case CurrencyList.cfa:
        if (overviewData != null) {
          heroWidgets.addAll([
            HeroCard(
              currency: 'cfa',
              totalAmount: overviewData.debt.cfa.all.toString(),
              dueAmount: overviewData.debt.cfa.due.toString(),
              pendingAmount: overviewData.debt.cfa.pending.toString(),
              messae: transH.debtTotal,
              width: width,
            ),
            HeroCard(
              currency: 'cfa',
              totalAmount: overviewData.credit.cfa.all.toString(),
              dueAmount: overviewData.credit.cfa.due.toString(),
              pendingAmount: overviewData.credit.cfa.pending.toString(),
              messae: transH.creditTotal,
              width: width,
            ),
          ]);
        } else {
          heroWidgets.addAll([
            HeroCard(
              currency: 'cfa',
              totalAmount: '0.00',
              dueAmount: '0.00',
              pendingAmount: '0.00',
              messae: transH.debtTotal,
              width: width,
            ),
            HeroCard(
              currency: 'cfa',
              totalAmount: '0.00',
              dueAmount: '0.00',
              pendingAmount: '0.00',
              messae: transH.creditTotal,
              width: width,
            ),
          ]);
        }
        break;
      default:
        if (overviewData != null) {
          heroWidgets.addAll([
            HeroCard(
              currency: 'naira',
              totalAmount: overviewData.debt.naira.all.toString(),
              dueAmount: overviewData.debt.naira.due.toString(),
              pendingAmount: overviewData.debt.naira.pending.toString(),
              messae: transH.debtTotal,
              width: width,
            ),
            HeroCard(
              currency: 'naira',
              totalAmount: overviewData.credit.naira.all.toString(),
              dueAmount: overviewData.credit.naira.due.toString(),
              pendingAmount: overviewData.credit.naira.pending.toString(),
              messae: transH.creditTotal,
              width: width,
            ),
          ]);
        } else {
          heroWidgets.addAll([
            HeroCard(
              currency: 'naira',
              totalAmount: '0.00',
              dueAmount: '0.00',
              pendingAmount: '0.00',
              messae: transH.debtTotal,
              width: width,
            ),
            HeroCard(
              currency: 'naira',
              totalAmount: '****',
              dueAmount: '****',
              pendingAmount: '****',
              messae: transH.creditTotal,
              width: width,
            ),
          ]);
        }
    }
    return heroWidgets;
  }

}
