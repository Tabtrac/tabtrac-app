import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import '../providers/providers.dart';

class FormInput extends ConsumerWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool isLast;
  final double? width;
  final bool? disabled;
  final BorderRadiusGeometry? borderRadius;
  const FormInput(
    this.width, {
    super.key,
    required this.controller,
    required this.hintText,
    required this.isLast,
    required this.isPassword,
    this.borderRadius,
    this.disabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obSecure = ref.watch(obSecureProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    if (isPassword) {
      return LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Container(
            decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkThemeShade.withOpacity(.3)
                    : AppColors.lightThemeShade.withOpacity(.3),
                borderRadius: borderRadius ?? BorderRadius.circular(30),
                border: Border.all(
                    color: AppColors.greyColor.withOpacity(.2), width: .7)),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontSize: 10.sp,
                    ),
                    readOnly: disabled != null ? disabled! : false,
                    textInputAction:
                        isLast ? TextInputAction.go : TextInputAction.next,
                    obscureText: isPassword ? obSecure : false,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      hintText: hintText,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(obSecureProvider.notifier).changeState(!obSecure);
                  },
                  child: Icon(
                    obSecure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.greyColor,
                    size: 16.sp,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkThemeShade.withOpacity(.3)
                    : AppColors.lightThemeShade.withOpacity(.3),
                borderRadius: borderRadius ?? BorderRadius.circular(30),
                border: Border.all(
                    color: AppColors.greyColor.withOpacity(.2), width: .7)),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontSize: 14.sp,
                    ),
                    readOnly: disabled != null ? disabled! : false,
                    textInputAction:
                        isLast ? TextInputAction.go : TextInputAction.next,
                    obscureText: isPassword ? obSecure : false,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      hintText: hintText,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(obSecureProvider.notifier).changeState(!obSecure);
                  },
                  child: Icon(
                    obSecure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.greyColor,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          );
        }
      });
    } else {
      return LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Container(
            decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkThemeShade.withOpacity(.3)
                    : AppColors.lightThemeShade.withOpacity(.3),
                borderRadius: borderRadius ?? BorderRadius.circular(30),
                border: Border.all(
                    color: AppColors.greyColor.withOpacity(.2), width: .7)),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            alignment: Alignment.center,
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
                fontSize: 10.sp,
              ),
              readOnly: disabled != null ? disabled! : false,
              textInputAction:
                  isLast ? TextInputAction.go : TextInputAction.next,
              obscureText: isPassword ? obSecure : false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                hintText: hintText,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppColors.greyColor,
                  fontSize: 10.sp,
                ),
              ),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkThemeShade.withOpacity(.3)
                    : AppColors.lightThemeShade.withOpacity(.3),
                borderRadius: borderRadius ?? BorderRadius.circular(30),
                border: Border.all(
                    color: AppColors.greyColor.withOpacity(.2), width: .7)),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
            alignment: Alignment.center,
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
                fontSize: 14.sp,
              ),
              readOnly: disabled != null ? disabled! : false,
              textInputAction:
                  isLast ? TextInputAction.go : TextInputAction.next,
              obscureText: isPassword ? obSecure : false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                hintText: hintText,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppColors.greyColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          );
        }
      });
    }
  }
}
