import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:heroicons/heroicons.dart';

import '../../../constants/app_routes.dart';
import '../../../constants/colors.dart';
import '../../../helpers/app_fonts.dart';
import '../../../providers/providers.dart';
import '../../../widgets/placeholder.widgets.dart';
import '../../../widgets/widgets.utils.dart';
import '../record/controller/record.controller.dart';
import '../record/providers/record.provider.dart';

class DetailedRecordView extends ConsumerStatefulWidget {
  const DetailedRecordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailedRecordViewState();
}

class _DetailedRecordViewState extends ConsumerState<DetailedRecordView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isLoadingProvider.notifier).change(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    final isDarkMode = ref.watch(isDarkModeProvider);
    var currentRoute = ModalRoute.of(context);
    String? type = currentRoute?.settings.arguments as String?;

    String currentLocale = getCurrentLocale(context).toString();
    final currentRecord = ref.watch(currentRecordProvider);
    String createdDate = currentRecord!.createdDate;
    String paymentDate = currentRecord.paymentDate;
    String clientId = currentRecord.client.toString();
    String name = currentRecord.clientName;
    String amounth = currentRecord.amount;
    String currency = currentRecord.currency;
    String description = currentRecord.description;
    String? phoneNumber = currentRecord.clientPhoneNumber;
    String? email = currentRecord.clientEmail;
    final isLoading = ref.watch(isLoadingProvider);
    RecordController recordController =
        RecordController(ref: ref, context: context);

    // ref.listen(isLoadingProvider, (previous, next) async {
    //   if (next == true) {
    //     await recordController.markRecordAsPaid(type.toString(), currentRecord);
    //     // print('object - main');
    //   }
    // });
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
        centerTitle: true,
        title: Text(
          "${transH.record} ${transH.details}".capitalizeAll(),
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
      ),
      body: isLoading
          ? SizedBox(
              width: width,
              height: height * .9,
              child: loadingPlaceholderWidget(transH, width, height),
            )
          : Container(
              width: width,
              height: height * .9,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.h),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkThemeShade.withOpacity(.5)
                          : AppColors.lightThemeShade.withOpacity(.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10.0),
                    child: Column(
                      children: [
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  type == 'debt'
                                      ? "${transH.debt} ${transH.record}"
                                          .capitalizeAll()
                                      : "${transH.credit} ${transH.record}"
                                          .capitalizeAll(),
                                  style: TextStyle(
                                    fontFamily: AppFonts.actionFont,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                if (type == 'debt' &&
                                    currentRecord.status == 'paid')
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: HeroIcon(
                                      HeroIcons.checkCircle,
                                      style: HeroIconStyle.outline,
                                      color: AppColors.paidColor,
                                      size: 20.sp,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              AppColors.paidShade),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    label: Text(
                                      transH.paid.capitalizeAll(),
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        fontFamily: AppFonts.actionFont,
                                      ),
                                    ),
                                  ),
                                if (type == 'debt' &&
                                    currentRecord.status == 'unpaid')
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: HeroIcon(
                                      HeroIcons.clock,
                                      style: HeroIconStyle.outline,
                                      color: AppColors.unpaidColor,
                                      size: 20.sp,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              AppColors.unpaidShade),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    label: Text(
                                      transH.unpaid.capitalizeAll(),
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        fontFamily: AppFonts.actionFont,
                                      ),
                                    ),
                                  ),
                                if (type == 'credit' &&
                                    currentRecord.status == 'paid')
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: HeroIcon(
                                      HeroIcons.checkCircle,
                                      style: HeroIconStyle.outline,
                                      color: AppColors.paidColor,
                                      size: 20.sp,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              AppColors.paidShade),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    label: Text(
                                      transH.paid.capitalizeAll(),
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        fontFamily: AppFonts.actionFont,
                                      ),
                                    ),
                                  ),
                                if (type == 'credit' &&
                                    currentRecord.status == 'unpaid')
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: HeroIcon(
                                      HeroIcons.clock,
                                      style: HeroIconStyle.outline,
                                      color: AppColors.unpaidColor,
                                      size: 20.sp,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              AppColors.unpaidShade),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    label: Text(
                                      transH.unpaid.capitalizeAll(),
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        fontFamily: AppFonts.actionFont,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              height: 1.5.h,
                              decoration: BoxDecoration(
                                color: AppColors.greyColor.withOpacity(.2),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      transH.purchasedOn.toUpperCase(),
                                      style: TextStyle(
                                        color: AppColors.greyColor,
                                        fontSize: 10.sp,
                                        fontFamily: AppFonts.actionFont,
                                      ),
                                    ),
                                    Text(
                                      regularDateFormat(
                                          DateTime.parse(createdDate),
                                          currentLocale),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                        fontFamily: AppFonts.actionFont,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      transH.dueOn.toUpperCase(),
                                      style: TextStyle(
                                        color: AppColors.greyColor,
                                        fontSize: 10.sp,
                                        fontFamily: AppFonts.actionFont,
                                      ),
                                    ),
                                    Text(
                                      regularDateFormat(
                                        DateTime.parse(paymentDate),
                                        currentLocale,
                                        removeTime: true,
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                        fontFamily: AppFonts.actionFont,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  transH.name.capitalizeAll(),
                                  style: TextStyle(
                                    color: AppColors.greyColor,
                                    fontSize: 12.sp,
                                    fontFamily: AppFonts.actionFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxHeight: width * .7),
                                  child: TextButton(
                                    onPressed: () {
                                      navigateNamed(
                                          context,
                                          AppRoutes.clientDetailsRoutes,
                                          clientId);
                                    },
                                    style: const ButtonStyle(
                                        padding: MaterialStatePropertyAll(
                                            EdgeInsets.all(0))),
                                    child: Text(
                                      name.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color,
                                        fontFamily: AppFonts.actionFont,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  transH.price.capitalizeAll(),
                                  style: TextStyle(
                                    color: AppColors.greyColor,
                                    fontSize: 12.sp,
                                    fontFamily: AppFonts.actionFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxHeight: width * .7),
                                  child: Text(
                                    moneyCommaTwo(
                                      amounth,
                                      currency: currency,
                                      obSecure: false,
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  transH.description.capitalizeAll(),
                                  style: TextStyle(
                                    color: AppColors.greyColor,
                                    fontSize: 12.sp,
                                    fontFamily: AppFonts.actionFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxHeight: width * .7),
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  transH.phoneNumber.capitalizeFirst.toString(),
                                  style: TextStyle(
                                    color: AppColors.greyColor,
                                    fontSize: 12.sp,
                                    fontFamily: AppFonts.actionFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxHeight: width * .7),
                                  child: Text(
                                    phoneNumber ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  transH.email.capitalizeFirst.toString(),
                                  style: TextStyle(
                                    color: AppColors.greyColor,
                                    fontSize: 12.sp,
                                    fontFamily: AppFonts.actionFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxHeight: width * .7),
                                  child: Text(
                                    email ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            // Align(
                            //   alignment: Alignment.center,
                            //   child: TextButton.icon(
                            //     onPressed: () {},
                            //     icon: Icon(
                            //       CupertinoIcons.link,
                            //       color: AppColors.greyColor,
                            //       size: 20.sp,
                            //     ),
                            //     label: Text(
                            //       transH.share.toUpperCase(),
                            //       style: TextStyle(
                            //         color: AppColors.greyColor,
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 14.sp,
                            //         fontFamily: AppFonts.actionFont,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            if (currentRecord.status == 'unpaid')
                              TextButton.icon(
                                onPressed: () {
                                  navigateNamed(context,
                                      AppRoutes.recordDepositeRoutes, type);
                                },
                                icon: HeroIcon(
                                  HeroIcons.pencilSquare,
                                  style: HeroIconStyle.outline,
                                  color: AppColors.primaryColor,
                                  size: 20.sp,
                                ),
                                label: Text(
                                  transH.deposite.capitalizeFirst.toString(),
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            if (currentRecord.status == 'unpaid')
                              TextButton.icon(
                                onPressed: () {
                                  AppWidgetsUtlis.markAsPaidConfirmation(
                                    context,
                                    transH,
                                    recordController,
                                    ref,
                                    currentRecord,
                                    type.toString(),
                                  );
                                },
                                icon: HeroIcon(
                                  HeroIcons.checkCircle,
                                  style: HeroIconStyle.outline,
                                  color: AppColors.paidColor,
                                  size: 20.sp,
                                ),
                                label: Text(
                                  transH.paid.capitalizeFirst.toString(),
                                  style: TextStyle(
                                    color: AppColors.paidColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            TextButton.icon(
                              onPressed: () {
                                AppWidgetsUtlis.deleteRecordConfirmation(
                                  context,
                                  transH,
                                  recordController,
                                  ref,
                                  currentRecord,
                                  type.toString(),
                                );
                              },
                              icon: HeroIcon(
                                HeroIcons.trash,
                                style: HeroIconStyle.outline,
                                color: AppColors.dangerColor,
                                size: 20.sp,
                              ),
                              label: Text(
                                transH.delete.capitalizeFirst.toString(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.dangerColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
