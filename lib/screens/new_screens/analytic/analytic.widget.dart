import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import '../../../constants/colors.dart';
import '../../../helpers/app_fonts.dart';

class AnalyticWidget extends ConsumerStatefulWidget {
  final double width;
  final double height;
  const AnalyticWidget({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalyticWidgetState();
}

class _AnalyticWidgetState extends ConsumerState<AnalyticWidget> {
  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    return Container(
      width: widget.width,
      height: widget.height * .9,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: widget.height * .02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.width * .6),
                child: Text(
                  transH.analytic.capitalizeFirst.toString(),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.actionFont,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300.w,
                  height: 300.h,
                  child: SvgPicture.asset(
                    'assets/svgs/data.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  transH.stillUnderDevelopment.capitalizeFirst.toString(),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.actionFont,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
