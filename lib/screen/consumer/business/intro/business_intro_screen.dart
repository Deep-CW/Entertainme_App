// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_strings.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/dot_indicator.dart';
import '../login/login_screen.dart';
import 'business_intro_controller.dart';

class BusinessIntroScreen extends StatefulWidget {
  const BusinessIntroScreen({super.key});

  @override
  State<BusinessIntroScreen> createState() => _BusinessIntroScreenState();
}

class _BusinessIntroScreenState extends State<BusinessIntroScreen> {
  BusinessIntroController businessIntroController =
      Get.put(BusinessIntroController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            CarouselSlider.builder(
              carouselController: businessIntroController.carouselController,
              itemCount: businessIntroController.introSlide.length,
              options: CarouselOptions(
                viewportFraction: 1,
                height: Get.height,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  businessIntroController.carouselIndex.value = index;
                },
              ),
              itemBuilder: (context, index, realIndex) => Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        SizedBox(height: 30.h),
                        Image.asset(
                          businessIntroController.introSlide[index].image,
                          width: double.maxFinite,
                          height: 240.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 10.h),
                        appText(
                          businessIntroController.introSlide[index].title,
                          fontFamily: 'Rochester',
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.businessMain,
                          textAlign: TextAlign.center,
                        ),
                        // Container(
                        //   constraints: BoxConstraints(maxWidth: 300.w),
                        //   child: RichText(
                        //     textAlign: TextAlign.center,
                        //     text: TextSpan(
                        //         text: businessIntroController
                        //             .introSlide[index].title,
                        //         style: TextStyle(
                        //             fontSize: index == 0 ? 40.sp : 30.sp,
                        //             fontWeight: FontWeight.w400,
                        //             color: AppColors.lightBlack,
                        //             fontFamily:
                        //                 index == 0 ? "Rochester" : 'Urbanist'),
                        //         children: [
                        //           TextSpan(
                        //             text: businessIntroController
                        //                 .introSlide[index].subTitle,
                        //             style: TextStyle(
                        //                 fontSize: 40.sp,
                        //                 fontWeight: index == 2
                        //                     ? FontWeight.w400
                        //                     : FontWeight.w700,
                        //                 color: AppColors.businessMain,
                        //                 fontFamily: index == 2
                        //                     ? "Rochester"
                        //                     : 'Urbanist'),
                        //           )
                        //         ]),
                        //   ),
                        // ),
                        SizedBox(height: 25.h),
                        appText(
                          businessIntroController.introSlide[index].subTitle,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightBlack,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
                alignment: Alignment.bottomCenter,
              ),
            ),
            Image.asset(
              AppAssets.business_intro_bg,
              fit: BoxFit.cover,
            ),
            Obx(
              () => Positioned(
                bottom: 100.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    businessIntroController.introSlide.length,
                    (index) => DotIndicator(
                        activeColor: AppColors.businessMain,
                        inActivecolor: AppColors.mediumGrey,
                        isActive: index ==
                            businessIntroController.carouselIndex.value),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40.h,
              child: Row(
                children: [
                  appButton(
                      onTap: () {
                        Get.off(() => const LoginScreen());
                      },
                      height: 50.w,
                      width: 130.w,
                      borderRadius: BorderRadius.circular(10.r),
                      borderColor: AppColors.businessMain,
                      borderWidth: 1.sp,
                      buttonText: AppStrings.skip,
                      buttonColor: AppColors.transparent,
                      textColor: AppColors.businessMain,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600),
                  SizedBox(width: 15.w),
                  appButton(
                      onTap: () {
                        businessIntroController.carouselIndex.value == 2
                            ? Get.off(() => const LoginScreen())
                            : businessIntroController.carouselController
                                .nextPage();
                      },
                      height: 50.w,
                      width: 130.w,
                      borderRadius: BorderRadius.circular(10.r),
                      buttonText: AppStrings.next,
                      buttonColor: AppColors.businessMain,
                      textColor: AppColors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700),
                ],
              ),
            ),
          ],
          alignment: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
