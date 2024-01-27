import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:heroicons/heroicons.dart';

import '../../../../constants/app_routes.dart';
import '../../../../constants/colors.dart';
import '../../../../helpers/app_fonts.dart';
import '../../../../providers/providers.dart';
import '../../../../widgets/activity.widget.dart';
import '../../../../widgets/no_activity.dart';
import '../../../../widgets/placeholder.widgets.dart';
import '../../../../widgets/shimmers.widget.dart';
import '../../../../widgets/widgets.utils.dart';
import '../../record/providers/record.provider.dart';
import '../../record/widgets/tab.widget.dart';
import '../controller/client.controller.dart';
import '../providers/provider.client.dart';

class ClientDetails extends ConsumerStatefulWidget {
  const ClientDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends ConsumerState<ClientDetails> {
  late ClientController clientController;
  @override
  void initState() {
    changeBottomBarColor(ref.read(isDarkModeProvider));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      clientController = ClientController(ref: ref, context: context);
      var currentRoute = ModalRoute.of(context);
      String? clientId = currentRoute?.settings.arguments as String?;
      clientController.getDetailedClientData(clientId.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentRoute = ModalRoute.of(context);
    String? clientId = currentRoute?.settings.arguments as String?;
    final transH = AppLocalizations.of(context)!;
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    final clientDebtRecord = ref.watch(clientDebtRecordProvider);
    final clientCreditRecord = ref.watch(clientCreditRecordProvider);
    final currentTab = ref.watch(currentTabProvider);
    final currentCleintDetails = ref.watch(currentCleintDetailsProvider);
    final isDeleting = ref.watch(isDeletingProvider);
    final clientLoading = ref.watch(clientLoadingProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryColor,
                  size: 24.sp,
                ),
              )
            : null,
        centerTitle: false,
        title: Text(
          "${transH.client} ${transH.details}".capitalizeAll(),
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
        actions: [
          if (currentCleintDetails != null && isDeleting == false)
            IconButton(
              onPressed: () {
                AppWidgetsUtlis.showEditClientBottomSheet(context,
                    clientId: clientId.toString());
              },
              icon: HeroIcon(
                HeroIcons.pencilSquare,
                style: HeroIconStyle.outline,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
            ).animate().fade(delay: 500.ms, curve: Curves.ease)
          else
            const SizedBox(),
          if (currentCleintDetails != null && isDeleting == false)
            IconButton(
              onPressed: () {
                AppWidgetsUtlis.deleteConfirmation(
                    context, transH, clientController, ref, clientId);
              },
              icon: HeroIcon(
                HeroIcons.trash,
                style: HeroIconStyle.outline,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
            ).animate().fade(delay: 500.ms, curve: Curves.ease)
          else
            const SizedBox(),
        ],
      ),
      body: isDeleting
          ? SizedBox(
              width: width,
              height: height,
              child: deletePlaceholderWidget(transH, width, height),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              width: width,
              height: height,
              child: Column(
                children: <Widget>[
                  if (clientLoading)
                    Expanded(child: CleintDetailsShimmer(width: width))
                  else if (currentCleintDetails == null)
                    NoActivity(width: width).animate().fadeIn(delay: 500.ms)
                  else
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20.h),
                            Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      transH.clientName.capitalizeFirst
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: AppFonts.actionFont,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: width * .8,
                                      ),
                                      child: Text(
                                        currentCleintDetails.name,
                                        style: TextStyle(
                                          fontFamily: AppFonts.actionFont,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                          color: AppColors.primaryColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Container(
                                      height: 1.5.h,
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.greyColor.withOpacity(.2),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                currentCleintDetails.location == null ||
                                        currentCleintDetails.location == ''
                                    ? const SizedBox()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            transH
                                                .clientLocation.capitalizeFirst
                                                .toString(),
                                            style: TextStyle(
                                              fontFamily: AppFonts.actionFont,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: width * .8,
                                            ),
                                            child: Text(
                                              currentCleintDetails.location
                                                  .toString(),
                                              style: TextStyle(
                                                fontFamily: AppFonts.actionFont,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp,
                                                color: AppColors.primaryColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Container(
                                            height: 1.5.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.greyColor
                                                  .withOpacity(.2),
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(height: 10.h),
                                currentCleintDetails.email == null ||
                                        currentCleintDetails.email == ''
                                    ? const SizedBox()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            transH.clientEmail.capitalizeFirst
                                                .toString(),
                                            style: TextStyle(
                                              fontFamily: AppFonts.actionFont,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: width * .7,
                                                ),
                                                child: Text(
                                                  currentCleintDetails.email
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.actionFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.sp,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  launchEmail(
                                                      currentCleintDetails.email
                                                          .toString(),
                                                      "Tabtrac",
                                                      '');
                                                },
                                                icon: const Icon(
                                                  CupertinoIcons.mail,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Container(
                                            height: 1.5.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.greyColor
                                                  .withOpacity(.2),
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(height: 10.h),
                                currentCleintDetails.phoneNumber == null ||
                                        currentCleintDetails.phoneNumber == ''
                                    ? const SizedBox()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            transH.clientPhonenumber
                                                .capitalizeFirst
                                                .toString(),
                                            style: TextStyle(
                                              fontFamily: AppFonts.actionFont,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: width * .7,
                                                ),
                                                child: Text(
                                                  currentCleintDetails
                                                      .phoneNumber
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.actionFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.sp,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  launchPhoneCall(
                                                      currentCleintDetails
                                                          .phoneNumber
                                                          .toString());
                                                },
                                                icon: const Icon(
                                                  CupertinoIcons.phone,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Container(
                                            height: 1.5.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.greyColor
                                                  .withOpacity(.2),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    "${transH.client} ${transH.record}s"
                                        .capitalizeAll(),
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                      fontFamily: AppFonts.actionFont,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                CustomTabWidget(
                                  width: width,
                                ),
                                SizedBox(height: 20.h),
                                if (currentTab == "debt")
                                  clientDebtRecord.isEmpty
                                      ? SizedBox(
                                          height: 250.h,
                                          child: NoActivity(width: width),
                                        )
                                      : Column(
                                          children: List.generate(
                                            clientDebtRecord.length,
                                            (index) {
                                              DateTime paymentDate =
                                                  DateTime.parse(
                                                      clientDebtRecord[index]
                                                          .paymentDate);
                                              DateTime now = DateTime.now();
                                              bool isDue;
                                              if (paymentDate.isAfter(now)) {
                                                isDue = false;
                                              } else if (paymentDate
                                                  .isBefore(now)) {
                                                isDue = true;
                                              } else {
                                                isDue = false;
                                              }
                                              return ActivityWidget(
                                                name: clientDebtRecord[index]
                                                    .clientName,
                                                status: clientDebtRecord[index]
                                                    .status,
                                                amount: clientDebtRecord[index]
                                                    .amount,
                                                currency:
                                                    clientDebtRecord[index]
                                                        .currency,
                                                type: 'debt',
                                                paymentDate:
                                                    clientDebtRecord[index]
                                                        .paymentDate,
                                                isDue: isDue,
                                                width: width,
                                                onTap: () {
                                                  navigateNamed(
                                                      context,
                                                      AppRoutes.detailedRecord,
                                                      'debt');
                                                  ref
                                                      .read(
                                                          currentRecordProvider
                                                              .notifier)
                                                      .change(clientDebtRecord[
                                                          index]);
                                                },
                                              );
                                            },
                                          ),
                                        ).animate().fade(delay: 500.ms)
                                else
                                  clientCreditRecord.isEmpty
                                      ? SizedBox(
                                          height: 250.h,
                                          child: NoActivity(width: width),
                                        )
                                      : Column(
                                          children: List.generate(
                                            clientCreditRecord.length,
                                            (index) {
                                              DateTime paymentDate =
                                                  DateTime.parse(
                                                      clientCreditRecord[index]
                                                          .paymentDate);
                                              DateTime now = DateTime.now();
                                              bool isDue;
                                              if (paymentDate.isAfter(now)) {
                                                isDue = false;
                                              } else if (paymentDate
                                                  .isBefore(now)) {
                                                isDue = true;
                                              } else {
                                                isDue = false;
                                              }
                                              return ActivityWidget(
                                                name: clientCreditRecord[index]
                                                    .clientName,
                                                status:
                                                    clientCreditRecord[index]
                                                        .status,
                                                amount:
                                                    clientCreditRecord[index]
                                                        .amount,
                                                currency:
                                                    clientCreditRecord[index]
                                                        .currency,
                                                type: 'credit',
                                                paymentDate:
                                                    clientCreditRecord[index]
                                                        .paymentDate,
                                                isDue: isDue,
                                                width: width,
                                                onTap: () {
                                                  navigateNamed(
                                                      context,
                                                      AppRoutes.detailedRecord,
                                                      'credit');
                                                  ref
                                                      .read(
                                                          currentRecordProvider
                                                              .notifier)
                                                      .change(
                                                          clientCreditRecord[
                                                              index]);
                                                },
                                              );
                                            },
                                          ),
                                        ).animate().fade(delay: 500.ms),
                              ],
                            )
                          ],
                        ).animate().fadeIn(),
                      ),
                    ),
                ],
              )),
    );
  }
}
