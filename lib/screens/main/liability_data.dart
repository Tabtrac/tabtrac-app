import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundz_app/helpers/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/app_routes.dart';
import '../../constants/colors.dart';
import '../../helpers/app_fonts.dart';
import '../../models/liability.dart';
import '../../providers/providers.dart';
import '../../widgets/liability_card.dart';

class ActivityData extends StatefulWidget {
  const ActivityData({super.key});

  @override
  State<ActivityData> createState() => _ActivityDataState();
}

class _ActivityDataState extends State<ActivityData> {
  List<String> tabs = ['all', 'due', 'pending', 'paid'];
  List<Widget> tabsWidgets = [
    const AllWidget(),
    const DueWidget(),
    const PendingWidget(),
    const PaidWidget(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            TabBar(
              dividerColor: Theme.of(context).scaffoldBackgroundColor,
              tabs: List.generate(
                tabs.length,
                (index) => Tab(
                  child: FittedBox(
                    child: Text(
                      tabs[index].capitalizeAll(),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFonts.primaryFont2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                children: List.generate(
                  tabsWidgets.length,
                  (index) => tabsWidgets[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllWidget extends ConsumerStatefulWidget {
  const AllWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllWidgetState();
}

class _AllWidgetState extends ConsumerState<AllWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final transH = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: ref
          .read(liabilityControllerControllerProvider.notifier)
          .getAllLiabilities(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              transH.anErrorOccured,
              style: TextStyle(
                color: AppColors.dangerColor,
                fontFamily: AppFonts.actionFont,
                fontSize: width * .01 + 16,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          var data = snapshot.data!;

          if (data['count'] != null && data['count'] >= 0) {
            // print(data['results'].length);
            if (data['results'].length < 1) {
              return Container(
                width: width * .7,
                alignment: Alignment.center,
                child: Text(
                  transH.noRecord.capitalizeAll(),
                  style: TextStyle(
                    fontFamily: AppFonts.actionFont,
                    fontSize: width * .01 + 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            List objectData = data['results']
                .map((json) => Liability.fromJson(json))
                .toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: objectData.length,
                itemBuilder: (context, index) {
                  final element = objectData[index];

                  return InkWell(
                    onTap: () {
                      ref
                          .read(liabilityNotifierProvider.notifier)
                          .changeValues(element);
                      navigateNamed(context, AppRoutes.detailedLiabilityRoute);
                    },
                    child: LiabilityCard(
                      width: width,
                      name: element.creditorName,
                      description: element.description,
                      amount: element.amount,
                      dateCreated: element.createdDate,
                      status: element.status,
                      timeago:
                          convertToAgo(DateTime.parse(element.paymentDate)),
                      height: height,
                      debtId: element.id,
                      currency: element.currency,
                    ),
                  );
                },
              ),
            );
          } else if (data['error'] == 'network') {
            return Container(
              width: width * .7,
              alignment: Alignment.center,
              child: Text(
                "${transH.error}, ${transH.network}".capitalize(),
                style: TextStyle(
                  color: AppColors.dangerColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 16,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Container(
              width: width * .7,
              alignment: Alignment.center,
              child: Text(
                "${transH.error}, ${transH.unkownError}".capitalize(),
                style: TextStyle(
                  color: AppColors.dangerColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 16,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class DueWidget extends ConsumerStatefulWidget {
  const DueWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DueWidgetState();
}

class _DueWidgetState extends ConsumerState<DueWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final transH = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: ref
          .read(liabilityControllerControllerProvider.notifier)
          .getDueLiabilities(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              transH.anErrorOccured,
              style: TextStyle(
                color: AppColors.dangerColor,
                fontFamily: AppFonts.actionFont,
                fontSize: width * .01 + 16,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          var data = snapshot.data!;
          if (data['count'] != null && data['count'] >= 0) {
            // print(data['results'].length);
            if (data['results'].length < 1) {
              return Container(
                width: width * .7,
                alignment: Alignment.center,
                child: Text(
                  transH.noRecord.capitalizeAll(),
                  style: TextStyle(
                    fontFamily: AppFonts.actionFont,
                    fontSize: width * .01 + 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            List objectData = data['results']
                .map((json) => Liability.fromJson(json))
                .toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: objectData.length,
                itemBuilder: (context, index) {
                  final element = objectData[index];

                  return InkWell(
                    onTap: () {
                      ref
                          .read(liabilityNotifierProvider.notifier)
                          .changeValues(element);
                      navigateNamed(context, AppRoutes.detailedLiabilityRoute);
                    },
                    child: LiabilityCard(
                      width: width,
                      name: element.creditorName,
                      description: element.description,
                      amount: element.amount,
                      dateCreated: element.createdDate,
                      status: element.status,
                      timeago:
                          convertToAgo(DateTime.parse(element.paymentDate)),
                      currency: element.currency,
                      height: height,
                      debtId: element.id,
                    ),
                  );
                },
              ),
            );
          } else if (data['count'] != null && data['error'] == 'network') {
            return Container(
              width: width * .7,
              alignment: Alignment.center,
              child: Text(
                "${transH.error}, ${transH.network}".capitalize(),
                style: TextStyle(
                  color: AppColors.dangerColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 16,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Container(
              width: width * .7,
              alignment: Alignment.center,
              child: Text(
                "${transH.error}, ${transH.unkownError}".capitalize(),
                style: TextStyle(
                  color: AppColors.dangerColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 16,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class PendingWidget extends ConsumerStatefulWidget {
  const PendingWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PendingWidgetState();
}

class _PendingWidgetState extends ConsumerState<PendingWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final transH = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: ref
          .read(liabilityControllerControllerProvider.notifier)
          .getPendingLiabilities(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              transH.anErrorOccured,
              style: TextStyle(
                color: AppColors.dangerColor,
                fontFamily: AppFonts.actionFont,
                fontSize: width * .01 + 16,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          var data = snapshot.data!;
          if (data['count'] != null && data['count'] >= 0) {
            // print(data['results'].length);
            if (data['results'].length < 1) {
              return Container(
                width: width * .7,
                alignment: Alignment.center,
                child: Text(
                  transH.noRecord.capitalizeAll(),
                  style: TextStyle(
                    fontFamily: AppFonts.actionFont,
                    fontSize: width * .01 + 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            List objectData = data['results']
                .map((json) => Liability.fromJson(json))
                .toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: objectData.length,
                itemBuilder: (context, index) {
                  final element = objectData[index];

                  return InkWell(
                    onTap: () {
                      ref
                          .read(liabilityNotifierProvider.notifier)
                          .changeValues(element);
                      navigateNamed(context, AppRoutes.detailedLiabilityRoute);
                    },
                    child: LiabilityCard(
                      width: width,
                      currency: element.currency,
                      name: element.creditorName,
                      description: element.description,
                      amount: element.amount,
                      dateCreated: element.createdDate,
                      status: element.status,
                      timeago:
                          convertToAgo(DateTime.parse(element.paymentDate)),
                      height: height,
                      debtId: element.id,
                    ),
                  );
                },
              ),
            );
          } else if (data['error'] == 'network') {
            return Container(
              width: width * .7,
              alignment: Alignment.center,
              child: Text(
                "${transH.error}, ${transH.network}".capitalize(),
                style: TextStyle(
                  color: AppColors.dangerColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 16,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Container(
              width: width * .7,
              alignment: Alignment.center,
              child: Text(
                "${transH.error}, ${transH.unkownError}".capitalize(),
                style: TextStyle(
                  color: AppColors.dangerColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 16,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class PaidWidget extends ConsumerStatefulWidget {
  const PaidWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaidWidgetState();
}

class _PaidWidgetState extends ConsumerState<PaidWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final transH = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: ref
          .read(liabilityControllerControllerProvider.notifier)
          .getPaidLiabilities(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              transH.anErrorOccured,
              style: TextStyle(
                color: AppColors.dangerColor,
                fontFamily: AppFonts.actionFont,
                fontSize: width * .01 + 16,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          var data = snapshot.data!;
          if (data['count'] != null && data['count'] >= 0) {
            // print(data['results'].length);
            if (data['results'].length < 1) {
              return Container(
                width: width * .7,
                alignment: Alignment.center,
                child: Text(
                  transH.noRecord.capitalizeAll(),
                  style: TextStyle(
                    fontFamily: AppFonts.actionFont,
                    fontSize: width * .01 + 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            List objectData = data['results']
                .map((json) => Liability.fromJson(json))
                .toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: objectData.length,
                itemBuilder: (context, index) {
                  final element = objectData[index];

                  return InkWell(
                    onTap: () {
                      ref
                          .read(liabilityNotifierProvider.notifier)
                          .changeValues(element);
                      navigateNamed(context, AppRoutes.detailedLiabilityRoute);
                    },
                    child: LiabilityCard(
                      width: width,
                      name: element.creditorName,
                      description: element.description,
                      amount: element.amount,
                      currency: element.currency,
                      dateCreated: element.createdDate,
                      status: element.status,
                      timeago:
                          convertToAgo(DateTime.parse(element.paymentDate)),
                      height: height,
                      debtId: element.id,
                    ),
                  );
                },
              ),
            );
          } else if (data['error'] == 'network') {
            return Container(
              width: width * .7,
              alignment: Alignment.center,
              child: Text(
                "${transH.error}, ${transH.network}".capitalize(),
                style: TextStyle(
                  color: AppColors.dangerColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 16,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Container(
              width: width * .7,
              alignment: Alignment.center,
              child: Text(
                "${transH.error}, ${transH.unkownError}".capitalize(),
                style: TextStyle(
                  color: AppColors.dangerColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 16,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
