// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundz_app/widgets/snackbars.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helpers/functions.dart';
import '../../../providers/providers.dart';
import '../../../widgets/bottom.nav.widgets.dart';
import '../../../widgets/widgets.utils.dart';
import '../client/client.widget.dart';
import '../client/controller/client.controller.dart';
import '../home/home.widget.dart';
import '../record/controller/record.controller.dart';
import '../record/record.widget.dart';

class RootHome extends ConsumerStatefulWidget {
  const RootHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RootHomeState();
}

class _RootHomeState extends ConsumerState<RootHome> {
  late StreamSubscription<ConnectivityResult> subscription;
  @override
  void initState() {
    changeBottomBarColor(ref.read(isDarkModeProvider));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transH = AppLocalizations.of(context)!;
      // UtitlityController().loadNotifications(context, ref);
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet ||
            result == ConnectivityResult.vpn) {
          if (await isOnline()) {
            successSnackBar(
                title: transH.internet.capitalizeFirst.toString(),
                message: transH.userOnline.capitalizeFirst.toString());
            initializeData();
          } else {
            errorSnackBar(
                title: transH.internet.capitalizeFirst.toString(),
                message: transH.userOffline.capitalizeFirst.toString());
          }
        } else {
          errorSnackBar(
              title: transH.internet.capitalizeFirst.toString(),
              message: transH.userOffline.capitalizeFirst.toString());
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void initializeData() async {
    final clientController = ClientController(ref: ref, context: context);
    final recordController = RecordController(ref: ref, context: context);

    // recordController.getOverviewData();
    clientController.getAllClients();
    recordController.onLoadData();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    List<Widget> screens = [
      HomeWidget(
        width: width,
        height: height,
      ),
      ClientWidget(
        width: width,
        height: height,
        mainContext: _scaffoldKey.currentContext,
      ),
      RecordWidget(
        width: width,
        height: height,
      ),
      RecordWidget(
        width: width,
        height: height,
      ),
      // AnalyticWidget(
      //   width: width,
      //   height: height,
      // ),
    ];

    final viewController = ref.watch(viewControllerProvider);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: IndexedStack(
          index: viewController,
          children: screens,
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        height: height,
        width: width,
        initialIndex: viewController,
        onDoubleTap: (index) {
          final clientController = ClientController(ref: ref, context: context);
          final recordController = RecordController(ref: ref, context: context);

          if (index == 0) {
            recordController.getOverviewData();
            recordController.getRecentActivity();
          } else if (index == 1) {
            clientController.getAllClients();
          } else if (index == 3) {
            recordController.onLoadData();
          }
        },
        onTap: (index) {
          if (index == 2) {
            AppWidgetsUtlis.showRecordCreateBottomSheet(context);
          } else {
            ref
                .read(viewControllerProvider.notifier)
                .changeCurrentViewIndex(index);
          }
        },
      ),
    );
  }
}
