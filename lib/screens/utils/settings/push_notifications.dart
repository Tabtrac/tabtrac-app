import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundz_app/helpers/functions.dart';

import '../../../helpers/app_fonts.dart';

class PushNotifcationSetting extends ConsumerStatefulWidget {
  const PushNotifcationSetting({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PushNotifcationSettingState();
}

class _PushNotifcationSettingState
    extends ConsumerState<PushNotifcationSetting> {
  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            CupertinoIcons.arrow_left,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        centerTitle: false,
        title: Text(
          transH.pushNotifications.capitalizeAll(),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
            fontFamily: AppFonts.actionFont,
            // fontSize: width * .01 + 16
          ),
        ),
      ),
    );
  }
}
