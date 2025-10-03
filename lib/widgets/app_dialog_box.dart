import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constant/app_colors.dart';
import 'app_button.dart';
import 'app_text.dart';

appDialogBox({
  required String title,
  required String content,
  required String confirmText,
  required String cancelText,
  required Function()? confirm,
  required Color confirmBtnColor,
  Color? textColor,
  Color? borderColor,
  double? width,
  EdgeInsets? contentPadding,
  bool? showShadow,
}) {
  Get.defaultDialog(
    radius: 10.r,
    backgroundColor: AppColors.white,
    contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 20.w),
    titlePadding: EdgeInsets.symmetric(vertical: 10.h),
    title: title,
    titleStyle: TextStyle(
      color: AppColors.black,
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
    ),
    content: Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: appText(
        content,
        color: AppColors.black,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appButton(
              onTap: () {
                Get.back();
              },
              height: 33.h,
              width: width ?? 115.w,
              borderRadius: BorderRadius.circular(10.r),
              borderWidth: 1.w,
              borderColor: AppColors.black,
              buttonColor: AppColors.white,
              textColor: AppColors.black,
              buttonText: cancelText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(
              width: 10.w,
            ),
            InkWell(
              onTap: confirm,
              child: Container(
                height: 33.h,
                width: width ?? 115.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: confirmBtnColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: borderColor ?? Colors.transparent),
                  boxShadow: showShadow == true
                      ? [
                          BoxShadow(
                            blurRadius: 4.r,
                            color: AppColors.black.withOpacity(0.25),
                            offset: const Offset(0, 0),
                          ),
                        ]
                      : [],
                ),
                child: appText(
                  confirmText,
                  color: textColor ?? AppColors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
