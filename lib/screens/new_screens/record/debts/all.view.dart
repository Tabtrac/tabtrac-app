import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/app_routes.dart';
import '../../../../helpers/functions.dart';
import '../../../../widgets/activity.widget.dart';
import '../providers/record.provider.dart';

class AllDebtView extends ConsumerStatefulWidget {
  final double width;
  const AllDebtView({super.key, required this.width});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllDebtViewState();
}

class _AllDebtViewState extends ConsumerState<AllDebtView> {
  @override
  Widget build(BuildContext context) {
    final allDebtRecords = ref.watch(allDebtRecordsProvider);
    return Column(
      children: List.generate(
        allDebtRecords.length,
        (index) {
          DateTime paymentDate =
                DateTime.parse(allDebtRecords[index].paymentDate);
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
            name: allDebtRecords[index].clientName,
            status: allDebtRecords[index].status,
            amount: allDebtRecords[index].amount,
            currency: allDebtRecords[index].currency,
            type: 'debt',
            paymentDate: allDebtRecords[index].paymentDate,
            isDue: isDue,
            width: widget.width,
            onTap: () {
              navigateNamed(context, AppRoutes.detailedRecord, 'debt');
              ref.read(currentRecordProvider.notifier).change(allDebtRecords[index]);
            },
          );
        },
      ),
    );
  }
}
