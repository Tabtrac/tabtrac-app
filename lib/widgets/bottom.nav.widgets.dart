import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/constants/app_routes.dart';
import 'package:fundz_app/constants/colors.dart';
import 'package:fundz_app/helpers/app_fonts.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:heroicons/heroicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomNav extends ConsumerWidget {
  final double width;
  final double height;
  final int initialIndex;
  final void Function(int index) onTap;
  final void Function(int index)? onDoubleTap;
  const CustomBottomNav({
    super.key,
    required this.height,
    required this.width,
    required this.initialIndex,
    required this.onTap,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transH = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          List<NavItem> items = [
            NavItem(
              icon: HeroIcon(
                HeroIcons.home,
                style: HeroIconStyle.outline,
                color: Theme.of(context).textTheme.bodyMedium!.color,
                size: 10.sp,
              ),
              activeIcon: HeroIcon(
                HeroIcons.home,
                style: HeroIconStyle.outline,
                color: AppColors.whiteColor,
                size: 14.sp,
              ),
              label: transH.home.capitalizeFirst.toString(),
            ),
            NavItem(
              icon: HeroIcon(
                HeroIcons.userPlus,
                style: HeroIconStyle.outline,
                color: Theme.of(context).textTheme.bodyMedium!.color,
                size: 10.sp,
              ),
              activeIcon: HeroIcon(
                HeroIcons.userPlus,
                style: HeroIconStyle.outline,
                color: AppColors.whiteColor,
                size: 14.sp,
              ),
              label: transH.client.capitalizeFirst.toString(),
            ),
            NavItem(
              icon: HeroIcon(
                HeroIcons.plus,
                style: HeroIconStyle.outline,
                color: AppColors.whiteColor,
                size: 14.sp,
              ),
              activeIcon: HeroIcon(
                HeroIcons.document,
                style: HeroIconStyle.outline,
                color: AppColors.whiteColor,
                size: 14.sp,
              ),
              label: transH.create.capitalizeFirst.toString(),
            ),
            NavItem(
              icon: HeroIcon(
                HeroIcons.document,
                style: HeroIconStyle.outline,
                color: Theme.of(context).textTheme.bodyMedium!.color,
                size: 10.sp,
              ),
              activeIcon: HeroIcon(
                HeroIcons.document,
                style: HeroIconStyle.outline,
                color: AppColors.whiteColor,
                size: 14.sp,
              ),
              label: transH.record.capitalizeFirst.toString(),
            ),
            // NavItem(
            //   icon: HeroIcon(
            //     HeroIcons.chartBar,
            //     style: HeroIconStyle.outline,
            //     color: Theme.of(context).textTheme.bodyMedium!.color,
            //     size: 10.sp,
            //   ),
            //   activeIcon: HeroIcon(
            //     HeroIcons.chartBar,
            //     style: HeroIconStyle.outline,
            //     color: AppColors.whiteColor,
            //     size: 14.sp,
            //   ),
            //   label: transH.analytic.capitalizeFirst.toString(),
            // ),
            NavItem(
              icon: HeroIcon(
                HeroIcons.cog,
                style: HeroIconStyle.outline,
                color: Theme.of(context).textTheme.bodyMedium!.color,
                size: 10.sp,
              ),
              activeIcon: HeroIcon(
                HeroIcons.cog,
                style: HeroIconStyle.outline,
                color: AppColors.whiteColor,
                size: 14.sp,
              ),
              label: transH.settings.capitalizeFirst.toString(),
            ),
          ];
          return TabletLayout(
              width: width,
              height: height,
              items: items,
              onTap: onTap,
              onDoubleTap: onDoubleTap,
              initialIndex: initialIndex);
        } else {
          List<NavItem> items = [
            NavItem(
              icon: HeroIcon(
                HeroIcons.home,
                style: HeroIconStyle.outline,
                color: Theme.of(context).textTheme.bodyMedium!.color,
                size: 20.sp,
              ),
              activeIcon: HeroIcon(
                HeroIcons.home,
                style: HeroIconStyle.outline,
                color: AppColors.whiteColor,
                size: 24.sp,
              ),
              label: transH.home.capitalizeFirst.toString(),
            ),
            NavItem(
              icon: HeroIcon(
                HeroIcons.userPlus,
                style: HeroIconStyle.outline,
                color: Theme.of(context).textTheme.bodyMedium!.color,
                size: 20.sp,
              ),
              activeIcon: HeroIcon(
                HeroIcons.userPlus,
                style: HeroIconStyle.outline,
                color: AppColors.whiteColor,
                size: 24.sp,
              ),
              label: transH.client.capitalizeFirst.toString(),
            ),
            NavItem(
              icon: HeroIcon(
                HeroIcons.plus,
                style: HeroIconStyle.outline,
                color: AppColors.whiteColor,
                size: 34.sp,
              ),
              activeIcon: HeroIcon(
                HeroIcons.document,
                style: HeroIconStyle.outline,
                color: AppColors.whiteColor,
                size: 24.sp,
              ),
              label: transH.create.capitalizeFirst.toString(),
            ),
            NavItem(
              icon: HeroIcon(
                HeroIcons.document,
                style: HeroIconStyle.outline,
                color: Theme.of(context).textTheme.bodyMedium!.color,
                size: 20.sp,
              ),
              activeIcon: HeroIcon(
                HeroIcons.document,
                style: HeroIconStyle.outline,
                color: AppColors.whiteColor,
                size: 24.sp,
              ),
              label: transH.record.capitalizeFirst.toString(),
            ),
            NavItem(
              icon: HeroIcon(
                HeroIcons.cog,
                style: HeroIconStyle.outline,
                color: Theme.of(context).textTheme.bodyMedium!.color,
                size: 20.sp,
              ),
              activeIcon: HeroIcon(
                HeroIcons.cog,
                style: HeroIconStyle.outline,
                color: AppColors.whiteColor,
                size: 24.sp,
              ),
              label: transH.settings.capitalizeFirst.toString(),
            ),
          ];
          return MobileLayout(
              width: width,
              height: height,
              items: items,
              onTap: onTap,
              onDoubleTap: onDoubleTap,
              initialIndex: initialIndex);
        }
      },
    );
  }
}

