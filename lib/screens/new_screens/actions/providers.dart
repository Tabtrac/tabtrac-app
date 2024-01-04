// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:fundz_app/widgets/snackbars.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/providers.dart';
import '../../../providers/textfield_providers.dart';
import '../client/models/client.model.dart';
import 'controllers/action.controller.dart';
import 'providers/actions.provider.dart';

final currentStageProvider =
    StateNotifierProvider.autoDispose<CurrentStageNotifier, int>((ref) {
  return CurrentStageNotifier();
});

class CurrentStageNotifier extends StateNotifier<int> {
  CurrentStageNotifier() : super(1);

  void change(int stage) {
    state = stage;
  }

  Future<bool> addStage(
    BuildContext context,
    AppLocalizations transH,
    WidgetRef ref,
    int currentStage, {
    required String name,
    required Client? client,
    required String phoneNumber,
    required String email,
    required String description,
    required String paymentDate,
    required String currency,
    required String amounth,
    required String currentPage,
  }) async {
    if (currentStage == 1) {
      if (client == null) {
        errorSnackBar(
          context: context,
          title: transH.error.capitalize(),
          message: transH.pleaseSelectClient.capitalize(),
        );
        return false;
      } else {
        state = 2;
        return true;
      }
    } else if (currentStage == 2) {
      if (paymentDate.isEmpty || amounth.isEmpty) {
        errorSnackBar(
          context: context,
          title: transH.error.capitalize(),
          message: transH.fieldsRequired.capitalize(),
        );
        return false;
      } else {
        if (amounth.isPriceValid()) {
          state = 3;
          return true;
        } else {
          errorSnackBar(
            context: context,
            title: transH.error.capitalize(),
            message: transH.invalidPrice.capitalize(),
          );
          return false;
        }
      }
    } else {
      if (description.isEmpty) {
        errorSnackBar(
          context: context,
          title: transH.error.capitalize(),
          message: transH.fieldsRequired.capitalize(),
        );
        return false;
      } else {
        if (ref.read(buttonLoadingNotifierProvider) == false) {
          ref.read(buttonLoadingNotifierProvider.notifier).changeIndex(true);
          ActionController actionController =
              ActionController(context: context, ref: ref);
          bool data;
          // print(currentPage);
          String paymentDateNew = ref.watch(paymentDateProvider);
          if (currentPage == 'debt') {
            data = await actionController.createRecord(
              client: client!,
              description: description,
              amount: amounth,
              currency: currency,
              paymentDate: paymentDate,
              type: 'debt',
            );
          } else {
            data = await actionController.createRecord(
              client: client!,
              description: description,
              amount: amounth,
              currency: currency,
              paymentDate: paymentDate,
              type: 'credit',
            );
          }
          if (data) {
            Navigator.pop(context);
          }
        }
      }
      return false;
    }
  }

  bool removeStage(
    BuildContext context,
    AppLocalizations transH,
    int currentStage, {
    required String name,
    required String phoneNumber,
    required String email,
    required String description,
    required String paymentDate,
    required String currency,
    required String amounth,
  }) {
    if (currentStage == 3) {
      state = 2;
      return false;
    } else if (currentStage == 2) {
      state = 1;
      return true;
    } else {
      return false;
    }
  }
}

// Text controllers
final nameControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);
final descriptionControllerProvider =
    Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);
final priceControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);
final paymentDateControllerProvider =
    StateNotifierProvider.autoDispose<TextFieldNotifier, TextEditingController>(
        (ref) {
  return TextFieldNotifier();
});
final phoneNumberControllerProvider =
    Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);
final emailControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);
