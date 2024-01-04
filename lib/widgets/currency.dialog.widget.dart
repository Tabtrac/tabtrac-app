import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/app_extensions.dart';

import '../constants/app_contants.dart';
import '../helpers/app_fonts.dart';
import '../helpers/functions.dart';
import '../providers/providers.dart';

class CurrencyDialogWidget extends ConsumerWidget {
  const CurrencyDialogWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transH = AppLocalizations.of(context)!;
    final currencies = ref.watch(currencyNotifierProvider);
    double nWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      title: Text(
        transH.selectCurrency.capitalizeFirst.toString(),
        style: TextStyle(
          fontSize: 20.sp,
          fontFamily: AppFonts.actionFont,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
      content: SizedBox(
        width: nWidth,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: dropdownItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                "${returnCurrency(dropdownItems[index].name)} (${dropdownItems[index].name.toUpperCase()})",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              leading: Radio(
                value: dropdownItems[index].name,
                groupValue: currencies,
                onChanged: (value) {
                  ref
                      .read(currencyNotifierProvider.notifier)
                      .changeSelectedIndex(value!);
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            transH.cancel.capitalizeFirst.toString(),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
