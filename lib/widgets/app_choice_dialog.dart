// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constant/app_colors.dart';
import '../constant/app_constants.dart';
import '../constant/app_strings.dart';

import '../main.dart';
import '../services/image_service.dart';
import 'app_text.dart';

//show dialog box - gallery/camera
showChoiceDialog({required Color color}) async {
  var pickedFile;

  await showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        title: appText(
          AppStrings.choose_option,
          textAlign: TextAlign.left,
          color: AppColors.black,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                height: 1.h,
                color: AppColors.black.withOpacity(0.5),
              ),
              InkWell(
                onTap: () async {
                  box.write(AppConstants.IS_NETWORK_IMG, false);
                  pickedFile = await ImageService.openGallery();
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_box,
                        size: 20.sp,
                        color: color,
                      ),
                      SizedBox(width: 20.w),
                      appText(
                        AppStrings.gallery,
                        textAlign: TextAlign.left,
                        color: AppColors.lightBlack,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.h,
                color: AppColors.lightBlack.withOpacity(0.5),
              ),
              InkWell(
                onTap: () async {
                  box.write(AppConstants.IS_NETWORK_IMG, false);
                  pickedFile = await ImageService.openCamera();
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera,
                        size: 20.sp,
                        color: color,
                      ),
                      SizedBox(width: 20.w),
                      appText(
                        AppStrings.camera,
                        textAlign: TextAlign.left,
                        color: AppColors.lightBlack,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  return pickedFile;
}
