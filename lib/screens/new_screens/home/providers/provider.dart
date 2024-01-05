import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/record.model.dart';
import '../../../../providers/global.records.dart';
import '../models/overview.model.dart';

enum CurrencyList { naira, cfa, rands, dollar }

enum CurrentState { done, none, error, network }

class OverviewDataNotifier extends StateNotifier<OverviewData?> {
  OverviewDataNotifier() : super(null);

  void setData(OverviewData data) {
    state = data;
  }
}

class CurrentHeroCurrency extends StateNotifier<CurrencyList> {
  CurrentHeroCurrency() : super(CurrencyList.naira);

  void change(CurrencyList data) {
    state = data;
  }
}

class HeroWidgetsNotifier extends StateNotifier<List<Widget>> {
  HeroWidgetsNotifier() : super([const SizedBox()]);

  void change(List<Widget> data) {
    state = data;
  }
}

final overviewDataProvider =
    StateNotifierProvider<OverviewDataNotifier, OverviewData?>((ref) {
  return OverviewDataNotifier();
});

final currentHeroCurrencyProvider =
    StateNotifierProvider<CurrentHeroCurrency, CurrencyList>((ref) {
  return CurrentHeroCurrency();
});
final heroWidgetsProvider =
    StateNotifierProvider<HeroWidgetsNotifier, List<Widget>>((ref) {
  return HeroWidgetsNotifier();
});

final recentDebtRecordProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});

final recentCreditRecordProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});


class BoolStateNotifier extends StateNotifier<bool> {
  BoolStateNotifier(): super(true);
  
  void change(bool value){
    state = value;
  }
}

final recentLoadingProvider = StateNotifierProvider<BoolStateNotifier, bool>((ref) {
  return BoolStateNotifier();
});