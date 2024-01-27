import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:ionicons/ionicons.dart';

import '../helpers/app_fonts.dart';

class ActivityWidget extends ConsumerWidget {
  final String name;
  final String status;
  final String amount;
  final String currency;
  final String type;
  final double width;
  final bool isDue;
  final String paymentDate;
  final void Function()? onTap;
  const ActivityWidget({
    super.key,
    required this.name,
    required this.status,
    required this.amount,
    required this.currency,
    required this.type,
    required this.isDue,
    required this.paymentDate,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transH = AppLocalizations.of(context)!;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor.withOpacity(.5)),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: isTablet() ? 25.w : 35.w,
              height: isTablet() ? 25.w : 35.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(.5),
                borderRadius: BorderRadius.circular(100),
              ),
              margin: EdgeInsets.only(bottom: isTablet() ? 10 : 20.0),
              child: Text(
                name.substring(0, 1),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontFamily: AppFonts.actionFont,
                  fontSize: isTablet() ? 10.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: isTablet() ? 5.w : 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        child: type == 'debt'
                            ? Text(
                                transH.debt.toUpperCase(),
                                style: TextStyle(
                                  color: AppColors.greyColor,
                                  fontSize: isTablet() ? 6.sp : 10.sp,
                                  fontFamily: AppFonts.actionFont,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Text(
                                transH.credit.toUpperCase(),
                                style: TextStyle(
                                  color: AppColors.greyColor,
                                  fontSize: isTablet() ? 6.sp : 10.sp,
                                  fontFamily: AppFonts.actionFont,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                      Text(
                        moneyComma(amount, currency),
                        style: TextStyle(
                          fontSize: isTablet() ? 10.sp : 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                              fontFamily: AppFonts.actionFont,
                              fontSize: isTablet() ? 8.sp : 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          if (status == 'unpaid' &&
                              convertToAgo(DateTime.parse(paymentDate)) !=
                                  'pending')
                            Row(
                              children: <Widget>[
                                Icon(
                                  Ionicons.time_outline,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                  size: isTablet() ? 8.sp : 14.sp,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  convertToAgo(DateTime.parse(paymentDate)),
                                  style: TextStyle(
                                    fontSize: isTablet() ? 6.sp : 12.sp,
                                  ),
                                  textScaleFactor: 1.0,
                                )
                              ],
                            )
                          else
                            const SizedBox(),
                        ],
                      ),
                      if (status == 'unpaid')
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.unpaidShade,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          child: Text(
                            isDue
                                ? transH.overdue.capitalizeFirst.toString()
                                : transH.pending.capitalizeFirst.toString(),
                            style: TextStyle(
                              color: AppColors.unpaidColor,
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet() ? 6.sp : 12.sp,
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.paidShade,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          child: Text(
                            transH.paid.capitalizeFirst.toString(),
                            style: TextStyle(
                              color: AppColors.paidColor,
                              fontSize: isTablet() ? 6.sp : 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
