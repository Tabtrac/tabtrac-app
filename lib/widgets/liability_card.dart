import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/colors.dart';
import '../helpers/functions.dart';
import '../providers/providers.dart';

class LiabilityCard extends ConsumerStatefulWidget {
  final double width;
  final double height;
  final String name;
  final String description;
  final String amount;
  final String dateCreated;
  final String status;
  final String timeago;
  final String debtId;
  final String currency;
  const LiabilityCard({
    super.key,
    required this.width,
    required this.name,
    required this.description,
    required this.amount,
    required this.dateCreated,
    required this.status,
    required this.timeago,
    required this.height,
    required this.debtId,
    required this.currency,
  });

  @override
  ConsumerState<LiabilityCard> createState() => _LiabilityCardState();
}

class _LiabilityCardState extends ConsumerState<LiabilityCard> {
 
  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;

    final isDarkMode = ref.watch(isDarkModeProvider);
    Locale currentLocale = getCurrentLocale(context);
    return InkWell(
      // onTap: () => Get.toNamed(AppRoutes.debtDetailRoute + widget.debtId),
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color:
              isDarkMode ? AppColors.darkThemeShade : AppColors.lightThemeShade,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: widget.width * .4),
                  child: Text(
                    widget.name.toString().capitalize(),
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1.0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Ionicons.time_outline,
                      size: 16.sp,
                    ),
                    SizedBox(width: widget.width * .02),
                    Text(
                      widget.timeago,
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: widget.height * .02),
            if (widget.amount.length > 9)
              SizedBox(
                width: widget.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: widget.width * .5),
                      child: Text(
                        "${transH.youOwe.capitalizeFirst} ${widget.name}",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                    Text(
                      moneyComma(widget.amount, widget.currency),
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: widget.width * .5),
                    child: Text(
                      "${transH.youOwe.capitalizeFirst} ${widget.name}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                  Text(
                    moneyComma(widget.amount, widget.currency),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            SizedBox(height: widget.height * .01),
            Container(
              width: widget.width,
              constraints: BoxConstraints(maxHeight: widget.height * .15),
              child: Text(
                widget.description.capitalize(),
                style: TextStyle(
                  fontSize: 14.sp,
                ),
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.0,
                maxLines: 5,
              ),
            ),
            SizedBox(height: widget.height * .01),
            SizedBox(
              width: widget.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${transH.status}: ${widget.status}".toUpperCase(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    textScaleFactor: 1.0,
                  ),
                  Text(
                    "${transH.purchasedAt} ${regularDateFormat(DateTime.parse(widget.dateCreated), currentLocale.toString())}"
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            ),
            SizedBox(height: widget.height * .01),
          ],
        ),
      ),
    );
  }
}
