import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/record.model.dart';
import '../../../../providers/global.records.dart';

final currentRecordProvider =
    StateNotifierProvider<RecordNotifier, UserRecord?>((ref) {
  return RecordNotifier();
});

final debtRecordProvider =
    StateNotifierProvider<RecordNotifier, UserRecord?>((ref) {
  return RecordNotifier();
});

final creditRecordProvider =
    StateNotifierProvider<RecordNotifier, UserRecord?>((ref) {
  return RecordNotifier();
});

final allDebtRecordsProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});

final dueDebtRecordsProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});

final pendingDebtRecordsProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});

final paidDebtRecordsProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});

final allCreditRecordsProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});

final dueCreditRecordsProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});

final pendingCreditRecordsProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});

final paidCreditRecordsProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});

class IsNext extends StateNotifier<String?> {
  IsNext() : super('');

  void change(String? value) {
    state = value;
  }
}

class IntNotifier extends StateNotifier<int> {
  IntNotifier() : super(1);

  void change(int value) {
    state = value;
  }

  void increament() {
    state++;
  }
}

final nextIntProvider =
    StateNotifierProvider<IsNext, String?>((ref) {
  return IsNext();
});

final currentLoadCount =
    StateNotifierProvider<IntNotifier, int>((ref) {
  return IntNotifier();
});

final infiniteRecordListProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});


class BoolStateNotifier extends StateNotifier<bool> {
  BoolStateNotifier(): super(false);
  
  void change(bool value){
    state = value;
  }
}

final isLoadingProvider = StateNotifierProvider.autoDispose<BoolStateNotifier, bool>((ref) {
  return BoolStateNotifier();
});

final markAsPaidProvider = StateNotifierProvider.autoDispose<BoolStateNotifier, bool>((ref) {
  return BoolStateNotifier();
});