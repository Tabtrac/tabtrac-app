import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../helpers/app_enums.dart';

class UtlControllerNotifier extends StateNotifier<AsyncValue> {
  UtlControllerNotifier() : super(const AsyncValue.loading());
  final _secureStorage = const FlutterSecureStorage();
  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  // void changeLanguage(var param1, var param2) {
  //   var locale = Locale(param1, param2);
  //   MyApp.
  // }

  Future<void> setTheme(String mode) async {
    await _secureStorage.write(
      key: "theme",
      value: mode,
      aOptions: _getAndroidOptions(),
    );
  }

  writeData(String key, String value) async {
    await _secureStorage.write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
    );
  }

  deleteData(String key) async {
    await _secureStorage.delete(
      key: key,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<String?> getData(
    String key,
  ) async {
    var data = await _secureStorage.read(
      key: key,
      aOptions: _getAndroidOptions(),
    );
    return data.toString();
  }

  Future<String?> getTheme(String key) async {
    var readData =
        await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  String getCurrency(Currencies currency) {
    switch (currency) {
      case Currencies.naira:
        return "₦";
      case Currencies.dollar:
        return "\$";
      default:
        return "₦";
    }
  }
}

class ViewControllerValues {
  int currentView;

  ViewControllerValues({required this.currentView});
}

class ViewControlllerNotifier extends StateNotifier<int> {
  ViewControlllerNotifier() : super(0);

  void changeCurrentViewIndex(int index){
    state = index;
  }
}
class AuthBoolStateNotifier extends StateNotifier<bool> {
  AuthBoolStateNotifier() : super(false);

  void change(bool value) {
    state = value;
  }
}

final termsCheckedProvider =
    StateNotifierProvider.autoDispose<AuthBoolStateNotifier, bool>((ref) {
  return AuthBoolStateNotifier();
});
