import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/app_routes.dart';
import '../../../../constants/colors.dart';
import '../../../../helpers/functions.dart';
import '../../../../providers/providers.dart';
import '../../actions/providers/actions.provider.dart';
import '../controller/client.controller.dart';
import '../providers/provider.client.dart';
import 'each_client.dart';
import '../../../../widgets/no_activity.dart';

class SearchClientWidget extends ConsumerStatefulWidget {
  final bool? isDataSaved;
  const SearchClientWidget({
    super.key,
    this.isDataSaved,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchClientWidgetState();
}

class _SearchClientWidgetState extends ConsumerState<SearchClientWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  Timer? _typingTimer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final clientList = ref.watch(clientListProvider);
      ref.read(searchedClientListProvider.notifier).change(clientList);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textEditingController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    ClientController clientController =
        ClientController(ref: ref, context: context);
    _typingTimer?.cancel();

    _typingTimer = Timer(const Duration(milliseconds: 700), () {
      clientController.searchClients();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;

    final isDarkMode = ref.watch(isDarkModeProvider);
    final searchedClientList = ref.watch(searchedClientListProvider);
    final isSearching = ref.watch(isSearchingProvider);
    ClientController clientController =
        ClientController(ref: ref, context: context);
    final transH = AppLocalizations.of(context)!;
    return Container(
      width: width,
      constraints: BoxConstraints(
        maxHeight: height * .95,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 5.h),
          Container(
            width: 60.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(.6),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkThemeShade.withOpacity(.3)
                    : AppColors.lightThemeShade.withOpacity(.3),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: AppColors.greyColor.withOpacity(.2), width: .7)),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
            width: ScreenUtil().screenWidth,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search_outlined,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withOpacity(.4),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontSize: 14.sp,
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      ref.read(isSearchingProvider.notifier).change(true);
                      ref.read(searchStringProvider.notifier).change(value);
                    },
                    onSubmitted: (value) {
                      clientController.searchClients();
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      hintText: transH.searchClientList.capitalize(),
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          if (isSearching)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (searchedClientList.isEmpty)
            Expanded(
              child: NoActivity(width: width),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    searchedClientList.length,
                    (index) => EachClient(
                      width: width,
                      name: searchedClientList[index].name,
                      phoneNumber: searchedClientList[index].phoneNumber,
                      email: searchedClientList[index].email,
                      onTap: () {
                        if (widget.isDataSaved != null) {
                          Future.delayed(const Duration(seconds: 1), () {
                            ref
                                .read(selectedClient.notifier)
                                .change(searchedClientList[index]);
                            Navigator.pop(context);
                          });
                        } else {
                          navigateNamed(context, AppRoutes.clientDetailsRoutes,
                              searchedClientList[index].id.toString());
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
