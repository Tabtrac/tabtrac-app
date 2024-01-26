import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/colors.dart';
import '../../../../helpers/app_fonts.dart';
import '../../../../helpers/functions.dart';
import '../../../../providers/providers.dart';
import '../../../../widgets/widgets.utils.dart';

class HeroCard extends ConsumerWidget {
  final String totalAmount;
  final String currency;
  final String dueAmount;
  final String pendingAmount;
  final String messae;
  final double width;
  const HeroCard({
    super.key,
    required this.currency,
    required this.totalAmount,
    required this.dueAmount,
    required this.pendingAmount,
    required this.messae,
    required this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transH = AppLocalizations.of(context)!;
    final amountObsecure = ref.watch(amountObsecureNotifierProvider);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/vector.png',
              ),
            ),
            Positioned(
              top: 10.0,
              left: 10.0,
              child: IconButton(
                onPressed: () {
                  AppWidgetsUtlis.homeCurrencyPicker(context);
                },
                icon: const Icon(
                  Icons.currency_exchange_rounded,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            Positioned(
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: width,
                    child: Column(
                      children: <Widget>[
                        Text(
                          messae,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              moneyCommaTwo(totalAmount,
                                  currency: currency, obSecure: amountObsecure),
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 34.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(
                                        amountObsecureNotifierProvider.notifier)
                                    .change(!amountObsecure);
                              },
                              icon: Icon(
                                !amountObsecure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            transH.overdue.capitalizeFirst.toString(),
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14.sp,
                              fontFamily: AppFonts.actionFont,
                            ),
                          ),
                          Text(
                            moneyCommaTwo(dueAmount,
                                currency: currency, obSecure: amountObsecure),
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            transH.pending.capitalizeFirst.toString(),
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14.sp,
                              fontFamily: AppFonts.actionFont,
                            ),
                          ),
                          Text(
                            moneyCommaTwo(pendingAmount,
                                currency: currency, obSecure: amountObsecure),
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
