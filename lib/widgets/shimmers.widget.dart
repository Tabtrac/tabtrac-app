import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/colors.dart';

class RecordActivityShimmer extends StatelessWidget {
  const RecordActivityShimmer({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyColor.withOpacity(.5),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(.5),
              borderRadius: BorderRadius.circular(99),
            ),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: 50,
                      margin: const EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors.greyColor.withOpacity(.5),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    Container(
                      height: 10,
                      width: 80,
                      margin: const EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors.greyColor.withOpacity(.5),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 8,
                      width: 50,
                      margin: const EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors.greyColor.withOpacity(.5),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    Container(
                      height: 10,
                      width: 70,
                      margin: const EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors.greyColor.withOpacity(.5),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  const ShimmerBox({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: AppColors.greyColor.withOpacity(.5),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class CleintDetailsShimmer extends StatelessWidget {
  const CleintDetailsShimmer({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor.withOpacity(.5),
      highlightColor: AppColors.primaryColor,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ShimmerBox(width: width * .2, height: 7),
            ShimmerBox(width: width * .4, height: 10),
            ShimmerBox(width: width, height: 2),
            SizedBox(height: 10.h),
            ShimmerBox(width: width * .2, height: 7),
            ShimmerBox(width: width * .4, height: 10),
            ShimmerBox(width: width, height: 2),
            SizedBox(height: 10.h),
            ShimmerBox(width: width * .2, height: 7),
            ShimmerBox(width: width * .4, height: 10),
            ShimmerBox(width: width, height: 2),
            SizedBox(height: 10.h),
            ShimmerBox(width: width * .2, height: 7),
            ShimmerBox(width: width * .4, height: 10),
            ShimmerBox(width: width, height: 2),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.center,
              child: ShimmerBox(width: width * .3, height: 10),
            ),
            Align(
              alignment: Alignment.center,
              child: ShimmerBox(width: width * .6, height: 25.h),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) =>
                  RecordActivityShimmer(width: width),
            ),
          ],
        ),
      ),
    );
  }
}
