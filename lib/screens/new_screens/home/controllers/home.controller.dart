// ignore_for_file: use_build_context_synchronously, avoid_print


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../controllers/utl_controllers.dart';
import '../models/overview.model.dart';
import '../providers/provider.dart';
import '../widgets/hero_card.dart';

class HomeController {
  final WidgetRef ref;
  final BuildContext context;

  HomeController({required this.ref, required this.context});
  UtitlityController utitlityController = UtitlityController();

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
