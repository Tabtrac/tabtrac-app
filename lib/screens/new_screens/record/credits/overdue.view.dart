import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundz_app/widgets/no_activity.dart';

import '../../../../constants/app_routes.dart';
import '../../../../helpers/functions.dart';
import '../../../../widgets/activity.widget.dart';
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
    final dueCreditRecords = ref.watch(dueCreditRecordsProvider);
    if (dueCreditRecords.isEmpty) {
      return NoActivity(width: widget.width);
    } else {
      return Column(
        children: List.generate(
          dueCreditRecords.length,
          (index) {
            DateTime paymentDate =
                DateTime.parse(dueCreditRecords[index].paymentDate);
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
              name: dueCreditRecords[index].clientName,
              status: dueCreditRecords[index].status,
              amount: dueCreditRecords[index].amount,
              currency: dueCreditRecords[index].currency,
              type: 'credit',
              paymentDate: dueCreditRecords[index].paymentDate,
              isDue: isDue,
              width: widget.width,
              onTap: () {
                navigateNamed(context, AppRoutes.detailedRecord, 'credit');
                ref
                    .read(currentRecordProvider.notifier)
                    .change(dueCreditRecords[index]);
              },
            );
          },
        ),
      );
    }
  }
}
