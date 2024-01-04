import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../client/models/client.model.dart';
import '../../client/providers/provider.client.dart';

class StringNotifier extends StateNotifier<String> {
  StringNotifier() : super('');
  void change(String value) {
    state = value;
  }
}

final selectedClient = StateNotifierProvider<ClientNotifier, Client?>((ref) {
  return ClientNotifier();
});

final paymentDateProvider =
    StateNotifierProvider.autoDispose<StringNotifier, String>((ref) {
  return StringNotifier();
});
