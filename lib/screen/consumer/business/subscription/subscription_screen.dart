// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../constant/app_assets.dart';
import '../../../../../constant/app_colors.dart';
import '../../../../../widgets/app_button.dart';
import '../../../../constant/app_list.dart';
import '../../../../constant/app_strings.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_text.dart';
import 'subscription_controller.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionController subscriptionController =
      Get.put(SubscriptionController());

  @override
  void initState() {
    subscriptionController.purchaseUpdate();
    subscriptionController.getSaving();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              scrolledUnderElevation: 0.0,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              toolbarHeight: 70.h,
              centerTitle: true,
              title: Container(
                height: 63.h,
                width: 65.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(AppAssets.logo_img),
                  ),
                ),
              ),
            ),
            body: Container(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Container(
                    //   height: 63.h,
                    //   width: 65.w,
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //       fit: BoxFit.contain,
                    //       image: AssetImage(AppAssets.logo_img),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 20.h),
                    appText(
                      AppStrings.unlock_premium,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightBlack,
                    ),
                    SizedBox(height: 5.h),
                    SvgPicture.asset(
                      AppAssets.premium_img,
                      height: 200.h,
                      fit: BoxFit.contain,
                    ),
                    // Image.asset(
                    //   AppAssets.subscription_img,
                    //   width: double.maxFinite,
                    //   height: 214.h,
                    //   fit: BoxFit.fitHeight,
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 60.w),
                    //   child:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: Container(
                            height: 10.h,
                            width: 10.w,
                            decoration: const BoxDecoration(
                              color: AppColors.businessMain,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: appText(
                            AppStrings.business_visible,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightBlack,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    // ),
                    SizedBox(height: 10.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: Container(
                            height: 10.h,
                            width: 10.w,
                            decoration: const BoxDecoration(
                              color: AppColors.businessMain,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: appText(
                            AppStrings.add_exclusive,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightBlack,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                          maxWidth: double.maxFinite, maxHeight: 150.h),
                      child: ListView.separated(
                        itemCount: AppList.subscriptionList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 10.w),
                        itemBuilder: (context, index) {
                          return Obx(
                            () => InkWell(
                              onTap: () {
                                subscriptionController
                                    .selectSubscription.value = index;
                              },
                              // child: Stack(
                              //   alignment: Alignment.topCenter,
                              //   clipBehavior: Clip.none,
                              //   children: [
                              //     Center(
                              child: Container(
                                // height: 180.h,
                                width: 100.w,
                                // padding: EdgeInsets.only(
                                //     bottom: 10.h, left: 8.w, right: 8.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.r),
                                  color: subscriptionController
                                              .selectSubscription.value ==
                                          index
                                      ? AppColors.businessMain.withOpacity(0.1)
                                      : AppColors.white,
                                  border: Border.all(
                                    color: subscriptionController
                                                .selectSubscription.value ==
                                            index
                                        ? AppColors.businessMain
                                        : AppColors.darkGrayShade,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 5.h),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                          color: AppList
                                                  .subscriptionList[index]
                                                      ['save']
                                                  .isEmpty
                                              ? AppColors.transparent
                                              : subscriptionController
                                                          .selectSubscription
                                                          .value ==
                                                      index
                                                  ? AppColors.businessMain
                                                  : AppColors.businessMain
                                                      .withOpacity(0.5),
                                        ),
                                        child: appText(
                                            AppList
                                                    .subscriptionList[index]
                                                        ['save']
                                                    .isEmpty
                                                ? ''
                                                : 'Save ${AppList.subscriptionList[index]['save']}%',
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.white),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      child: appText(
                                          AppList.subscriptionList[index]
                                              ['duration'],
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightBlack),
                                    ),
                                    SizedBox(height: 10.h),
                                    // index == 1
                                    //     ? Padding(
                                    //         padding: EdgeInsets.only(
                                    //             bottom: 7.h),
                                    //         child: appText(
                                    //             AppStrings.days_free,
                                    //             fontSize: 12.sp,
                                    //             fontWeight: FontWeight.w700,
                                    //             color:
                                    //                 AppColors.businessMain),
                                    //       )
                                    //     : const SizedBox(),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      child: appText(
                                          AppList.subscriptionList[index]
                                                  ['currency'] +
                                              AppList.subscriptionList[index]
                                                  ['price'],
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.lightBlack),

                                      // child: Expanded(
                                      //   flex: 2,
                                      //   child: RichText(
                                      //     text: TextSpan(
                                      //         text:
                                      //             AppList.subscriptionList[index]
                                      //                 ['price'],
                                      //         style: TextStyle(
                                      //           fontSize: 12.sp,
                                      //           fontWeight: FontWeight.w700,
                                      //           color: AppColors.lightBlack,
                                      //         ),
                                      //         children: [
                                      //           TextSpan(
                                      //             text: AppList
                                      //                     .subscriptionList[index]
                                      //                 ['description'],
                                      //             style: TextStyle(
                                      //               fontSize: 10.sp,
                                      //               fontWeight: FontWeight.w500,
                                      //               color: AppColors.lightBlack,
                                      //             ),
                                      //           )
                                      //         ]),
                                      //   ),
                                      // ),
                                    ),
                                    SizedBox(height: 10.h),
                                    const Spacer(),
                                    Image.asset(
                                      AppList.subscriptionList[index]['image'],
                                      height: 20.h,
                                      width: 30.w,
                                      color: subscriptionController
                                                  .selectSubscription.value ==
                                              index
                                          ? AppColors.businessMain
                                          : AppColors.mediumGrey,
                                    ),
                                    SizedBox(height: 10.h),
                                  ],
                                ),
                              ),
                            ),
                            // index == 1
                            //     ? Positioned(
                            //         top: -12,
                            //         child: Container(
                            //           height: 22.h,
                            //           width: 64.w,
                            //           alignment: Alignment.center,
                            //           decoration: BoxDecoration(
                            //               borderRadius:
                            //                   BorderRadius.circular(20.r),
                            //               color: AppColors.businessMain),
                            //           child: appText(AppStrings.save_text,
                            //               fontSize: 10.sp,
                            //               fontWeight: FontWeight.w700),
                            //         ),
                            //       )
                            //     : const SizedBox(),
                            //     ],
                            //   ),
                            // ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30.h),
                    appButton(
                        onTap: () async {
                          // subscriptionController.purchasePackage();
                          subscriptionController.loading.value = true;
                          await subscriptionController.addPurchase();
                          subscriptionController.loading.value = false;
                        },
                        height: 61.h,
                        width: double.maxFinite,
                        buttonText: AppStrings.buy,
                        buttonColor: AppColors.businessMain,
                        textColor: AppColors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700),
                    // SizedBox(
                    //   height: 24.h,
                    // ),
                    // appText(AppStrings.notice,
                    //     fontSize: 13.sp,
                    //     fontWeight: FontWeight.w500,
                    //     color: AppColors.darkGrey)
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: subscriptionController.loading.value,
            child: appLoader(
              loaderColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
