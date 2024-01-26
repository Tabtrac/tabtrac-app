import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/functions.dart';

import '../../../constants/app_routes.dart';
import '../../../constants/colors.dart';
import '../../../helpers/app_fonts.dart';
import '../../../widgets/activity.widget.dart';
import 'controller/record.controller.dart';
import 'providers/record.provider.dart';

class InfiniteRecord extends ConsumerStatefulWidget {
  const InfiniteRecord({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfiniteRecordState();
}

class _InfiniteRecordState extends ConsumerState<InfiniteRecord> {
  final _scrollController = ScrollController();
  late RecordController recordController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var currentRoute = ModalRoute.of(context);
      final data = currentRoute!.settings.arguments! as Map;
      recordController = RecordController(ref: ref, context: context);
      String type = data['type'];
      String section = data['section'];
      
      // Clear values
      ref.read(currentLoadCount.notifier).change(1);
      ref.read(nextIntProvider.notifier).change('');
      ref.read(infiniteRecordListProvider.notifier).change([]);

      // run initial
      recordController.infiniteRecordFetch(
          section, type, ref.read(currentLoadCount));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() {
    var currentRoute = ModalRoute.of(context);
    final data = currentRoute!.settings.arguments! as Map;

    String type = data['type'];
    String section = data['section'];
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(currentLoadCount.notifier).increament();
      recordController.infiniteRecordFetch(
          section, type, ref.watch(currentLoadCount));
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentRoute = ModalRoute.of(context);
    final data = currentRoute!.settings.arguments! as Map;
    final transH = AppLocalizations.of(context)!;
    String type = data['type'];
    String section = data['section'];

    String title;
    if (section == 'all') {
      title = type == 'debt'
          ? "${transH.all} ${transH.debt} ${transH.record}".capitalizeAll()
          : "${transH.all} ${transH.credit} ${transH.record}".capitalizeAll();
    } else if (section == 'due') {
      title = type == 'debt'
          ? "${transH.overdue} ${transH.debt} ${transH.record}".capitalizeAll()
          : "${transH.overdue} ${transH.credit} ${transH.record}"
              .capitalizeAll();
    } else if (section == 'pending') {
      title = type == 'debt'
          ? "${transH.pending} ${transH.debt} ${transH.record}".capitalizeAll()
          : "${transH.pending} ${transH.credit} ${transH.record}"
              .capitalizeAll();
    } else {
      title = type == 'debt'
          ? "${transH.paid} ${transH.debt} ${transH.record}".capitalizeAll()
          : "${transH.paid} ${transH.credit} ${transH.record}".capitalizeAll();
    }
    final infiniteRecordList = ref.watch(infiniteRecordListProvider);
    double width = ScreenUtil().screenWidth;
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
          title,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
      ),
      body: infiniteRecordList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: infiniteRecordList.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime paymentDate =
                      DateTime.parse(infiniteRecordList[index].paymentDate);
                  DateTime now = DateTime.now();
                  bool isDue;
                  if (paymentDate.isAfter(now)) {
                    isDue = false;
                  } else if (paymentDate.isBefore(now)) {
                    isDue = true;
                  } else {
                    isDue = false;
                  }
                  return ActivityWidget(
                    name: infiniteRecordList[index].clientName,
                    status: infiniteRecordList[index].status,
                    amount: infiniteRecordList[index].amount,
                    currency: infiniteRecordList[index].currency,
                    type: type,
                    paymentDate: infiniteRecordList[index].paymentDate,
                    isDue: isDue,
                    width: width,
                    onTap: () {
                      navigateNamed(
                          context, AppRoutes.detailedRecord, type);
                      ref
                          .read(currentRecordProvider.notifier)
                          .change(infiniteRecordList[index]);
                    },
                  );
                },
              ),
            ),
    );
  }
}
// 8500