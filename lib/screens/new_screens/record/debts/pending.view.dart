import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/app_routes.dart';
import '../../../../helpers/functions.dart';
import '../../../../widgets/activity.widget.dart';
import '../../../../widgets/no_activity.dart';
import '../providers/record.provider.dart';

class PendingView extends ConsumerStatefulWidget {
  final double width;
  const PendingView({super.key, required this.width});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PendingViewState();
}

class _PendingViewState extends ConsumerState<PendingView> {
  @override
  Widget build(BuildContext context) {
    final pendingDebtRecords = ref.watch(pendingDebtRecordsProvider);
    if (pendingDebtRecords.isEmpty) {
      return NoActivity(width: widget.width);
    } else {
      return Column(
        children: List.generate(
          pendingDebtRecords.length,
          (index) {
            DateTime paymentDate =
                DateTime.parse(pendingDebtRecords[index].paymentDate);
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
              name: pendingDebtRecords[index].clientName,
              status: pendingDebtRecords[index].status,
              amount: pendingDebtRecords[index].amount,
              currency: pendingDebtRecords[index].currency,
              type: 'debt',
              paymentDate: pendingDebtRecords[index].paymentDate,
              isDue: isDue,
              width: widget.width,
              onTap: () {
                navigateNamed(context, AppRoutes.detailedRecord, 'debt');
                ref
                    .read(currentRecordProvider.notifier)
                    .change(pendingDebtRecords[index]);
              },
            );
          },
        ),
      );
    }
  }
}
