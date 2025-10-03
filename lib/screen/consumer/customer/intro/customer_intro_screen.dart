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
import '../login/customer_login_screen.dart';
import 'customer_intro_controller.dart';

class CustomerIntroScreen extends StatefulWidget {
  const CustomerIntroScreen({super.key});

  @override
  State<CustomerIntroScreen> createState() => _CustomerIntroScreenState();
}

class _CustomerIntroScreenState extends State<CustomerIntroScreen> {
  CustomerIntroController customerIntroController =
      Get.put(CustomerIntroController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            CarouselSlider.builder(
              carouselController: customerIntroController.carouselController,
              itemCount: customerIntroController.introSlide.length,
              options: CarouselOptions(
                viewportFraction: 1,
                height: Get.height,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  customerIntroController.carouselIndex.value = index;
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
                          customerIntroController.introSlide[index].image,
                          width: double.maxFinite,
                          height: 240.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 10.h),
                        appText(
                          customerIntroController.introSlide[index].title,
                          fontFamily: 'Rochester',
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.customerMain,
                          textAlign: TextAlign.center,
                        ),
                        // Container(
                        //   constraints: BoxConstraints(maxWidth: 300.w),
                        //   child: RichText(
                        //     textAlign: TextAlign.center,
                        //     text: TextSpan(
                        //         text: customerIntroController
                        //             .introSlide[index].title,
                        //         style: TextStyle(
                        //             fontSize: index == 0 ? 40.sp : 30.sp,
                        //             fontWeight: FontWeight.w400,
                        //             color: AppColors.lightBlack,
                        //             fontFamily:
                        //                 index == 0 ? "Rochester" : 'Urbanist'),
                        //         children: [
                        //           TextSpan(
                        //             text: customerIntroController
                        //                 .introSlide[index].subTitle,
                        //             style: TextStyle(
                        //                 fontSize: 40.sp,
                        //                 fontWeight: index == 2
                        //                     ? FontWeight.w400
                        //                     : FontWeight.w700,
                        //                 color: AppColors.customerMain,
                        //                 fontFamily: index == 2
                        //                     ? "Rochester"
                        //                     : 'Urbanist'),
                        //           )
                        //         ]),
                        //   ),
                        // ),
                        SizedBox(height: 25.h),
                        appText(
                          customerIntroController.introSlide[index].subTitle,
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
              AppAssets.customer_intro_bg,
              fit: BoxFit.cover,
            ),
            Obx(
              () => Positioned(
                bottom: 100.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    customerIntroController.introSlide.length,
                    (index) => DotIndicator(
                        activeColor: AppColors.customerMain,
                        inActivecolor: AppColors.mediumGrey,
                        isActive: index ==
                            customerIntroController.carouselIndex.value),
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
                        Get.off(() => const CustomerLoginScreen());
                      },
                      height: 50.w,
                      width: 130.w,
                      borderRadius: BorderRadius.circular(10.r),
                      borderColor: AppColors.customerMain,
                      borderWidth: 1.sp,
                      buttonText: AppStrings.skip,
                      buttonColor: AppColors.transparent,
                      textColor: AppColors.customerMain,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600),
                  SizedBox(width: 15.w),
                  appButton(
                      onTap: () {
                        customerIntroController.carouselIndex.value == 2
                            ? Get.off(() => const CustomerLoginScreen())
                            : customerIntroController.carouselController
                                .nextPage();
                      },
                      height: 50.w,
                      width: 130.w,
                      borderRadius: BorderRadius.circular(10.r),
                      buttonText: AppStrings.next,
                      buttonColor: AppColors.customerMain,
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
