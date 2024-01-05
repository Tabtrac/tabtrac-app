import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:heroicons/heroicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/colors.dart';
import '../../../helpers/app_fonts.dart';
import '../../../providers/providers.dart';
import '../../../widgets/no_activity.dart';
import '../../../widgets/shimmers.widget.dart';
import '../../../widgets/widgets.utils.dart';
import 'controller/client.controller.dart';
import 'providers/provider.client.dart';
import 'widgets/clients.dart';

class ClientWidget extends ConsumerStatefulWidget {
  final double width;
  final double height;
  final BuildContext? mainContext;
  const ClientWidget({
    super.key,
    required this.mainContext,
    required this.width,
    required this.height,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClientWidgetState();
}

class _ClientWidgetState extends ConsumerState<ClientWidget> {
  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    final isDarkMode = ref.watch(isDarkModeProvider);
    final clientList = ref.watch(clientListProvider);
    final allClientLoading = ref.watch(allClientLoadingProvider);
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
                  transH.clientManagement.capitalizeAll(),
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.actionFont),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      AppWidgetsUtlis.searchClientList(
                          widget.mainContext ?? context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.darkThemeShade
                            : AppColors.lightThemeShade,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      margin: const EdgeInsets.only(right: 10.0),
                      child: HeroIcon(
                        HeroIcons.magnifyingGlass,
                        style: HeroIconStyle.outline,
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      AppWidgetsUtlis.showBottomSheet(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.darkThemeShade
                            : AppColors.lightThemeShade,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      margin: const EdgeInsets.only(right: 10.0),
                      child: HeroIcon(
                        HeroIcons.userPlus,
                        style: HeroIconStyle.outline,
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          if (allClientLoading)
            Flexible(
              child: Shimmer.fromColors(
                baseColor: AppColors.greyColor.withOpacity(.5),
                highlightColor: AppColors.primaryColor,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) =>
                      RecordActivityShimmer(width: widget.width),
                ),
              ),
            )
          else
            Flexible(
              child: clientList.isEmpty
                  ? NoActivity(width: widget.width)
                  : SingleChildScrollView(
                      child: ClientsWidget(width: widget.width),
                    ),
            ).animate().fade(),
        ],
      ),
    );
  }
}
