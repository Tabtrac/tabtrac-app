import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fundz_app/helpers/functions.dart';

import '../../../../constants/colors.dart';
import '../../../../helpers/app_fonts.dart';

class EachClient extends ConsumerWidget {
  final double width;
  final String name;
  final String? email;
  final String? phoneNumber;
  final void Function()? onTap;
  const EachClient({
    super.key,
    required this.width,
    required this.name,
    this.email,
    this.onTap,
    this.phoneNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor.withOpacity(.5)),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 40.w,
              height: 35.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(.5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontFamily: AppFonts.actionFont,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        name.capitalizeAll(),
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      if (phoneNumber != null &&
                          email != null &&
                          email != '' &&
                          phoneNumber != '')
                        Text(
                          phoneNumber.toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.greyColor,
                          ),
                        )
                      else if (phoneNumber != null && phoneNumber != '')
                        Text(
                          phoneNumber.toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.greyColor,
                          ),
                        )
                      else if (email != null && email != '')
                        Text(
                          email.toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.greyColor,
                          ),
                        )
                      else
                        const SizedBox(),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      if (phoneNumber != null && phoneNumber != '')
                        IconButton(
                          onPressed: () {
                            launchPhoneCall(phoneNumber.toString());
                          },
                          icon: Icon(
                            Icons.phone_outlined,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      if (email != null && email != '')
                        IconButton(
                          onPressed: () {
                            launchEmail(phoneNumber.toString(), 'Tabtrac', '');
                          },
                          icon: Icon(
                            Icons.mail_outline,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
