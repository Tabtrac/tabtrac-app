import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DebtRecord {
  final double amount;
  final DateTime dateCreated;

  DebtRecord({required this.amount, required this.dateCreated});
}

class StatisticScreen extends ConsumerStatefulWidget {
  const StatisticScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StatisticScreenState();
}

class _StatisticScreenState extends ConsumerState<StatisticScreen> {
  DateTime now = DateTime.now();
  late final List<DebtRecord> debtRecords;

  @override
  void initState() {
    super.initState();
    debtRecords.addAll([
      DebtRecord(
        amount: 100,
        dateCreated: now.subtract(
          const Duration(days: 15),
        ),
      ),
      DebtRecord(
        amount: 150,
        dateCreated: now.subtract(
          const Duration(days: 10),
        ),
      ),
      DebtRecord(
        amount: 50,
        dateCreated: now.subtract(
          const Duration(days: 5),
        ),
      ),
      DebtRecord(amount: 200, dateCreated: now),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
