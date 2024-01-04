import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoActivity extends StatelessWidget {
  final double width;
  const NoActivity({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final transH = AppLocalizations.of(context)!;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/svgs/sad.svg'),
          SizedBox(height: 10.h),
          Text(
            transH.noActivity.capitalize(),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            transH.noActivityMessage.capitalize(),
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}