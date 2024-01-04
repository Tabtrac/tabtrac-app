import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/app_routes.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/activity.widget.dart';
import '../../record/providers/record.provider.dart';
import '../providers/provider.dart';

class RecentActivities extends ConsumerStatefulWidget {
  final double width;
  const RecentActivities({super.key, required this.width});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecentActivitiesState();
}

class _RecentActivitiesState extends ConsumerState<RecentActivities> {
  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    final recentDebtRecord = ref.watch(recentDebtRecordProvider);
    final recentCreditRecord = ref.watch(recentCreditRecordProvider);
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (recentDebtRecord.isEmpty)
            const SizedBox()
          else
            Text(
              transH.debt.capitalize(),
              style: TextStyle(
                color: AppColors.greyColor,
                fontSize: 14.sp,
              ),
            ),
          Column(
            children: List.generate(
              recentDebtRecord.length,
              (index) {
                DateTime paymentDate =
                    DateTime.parse(recentDebtRecord[index].paymentDate);
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
                  name: recentDebtRecord[index].clientName,
                  status: recentDebtRecord[index].status,
                  amount: recentDebtRecord[index].amount,
                  currency: recentDebtRecord[index].currency,
                  type: 'debt',
                  paymentDate: recentDebtRecord[index].paymentDate,
                  isDue: isDue,
                  width: widget.width,
                  onTap: () {
                    navigateNamed(context, AppRoutes.detailedRecord, 'debt');
                    ref
                        .read(currentRecordProvider.notifier)
                        .change(recentDebtRecord[index]);
                  },
                );
              },
            ),
          ).animate().fade(delay: 400.ms),
          SizedBox(height: 10.h),
          if (recentCreditRecord.isEmpty)
            const SizedBox()
          else
            Text(
              transH.credit.capitalize(),
              style: TextStyle(
                color: AppColors.greyColor,
                fontSize: 14.sp,
              ),
            ),
          Column(
            children: List.generate(
              recentCreditRecord.length,
              (index) {
                DateTime paymentDate =
                    DateTime.parse(recentCreditRecord[index].paymentDate);
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
                  name: recentCreditRecord[index].clientName,
                  status: recentCreditRecord[index].status,
                  amount: recentCreditRecord[index].amount,
                  currency: recentCreditRecord[index].currency,
                  type: 'credit',
                  paymentDate: recentCreditRecord[index].paymentDate,
                  isDue: isDue,
                  width: widget.width,
                  onTap: () {
                    navigateNamed(context, AppRoutes.detailedRecord, 'credit');
                    ref
                        .read(currentRecordProvider.notifier)
                        .change(recentCreditRecord[index]);
                  },
                );
              },
            ),
          ).animate().fade(delay: 500.ms),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
