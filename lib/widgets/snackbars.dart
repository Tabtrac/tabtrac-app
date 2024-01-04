import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/colors.dart';

errorSnackBar({
  BuildContext? context,
  required String title,
  required String message,
}) {
  Fluttertoast.showToast(
    msg: "$title, $message",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 14.sp,
  );
}

successSnackBar({
  BuildContext? context,
  required String title,
  required String message,
}) {
  Fluttertoast.showToast(
    msg: "$title, $message",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.success,
    textColor: Colors.white,
    fontSize: 14.sp,
  );
}
