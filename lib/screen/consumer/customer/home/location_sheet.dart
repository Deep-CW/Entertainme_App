import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_colors.dart';

import 'googlemap_search_places.dart';

locationSheet(
  BuildContext context,
) {
  return showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      constraints: BoxConstraints(
          maxHeight: Get.height * 0.7, maxWidth: double.maxFinite),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(20.r),
        topLeft: Radius.circular(20.r),
      )),
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.r),
                topLeft: Radius.circular(20.r),
              ),
              color: AppColors.white,
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.h,
                ),
                child: const GoogleMapSearchPlaces()),
          );
        });
      });
}
