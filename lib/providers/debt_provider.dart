import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/debt.dart';

class DebtNotifier extends StateNotifier<Debt> {
  DebtNotifier()
      : super(
          Debt(
            id: '1',
            debtorName: 'John Doe',
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

  void changeValues(Debt debt) {
    state = debt;
  }
}
