import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/liability.dart';

class LiabilityNotifier extends StateNotifier<Liability> {
  LiabilityNotifier()
      : super(
          Liability(
            id: '1',
            creditorName: 'John Doe',
            status: 'Pending',
            currency: 'dollar',
            description: 'Sample debt',
            amount: '100',
            paymentDate: '2023-11-17',
            createdDate: '2023-11-17',
            updatedDate: '2023-11-17',
            user: 'user123',
          ),
        );

  void changeValues(Liability liability) {
    state = liability;
  }
}
