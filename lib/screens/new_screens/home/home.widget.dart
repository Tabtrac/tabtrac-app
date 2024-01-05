import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../../helpers/app_fonts.dart';
import '../../../helpers/functions.dart';
import '../../../widgets/no_activity.dart';
import '../../../widgets/shimmers.widget.dart';
import 'controllers/home.controller.dart';
import 'providers/provider.dart';
import 'widgets/actions.dart';
import 'widgets/recent_activities.dart';

// Providers
class CurrentIndexNotifier extends StateNotifier<int> {
  CurrentIndexNotifier() : super(0);

  void changeCurrentIndex(int index) {
    state = index;
  }
}

final currentIndexProvider =
    StateNotifierProvider<CurrentIndexNotifier, int>((ref) {
  return CurrentIndexNotifier();
});

class HomeWidget extends ConsumerStatefulWidget {
  final double width;
  final double height;
  const HomeWidget({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  // @override
  // void initState() {
  //   super.initState();

  //   final homeController = HomeController(ref: ref, context: context);
  //   homeController.getOverviewData();
  // }

  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    final currentIndex = ref.watch(currentIndexProvider);
    final homeController = HomeController(ref: ref, context: context);
    List<Widget> heroWidgets =
        homeController.getHeroWidgets(transH, widget.width);
    final recentDebtRecord = ref.watch(recentDebtRecordProvider);
    final recentCreditRecord = ref.watch(recentCreditRecordProvider);
    final recentLoading = ref.watch(recentLoadingProvider);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      transH.hello,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.actionFont,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      transH.anOverviewOfFinance.capitalize(),
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: AppFonts.actionFont,
                        fontSize: 12.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: widget.height * .75 + 15.h,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: widget.height * .02),
                  SizedBox(
                    width: widget.width,
                    height: 180.h,
                    child: PageView.builder(
                      itemCount: heroWidgets.length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (value) {
                        ref
                            .read(currentIndexProvider.notifier)
                            .changeCurrentIndex(value);
                      },
                      itemBuilder: (context, index) {
                        return heroWidgets[index];
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: widget.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        heroWidgets.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: currentIndex == index ? 30 : 10,
                          margin: const EdgeInsets.only(right: 5),
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    transH.actions.capitalizeAll(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ActionWidgets(width: widget.width),
                  SizedBox(height: 10.h),
                  Text(
                    transH.recentActivity.capitalizeAll(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (recentLoading)
                    Shimmer.fromColors(
                      baseColor: AppColors.greyColor.withOpacity(.5),
                      highlightColor: AppColors.primaryColor,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, index) =>
                            RecordActivityShimmer(width: widget.width),
                      ),
                    )
                  else if (recentCreditRecord.isEmpty &&
                      recentDebtRecord.isEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      child: NoActivity(
                        width: widget.width,
                      ),
                    )
                  else
                    RecentActivities(
                      width: widget.width,
                    ).animate().fade(delay: 200.ms),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
