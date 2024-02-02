import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:fundz_app/helpers/app_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors.dart';
import '../../../helpers/app_fonts.dart';
import '../../../helpers/functions.dart';
import '../../../providers/providers.dart';

class Changelanguage extends ConsumerStatefulWidget {
  const Changelanguage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangelanguageState();
}

class _ChangelanguageState extends ConsumerState<Changelanguage> {
  @override
  void initState() {
    changeBottomBarColor(ref.read(isDarkModeProvider));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    Color? bodyColor = Theme.of(context).textTheme.bodyMedium!.color;
    final langugae = ref.watch(languageNotifierProvider);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                padding: isTablet()
                    ? const EdgeInsets.only(left: 10)
                    : const EdgeInsets.all(0),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryColor,
                  size: isTablet() ? 16.sp : 24.sp,
                ),
              )
            : null,
        centerTitle: true,
        title: Text(
          transH.changeLanguage.capitalizeFirst.toString(),
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: isTablet() ? 12.sp : 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
      ),
      body: Container(
        width: width,
        height: height * .9,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                transH.english.capitalizeFirst.toString(),
                style: TextStyle(
                  color: bodyColor,
                ),
              ),
              leading: Radio(
                value: const Locale('en'),
                groupValue: langugae,
                onChanged: (value) {
                  ref.read(languageNotifierProvider.notifier).setLocale(value!);
                  ref
                      .read(utlControllerProvider.notifier)
                      .writeData('lang', 'en');
                },
              ),
            ),
            ListTile(
              title: Text(
                transH.french.capitalizeFirst.toString(),
                style: TextStyle(
                  color: bodyColor,
                ),
              ),
              leading: Radio(
                value: const Locale('fr'),
                groupValue: langugae,
                onChanged: (value) {
                  ref.read(languageNotifierProvider.notifier).setLocale(value!);
                  ref
                      .read(utlControllerProvider.notifier)
                      .writeData('lang', 'fr');
                },
              ),
            ),
            ListTile(
              title: Text(
                transH.pidgin.capitalizeFirst.toString(),
                style: TextStyle(
                  color: bodyColor,
                ),
              ),
              leading: Radio(
                value: const Locale('hi'),
                groupValue: langugae,
                onChanged: (value) {
                  ref.read(languageNotifierProvider.notifier).setLocale(value!);
                  ref
                      .read(utlControllerProvider.notifier)
                      .writeData('lang', 'hi');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
