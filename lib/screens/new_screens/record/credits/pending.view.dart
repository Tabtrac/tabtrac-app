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
    final pendingCreditRecords = ref.watch(pendingCreditRecordsProvider);
    if (pendingCreditRecords.isEmpty) {
      return NoActivity(width: widget.width);
    } else {
      return Column(
        children: List.generate(
          pendingCreditRecords.length,
          (index) {
            DateTime paymentDate =
                DateTime.parse(pendingCreditRecords[index].paymentDate);
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
              name: pendingCreditRecords[index].clientName,
              status: pendingCreditRecords[index].status,
              amount: pendingCreditRecords[index].amount,
              currency: pendingCreditRecords[index].currency,
              type: 'credit',
              paymentDate: pendingCreditRecords[index].paymentDate,
              isDue: isDue,
              width: widget.width,
              onTap: () {
                navigateNamed(context, AppRoutes.detailedRecord, 'credit');
                ref
                    .read(currentRecordProvider.notifier)
                    .change(pendingCreditRecords[index]);
              },
            );
          },
        ),
      );
    }
  }
}
