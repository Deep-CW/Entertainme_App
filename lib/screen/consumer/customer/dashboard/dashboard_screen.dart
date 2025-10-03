import 'dart:io';

import 'package:colorful_safe_area/colorful_safe_area.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../widgets/app_loader.dart';
import '../favourite/favourite_controller.dart';
import '../home/home_controller.dart';
import '../notification/notification_controller.dart';
import '../profile/profile_controller.dart';
import 'dashboard_controller.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with TickerProviderStateMixin {
  DashBoardController dashBoardController = Get.put(DashBoardController());

  @override
  void initState() {
    dashBoardController.tabController = TabController(
      length: 4,
      vsync: this,
    );

    dashBoardController.tabController!.addListener(() {
      dashBoardController.currentTab.value =
          dashBoardController.tabController!.index;
    });
    if (dashBoardController.currentTab.value == 0) {
      Get.put(HomeController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          ColorfulSafeArea(
            color: AppColors.white,
            child: Scaffold(
              backgroundColor: Colors.white,
              extendBody: true,
              body: DefaultTabController(
                length: 4,
                child: TabBarView(
                  controller: dashBoardController.tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: dashBoardController.screens,
                ),
              ),
              bottomNavigationBar: Container(
                // height: 82.h,
                color: AppColors.white,
                padding: Platform.isIOS
                    ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h)
                    : EdgeInsets.only(
                        top: 2.h, left: 16.w, right: 16.w, bottom: 10.h),
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: AppColors.customerMain.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: TabBar(
                    controller: dashBoardController.tabController,
                    indicatorColor: AppColors.transparent,
                    labelPadding: EdgeInsets.zero,
                    dividerColor: AppColors.transparent,
                    onTap: (index) {
                      switch (index) {
                        case 1:
                          Get.delete<FavouriteController>();
                          Get.put(FavouriteController());
                          break;
                        case 2:
                          Get.delete<NotificationController>();
                          Get.put(NotificationController());
                          break;
                        case 3:
                          Get.delete<ProfileController>();
                          Get.put(ProfileController());
                          break;
                      }
                    },
                    tabs: [
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              dashBoardController.currentTab.value == 0
                                  ? AppAssets.home_fill_ic
                                  : AppAssets.home_ic,
                              height: 26.h,
                              width: 25.w,
                            ),
                            dashBoardController.currentTab.value == 0
                                ? Padding(
                                    padding: EdgeInsets.only(top: 5.h),
                                    child: Container(
                                      height: 4.h,
                                      width: 4.w,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.customerMain),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                      Obx(
                        () => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                dashBoardController.currentTab.value == 1
                                    ? AppAssets.favourite_fill_ic
                                    : AppAssets.favourite_ic,
                                height: 26.h,
                                width: 25.w,
                              ),
                              dashBoardController.currentTab.value == 1
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: Container(
                                        height: 4.h,
                                        width: 4.w,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.customerMain),
                                      ),
                                    )
                                  : const SizedBox()
                            ]),
                      ),
                      Obx(
                        () => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                dashBoardController.currentTab.value == 2
                                    ? AppAssets.notification_fill_ic
                                    : AppAssets.notification_ic,
                                height: 26.h,
                                width: 25.w,
                              ),
                              dashBoardController.currentTab.value == 2
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: Container(
                                        height: 4.h,
                                        width: 4.w,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.customerMain),
                                      ),
                                    )
                                  : const SizedBox()
                            ]),
                      ),
                      Obx(
                        () => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                dashBoardController.currentTab.value == 3
                                    ? AppAssets.profile_fill_ic
                                    : AppAssets.profile_ic,
                                height: 26.h,
                                width: 25.w,
                              ),
                              dashBoardController.currentTab.value == 3
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: Container(
                                        height: 4.h,
                                        width: 4.w,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.customerMain),
                                      ),
                                    )
                                  : const SizedBox()
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: dashBoardController.loading.value,
            child: appLoader(
              loaderColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
