import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constant/app_assets.dart';
import '../../constant/app_colors.dart';
import '../../constant/app_constants.dart';
import '../../constant/app_strings.dart';
import '../../main.dart';
import '../../widgets/app_button.dart';
import 'business/intro/business_intro_screen.dart';
import 'customer/intro/customer_intro_screen.dart';

class ConsumerScreen extends StatefulWidget {
  const ConsumerScreen({super.key});

  @override
  State<ConsumerScreen> createState() => _ConsumerScreenState();
}

class _ConsumerScreenState extends State<ConsumerScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ColorfulSafeArea(
        color: AppColors.white,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            child: Column(
              children: [
                Image.asset(
                  AppAssets.logo_img,
                  height: 102.h,
                  width: 108.w,
                ),
                SizedBox(
                  height: 35.h,
                ),
                Image.asset(
                  AppAssets.consumer_img,
                  width: double.maxFinite,
                  height: 290.h,
                  //  fit: BoxFit.cover,
                ),
                const Spacer(),
                appButton(
                    onTap: () {
                      if (box.read(AppConstants.EMAIL_ID_USER) != null) {
                        box.write(AppConstants.EMAIL_ID,
                            box.read(AppConstants.EMAIL_ID_USER).toString());
                        box.write(AppConstants.PASSWORD,
                            box.read(AppConstants.PASSWORD_USER).toString());
                      }
                      Get.offAll(() => const CustomerIntroScreen());
                    },
                    height: 61.h,
                    width: double.maxFinite,
                    borderRadius: BorderRadius.circular(15.r),
                    buttonColor: AppColors.customerMain,
                    buttonText: AppStrings.user_text,
                    textColor: AppColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700),
                SizedBox(
                  height: 25.h,
                ),
                appButton(
                    onTap: () {
                      if (box.read(AppConstants.EMAIL_ID_BUSINESS) != null) {
                        box.write(
                            AppConstants.EMAIL_ID,
                            box
                                .read(AppConstants.EMAIL_ID_BUSINESS)
                                .toString());
                        box.write(
                            AppConstants.PASSWORD,
                            box
                                .read(AppConstants.PASSWORD_BUSINESS)
                                .toString());
                      }
                      Get.offAll(() => const BusinessIntroScreen());
                    },
                    height: 61.h,
                    width: double.maxFinite,
                    borderRadius: BorderRadius.circular(15.r),
                    buttonColor: AppColors.businessMain,
                    buttonText: AppStrings.businessOwner_text,
                    textColor: AppColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
