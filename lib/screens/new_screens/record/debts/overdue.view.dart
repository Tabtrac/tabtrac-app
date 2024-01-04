import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/app_routes.dart';
import '../../../../helpers/functions.dart';
import '../../../../widgets/activity.widget.dart';
import '../../../../widgets/no_activity.dart';
import '../providers/record.provider.dart';

class OverdueView extends ConsumerStatefulWidget {
  final double width;
  const OverdueView({super.key, required this.width});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OverdueViewState();
}

class _OverdueViewState extends ConsumerState<OverdueView> {
  @override
  Widget build(BuildContext context) {
    final dueDebtRecords = ref.watch(dueDebtRecordsProvider);
    if (dueDebtRecords.isEmpty) {
      return NoActivity(width: widget.width);
    } else {
      return Column(
        children: List.generate(
          dueDebtRecords.length,
          (index) {
            DateTime paymentDate =
                DateTime.parse(dueDebtRecords[index].paymentDate);
            DateTime now = DateTime.now();
            bool isDue;
            if (paymentDate.isAfter(now)) {
              isDue = false;
            } else if (paymentDate.isBefore(now)) {
              isDue = true;
            } else {
              isDue = false;
            }
            return ActivityWidget(
              name: dueDebtRecords[index].clientName,
              status: dueDebtRecords[index].status,
              amount: dueDebtRecords[index].amount,
              currency: dueDebtRecords[index].currency,
              type: 'debt',
              paymentDate: dueDebtRecords[index].paymentDate,
              isDue: isDue,
              width: widget.width,
              onTap: () {
                navigateNamed(context, AppRoutes.detailedRecord, 'debt');
                ref
                    .read(currentRecordProvider.notifier)
                    .change(dueDebtRecords[index]);
              },
            );
          },
        ),
      );
    }
  }
}
