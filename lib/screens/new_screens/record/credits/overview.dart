import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/helpers/functions.dart';

import '../../../../constants/app_routes.dart';
import '../../../../constants/colors.dart';
import '../../../../helpers/app_fonts.dart';
import '../providers/record.provider.dart';
import 'all.view.dart';
import 'overdue.view.dart';
import 'paid.view.dart';
import 'pending.view.dart';

class OverViewCredit extends ConsumerWidget {
  final double width;
  const OverViewCredit({super.key, required this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transH = AppLocalizations.of(context)!;
    final allCreditRecords = ref.watch(allCreditRecordsProvider);
    final dueCreditRecords = ref.watch(dueCreditRecordsProvider);
    final pendingCreditRecords = ref.watch(pendingCreditRecordsProvider);
    final paidCreditRecords = ref.watch(paidCreditRecordsProvider);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              transH.all.capitalizeAll(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.actionFont,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (allCreditRecords.length < 3)
              const SizedBox()
            else
              TextButton(
                onPressed: () {
                  navigateNamed(context, AppRoutes.infiniteRecord,
                      {'type': 'credit', 'section': 'all'});
                },
                child: Text(
                  transH.seeAll,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.greyColor,
                    fontFamily: AppFonts.actionFont,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        AllCreditView(
          width: width,
        ).animate().fade(delay: 400.ms),
        // Overdue
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              transH.overdue.capitalizeAll(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.actionFont,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (dueCreditRecords.length < 3)
              const SizedBox()
            else
              TextButton(
                onPressed: () {
                  navigateNamed(context, AppRoutes.infiniteRecord,
                      {'type': 'credit', 'section': 'due'});
                },
                child: Text(
                  transH.seeAll,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.greyColor,
                    fontFamily: AppFonts.actionFont,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        OverdueView(
          width: width,
        ).animate().fade(delay: 500.ms),
        // Pending
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              transH.pending.capitalizeAll(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.actionFont,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (pendingCreditRecords.length < 3)
              const SizedBox()
            else
              TextButton(
                onPressed: () {
                  navigateNamed(context, AppRoutes.infiniteRecord,
                      {'type': 'credit', 'section': 'pending'});
                },
                child: Text(
                  transH.seeAll,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.greyColor,
                    fontFamily: AppFonts.actionFont,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        PendingView(
          width: width,
        ).animate().fade(delay: 600.ms),
        // Paid
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              transH.paid.capitalizeAll(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.actionFont,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (paidCreditRecords.length < 3)
              const SizedBox()
            else
              TextButton(
                onPressed: () {
                  navigateNamed(context, AppRoutes.infiniteRecord,
                      {'type': 'credit', 'section': 'paid'});
                },
                child: Text(
                  transH.seeAll,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.greyColor,
                    fontFamily: AppFonts.actionFont,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        PaidView(
          width: width,
        ).animate().fade(delay: 700.ms),
      ],
    );
  }
}
