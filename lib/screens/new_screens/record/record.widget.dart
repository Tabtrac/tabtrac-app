import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/colors.dart';
import '../../../helpers/app_fonts.dart';
import '../../../widgets/no_activity.dart';
import 'credits/overview.dart';
import 'debts/overview.dart';
import 'providers/record.provider.dart';
import 'widgets/tab.widget.dart';

class RecordWidget extends ConsumerStatefulWidget {
  final double width;
  final double height;
  const RecordWidget({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecordWidgetState();
}

class _RecordWidgetState extends ConsumerState<RecordWidget> {
  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    final currentTab = ref.watch(currentTabProvider);
    final allDebtRecords = ref.watch(allDebtRecordsProvider);
    final allCreditRecords = ref.watch(allCreditRecordsProvider);
    return Container(
      width: widget.width,
      height: widget.height * .9,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: widget.height * .02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.width * .6),
                child: Text(
                  transH.recordManagement.capitalizeAll(),
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
          SizedBox(height: 30.h),
          CustomTabWidget(
            width: widget.width,
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: ScreenUtil().screenHeight * .658,
            child: SingleChildScrollView(
              child: currentTab == 'debt'
                  ? allDebtRecords.isEmpty
                      ? SizedBox(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().screenHeight * .65,
                          child: NoActivity(width: widget.width),
                        )
                      : OverViewDebt(width: widget.width).animate().fade(delay: 300.ms)
                  : allCreditRecords.isEmpty
                      ? SizedBox(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().screenHeight * .65,
                          child: NoActivity(width: widget.width),
                        )
                      : OverViewCredit(width: widget.width).animate().fade(delay: 300.ms),
            ),
          ),
        ],
      ),
    );
  }
}
