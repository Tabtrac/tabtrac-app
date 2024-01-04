import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/app_routes.dart';
import '../../../../helpers/functions.dart';
import '../../../../widgets/activity.widget.dart';
import '../../../../widgets/no_activity.dart';
import '../providers/record.provider.dart';

class PaidView extends ConsumerStatefulWidget {
  final double width;
  const PaidView({super.key, required this.width});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaidViewState();
}

class _PaidViewState extends ConsumerState<PaidView> {
  @override
  Widget build(BuildContext context) {
    final paidCreditRecords = ref.watch(paidCreditRecordsProvider);
    if (paidCreditRecords.isEmpty) {
      return NoActivity(width: widget.width);
    } else {
      return Column(
        children: List.generate(
          paidCreditRecords.length,
          (index) {
            DateTime paymentDate =
                DateTime.parse(paidCreditRecords[index].paymentDate);
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
              name: paidCreditRecords[index].clientName,
              status: paidCreditRecords[index].status,
              amount: paidCreditRecords[index].amount,
              currency: paidCreditRecords[index].currency,
              type: 'credit',
              paymentDate: paidCreditRecords[index].paymentDate,
              isDue: isDue,
              width: widget.width,
              onTap: () {
                navigateNamed(context, AppRoutes.detailedRecord, 'credit');
                ref
                    .read(currentRecordProvider.notifier)
                    .change(paidCreditRecords[index]);
              },
            );
          },
        ),
      );
    }
  }
}
