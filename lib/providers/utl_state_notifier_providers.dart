import 'package:flutter_riverpod/flutter_riverpod.dart';


class ObecureNotifier extends StateNotifier<bool> {
  ObecureNotifier() : super(true);

  void changeState(bool stateValue) {
    state = stateValue;
  }
}

class CurrentIndexNotifier extends StateNotifier<int> {
  CurrentIndexNotifier() : super(0);
  void changeIndex(int index) {
    state = index;
  }
}

// Button State Notifier
class ButtonLoadingNotifier extends StateNotifier<bool> {
  ButtonLoadingNotifier() : super(false);
  void changeIndex(bool index) {
    state = index;
  }
}

class CurrenciesNotifier extends StateNotifier<String> {
  CurrenciesNotifier() : super('naira');
  void changeSelectedIndex(String index) {
    state = index;
  }
}

class AmountObsecureNotifier extends StateNotifier<bool> {
  AmountObsecureNotifier() : super(false);

  void change(bool value) {
    state = value;
  }
}
class CreateScreenTypeNotifier extends StateNotifier<String> {
  CreateScreenTypeNotifier() : super('debt');

  void change(String value) {
    state = value;
  }
}