class TabletLayout extends StatelessWidget {
  const TabletLayout({
    super.key,
    required this.width,
    required this.height,
    required this.items,
    required this.onTap,
    required this.onDoubleTap,
    required this.initialIndex,
  });

  final double width;
  final double height;
  final List<NavItem> items;
  final void Function(int index) onTap;
  final void Function(int index)? onDoubleTap;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        width: width,
        // height: height * .1,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: AppColors.greyColor.withOpacity(.3),
            ),
          ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              items.length,
              (index) => InkWell(
                onTap: () {
                  if (index != 4) {
                    onTap(index);
                  } else {
                    navigateNamed(context, AppRoutes.settingsRoute);
                  }
                },
                onDoubleTap: () {
                  onDoubleTap!(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: initialIndex == index || index == 2
                        ? AppColors.primaryColor
                        : null,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: 25.w,
                  height: 25.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      initialIndex == index
                          ? items[index].activeIcon
                          : items[index].icon,
                      if (initialIndex == index)
                        const SizedBox()
                      else
                        SizedBox(height: 2.h),
                      if (initialIndex != index && index != 2)
                        FittedBox(
                          child: Text(
                            items[index].label,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                              fontFamily: AppFonts.actionFont,
                              // fontSize: 12.sp,
                            ),
                          ),
                        )
                      else if (index == 2)
                        const SizedBox()
                      else
                        const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({
    super.key,
    required this.width,
    required this.height,
    required this.items,
    required this.onTap,
    required this.onDoubleTap,
    required this.initialIndex,
  });

  final double width;
  final double height;
  final List<NavItem> items;
  final void Function(int index) onTap;
  final void Function(int index)? onDoubleTap;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: AppColors.greyColor.withOpacity(.3),
            ),
          ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            items.length,
            (index) => InkWell(
              onTap: () {
                if (index != 4) {
                  onTap(index);
                } else {
                  navigateNamed(context, AppRoutes.settingsRoute);
                }
              },
              onDoubleTap: () {
                onDoubleTap!(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: initialIndex == index || index == 2
                      ? AppColors.primaryColor
                      : null,
                  borderRadius: BorderRadius.circular(30),
                ),
                width: 50.w,
                height: 50.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    initialIndex == index
                        ? items[index].activeIcon
                        : items[index].icon,
                    if (initialIndex == index)
                      const SizedBox()
                    else
                      SizedBox(height: 2.h),
                    if (initialIndex != index && index != 2)
                      FittedBox(
                        child: Text(
                          items[index].label,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                            fontFamily: AppFonts.actionFont,
                            // fontSize: 12.sp,
                          ),
                        ),
                      )
                    else if (index == 2)
                      const SizedBox()
                    else
                      const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final Widget icon;
  final Widget activeIcon;
  final String label;

  NavItem({required this.icon, required this.label, required this.activeIcon});
}
