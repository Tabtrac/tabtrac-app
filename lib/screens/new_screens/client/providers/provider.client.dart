import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/record.model.dart';
import '../../../../providers/global.records.dart';
import '../models/client.model.dart';

class ClientNotifier extends StateNotifier<Client?> {
  ClientNotifier() : super(null);

  void change(Client? client) {
    state = client;
  }
}

class ClientListNotifier extends StateNotifier<List<Client>> {
  ClientListNotifier() : super([]);

  void change(List<Client> client) {
    state = client;
  }
}

class StringStateNotifier extends StateNotifier<String> {
  StringStateNotifier() : super('');

  void change(String string) {
    state = string;
  }
}

class BoolStateNotifier extends StateNotifier<bool> {
  BoolStateNotifier() : super(false);

  void change(bool string) {
    state = string;
  }
}

final clientListProvider =
    StateNotifierProvider<ClientListNotifier, List<Client>>((ref) {
  return ClientListNotifier();
});

final searchedClientListProvider =
    StateNotifierProvider.autoDispose<ClientListNotifier, List<Client>>((ref) {
  return ClientListNotifier();
});

final searchStringProvider =
    StateNotifierProvider<StringStateNotifier, String>((ref) {
  return StringStateNotifier();
});

final isSearchingProvider =
    StateNotifierProvider.autoDispose<BoolStateNotifier, bool>((ref) {
  return BoolStateNotifier();
});

final lastCreatedClientProvider =
    StateNotifierProvider.autoDispose<ClientNotifier, Client?>((ref) {
  return ClientNotifier();
});

final clientDebtRecordProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});

final clientCreditRecordProvider =
    StateNotifierProvider<RecordListNotifier, List<UserRecord>>((ref) {
  return RecordListNotifier();
});

final currentCleintDetailsProvider =
    StateNotifierProvider.autoDispose<ClientNotifier, Client?>((ref) {
  return ClientNotifier();
});

final isDeletingProvider =
    StateNotifierProvider.autoDispose<BoolStateNotifier, bool>((ref) {
  return BoolStateNotifier();
});


class ShimmerBoolStateNotifier extends StateNotifier<bool> {
  ShimmerBoolStateNotifier(): super(true);
  
  void change(bool value){
    state = value;
  }
}

final clientLoadingProvider = StateNotifierProvider.autoDispose<ShimmerBoolStateNotifier, bool>((ref) {
  return ShimmerBoolStateNotifier();
});

final allClientLoadingProvider = StateNotifierProvider<ShimmerBoolStateNotifier, bool>((ref) {
  return ShimmerBoolStateNotifier();
});