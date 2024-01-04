import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_provider_controllers.dart';
import '../controllers/debt_provider_controllers.dart';
import '../controllers/liability_provider_controller.dart';
import '../controllers/user_provider_controller.dart';
import '../controllers/utl_provider_controllers.dart';
import '../models/debt.dart';
import '../models/liability.dart';
import 'debt_provider.dart';
import 'language_provider_controller.dart';
import 'liability_provider.dart';
import 'theme_provider.dart';
import 'utl_state_notifier_providers.dart';

final isDarkModeProvider =
    StateNotifierProvider<ThemeState, bool>((ref) => ThemeState());

final obSecureProvider =
    StateNotifierProvider.autoDispose<ObecureNotifier, bool>((ref) {
  return ObecureNotifier();
});

final dataFetchControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue>(
  (ref) => AuthController(),
);
final utlControllerProvider =
    StateNotifierProvider<UtlControllerNotifier, AsyncValue>(
  (ref) => UtlControllerNotifier(),
);

final debtControllerProvider =
    StateNotifierProvider<DebtsController, AsyncValue>(
  (ref) => DebtsController(),
);
final liabilityControllerControllerProvider =
    StateNotifierProvider<LiabilityController, AsyncValue>(
  (ref) => LiabilityController(),
);

final userControllerProvider =
    StateNotifierProvider<UserController, AsyncValue>(
  (ref) => UserController(),
);

final currentIndexProvider =
    StateNotifierProvider.autoDispose<CurrentIndexNotifier, int>((ref) {
  return CurrentIndexNotifier();
});

final buttonLoadingNotifierProvider =
    StateNotifierProvider.autoDispose<ButtonLoadingNotifier, bool>((ref) {
  return ButtonLoadingNotifier();
});

// Debt State Notifier
final debtNotifierProvider = StateNotifierProvider<DebtNotifier, Debt>((ref) {
  return DebtNotifier();
});

// Liability state notifier
final liabilityNotifierProvider =
    StateNotifierProvider<LiabilityNotifier, Liability>((ref) {
  return LiabilityNotifier();
});

final editEebtNotifierProvider =
    StateNotifierProvider<DebtNotifier, Debt>((ref) {
  return DebtNotifier();
});
final ediLiabilityNotifierProvider =
    StateNotifierProvider<LiabilityNotifier, Liability>((ref) {
  return LiabilityNotifier();
});
final languageNotifierProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

final fieldOneControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);
final fieldTwoControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);
final fieldThreeControllerProvider =
    Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);
final fieldFourControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);

final currencyNotifierProvider =
    StateNotifierProvider<CurrenciesNotifier, String>((ref) {
  return CurrenciesNotifier();
});

final currentPageProvider =
    StateNotifierProvider<CurrentPageNotifier, int>((ref) {
  return CurrentPageNotifier();
});

class CurrentPageNotifier extends StateNotifier<int> {
  CurrentPageNotifier() : super(0);

  void changePage(int page) {
    state = page;
  }
}

final viewControllerProvider =
    StateNotifierProvider<ViewControlllerNotifier, int>((ref) {
  return ViewControlllerNotifier();
});

final amountObsecureNotifierProvider =
    StateNotifierProvider<AmountObsecureNotifier, bool>((ref) {
  return AmountObsecureNotifier();
});

final craeteScreenTypeNotifierProvider =
    StateNotifierProvider<CreateScreenTypeNotifier, String>((ref) {
  return CreateScreenTypeNotifier();
});

// current view Type

class CurrentTabNotifier extends StateNotifier<String> {
  CurrentTabNotifier() : super('debt');

  void change(String tabName) {
    state = tabName;
  }
}

final currentRecordTypeProvider = StateNotifierProvider<CurrentTabNotifier, String>((ref) {
  return CurrentTabNotifier();
});