import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

import '../../../../constants/colors.dart';
import '../../../../helpers/functions.dart';
import '../../../../providers/providers.dart';

final currentTabProvider =
    StateNotifierProvider<CurrentTabNotifier, String>((ref) {
  return CurrentTabNotifier();
});

class CustomTabWidget extends ConsumerStatefulWidget {
  final double width;
  const CustomTabWidget({
    super.key,
    required this.width,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomTabWidgetState();
}

class _CustomTabWidgetState extends ConsumerState<CustomTabWidget> {
  @override
  Widget build(BuildContext context) {
    // double width = ScreenUtil().scaleWidth;
    final isDarkmode = ref.watch(isDarkModeProvider);
    final currentTab = ref.watch(currentTabProvider);
    final transH = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.center,
      child: CustomSlidingSegmentedControl<int>(
        initialValue: 1,
        children: {
          1: Text(
            transH.debt.capitalizeFirst.toString(),
            style: TextStyle(
              color: currentTab == 'debt'
                  ? AppColors.whiteColor
                  : Theme.of(context).textTheme.bodyMedium!.color,
              fontSize: isTablet() ? 10.sp : 14.sp,
            ),
          ),
          2: Text(
            transH.credit.capitalizeFirst.toString(),
            style: TextStyle(
              color: currentTab == 'credit'
                  ? AppColors.whiteColor
                  : Theme.of(context).textTheme.bodyMedium!.color,
              fontSize: isTablet() ? 10.sp : 14.sp,
            ),
          ),
        },
        height: 40.h,
        decoration: BoxDecoration(
          color:
              isDarkmode ? AppColors.darkThemeShade : AppColors.lightThemeShade,
          borderRadius: BorderRadius.circular(99),
        ),
        fixedWidth: widget.width * .4,
        thumbDecoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(99),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColorLight.withOpacity(.3),
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: const Offset(
                0.0,
                2.0,
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInToLinear,
        onValueChanged: (v) {
          if (v == 1) {
            ref.read(currentTabProvider.notifier).change('debt');
          } else {
            ref.read(currentTabProvider.notifier).change('credit');
          }
        },
      ),
    );
  }
}
