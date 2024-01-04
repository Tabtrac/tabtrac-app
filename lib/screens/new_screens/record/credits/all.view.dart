import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/app_routes.dart';
import '../../../../helpers/functions.dart';
import '../../../../widgets/activity.widget.dart';
import '../providers/record.provider.dart';

class AllCreditView extends ConsumerStatefulWidget {
  final double width;
  const AllCreditView({super.key, required this.width});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllCreditViewState();
}

class _AllCreditViewState extends ConsumerState<AllCreditView> {
  @override
  Widget build(BuildContext context) {
    final allCreditRecords = ref.watch(allCreditRecordsProvider);
    return Column(
      children: List.generate(
        allCreditRecords.length,
        (index) {
          DateTime paymentDate =
              DateTime.parse(allCreditRecords[index].paymentDate);
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
            name: allCreditRecords[index].clientName,
            status: allCreditRecords[index].status,
            amount: allCreditRecords[index].amount,
            currency: allCreditRecords[index].currency,
            type: 'credit',
            paymentDate: allCreditRecords[index].paymentDate,
            isDue: isDue,
            width: widget.width,
            onTap: () {
              navigateNamed(context, AppRoutes.detailedRecord, 'credit');
              ref
                  .read(currentRecordProvider.notifier)
                  .change(allCreditRecords[index]);
            },
          );
        },
      ),
    );
  }
}
