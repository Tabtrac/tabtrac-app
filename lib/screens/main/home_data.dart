import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundz_app/constants/app_routes.dart';
import 'package:fundz_app/constants/colors.dart';
import 'package:fundz_app/helpers/app_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/functions.dart';
import '../../models/debt.dart';
import '../../providers/providers.dart';
import '../../widgets/debt_card.dart';

class HomeData extends ConsumerStatefulWidget {
  const HomeData({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeDataState();
}

class _HomeDataState extends ConsumerState<HomeData> {
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
      future: ref.read(debtControllerProvider.notifier).getAllDebts(),
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
            List objectData =
                data['results'].map((json) => Debt.fromJson(json)).toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: objectData.length,
                itemBuilder: (context, index) {
                  final element = objectData[index];

                  return InkWell(
                    onTap: () {
                      ref
                          .read(debtNotifierProvider.notifier)
                          .changeValues(element);
                      navigateNamed(context, AppRoutes.debtDetailRoute);
                    },
                    child: DebtCard(
                      width: width,
                      name: element.debtorName,
                      description: element.description,
                      amount: element.amount,
                      dateCreated: element.createdDate,
                      status: element.status,
                      currency: element.currency,
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
      future: ref.read(debtControllerProvider.notifier).getDueDebts(),
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
            List objectData =
                data['results'].map((json) => Debt.fromJson(json)).toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: objectData.length,
                itemBuilder: (context, index) {
                  final element = objectData[index];

                  return InkWell(
                    onTap: () {
                      ref
                          .read(debtNotifierProvider.notifier)
                          .changeValues(element);
                      navigateNamed(context, AppRoutes.debtDetailRoute);
                    },
                    child: DebtCard(
                      width: width,
                      name: element.debtorName,
                      description: element.description,
                      currency: element.currency,
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
      future: ref.read(debtControllerProvider.notifier).getPendingDebts(),
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
            List objectData =
                data['results'].map((json) => Debt.fromJson(json)).toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: objectData.length,
                itemBuilder: (context, index) {
                  final element = objectData[index];

                  return InkWell(
                    onTap: () {
                      ref
                          .read(debtNotifierProvider.notifier)
                          .changeValues(element);
                      navigateNamed(context, AppRoutes.debtDetailRoute);
                    },
                    child: DebtCard(
                      width: width,
                      name: element.debtorName,
                      description: element.description,
                      amount: element.amount,
                      dateCreated: element.createdDate,
                      currency: element.currency,
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
      future: ref.read(debtControllerProvider.notifier).getPaidDebts(),
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
            List objectData =
                data['results'].map((json) => Debt.fromJson(json)).toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: objectData.length,
                itemBuilder: (context, index) {
                  final element = objectData[index];

                  return InkWell(
                    onTap: () {
                      ref
                          .read(debtNotifierProvider.notifier)
                          .changeValues(element);
                      navigateNamed(context, AppRoutes.debtDetailRoute);
                    },
                    child: DebtCard(
                      width: width,
                      name: element.debtorName,
                      currency: element.currency,
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
