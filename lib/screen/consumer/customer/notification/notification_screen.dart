import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../constant/app_colors.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_network_image.dart';
import '../../../../widgets/app_text.dart';
import 'notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          ColorfulSafeArea(
            color: AppColors.white,
            child: Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.white,
                scrolledUnderElevation: 0.0,
                elevation: 0.0,
                toolbarHeight: 40.h,
                centerTitle: true,
                title: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: appText(AppStrings.notification,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightBlack),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.only(
                  left: 8.w,
                  right: 8.w,
                  top: 15.h,
                ),
                child: SmartRefresher(
                  enablePullDown: true,
                  controller:
                      notificationController.notificationRefreshController,
                  onRefresh: () {
                    notificationController.getNotification();
                    notificationController.notificationRefreshController
                        .refreshCompleted();
                  },
                  child: notificationController.notifications.isNotEmpty
                      ? ListView.separated(
                          itemCount:
                              notificationController.notifications.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              left: 5.w, right: 5.w, top: 5.h, bottom: 20.h),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 15.h),
                          itemBuilder: (BuildContext context, int index) {
                            var notification =
                                notificationController.notifications[index];

                            return InkWell(
                              onTap: () {
                                notificationController.openNotification(
                                    notification.action.toString(),
                                    businessDetails:
                                        notification.businessDetails,
                                    ownerId: notification.ownerId);
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: 85.h,
                                  maxWidth: double.maxFinite,
                                ),
                                // height: 85.h,
                                // width: double.maxFinite,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.h, horizontal: 12.w),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(5.r),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            AppColors.black.withOpacity(0.25),
                                        blurRadius: 4.r)
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 20.h,
                                              width: 20.w,
                                              child: appNetworkImage(
                                                url:
                                                    "${AppUrls.BASE_API}${notification.img.toString()}",
                                                loaderColor:
                                                    AppColors.customerMain,
                                                errorIconSize: 15.h,
                                                height: 20.h,
                                                width: 20.w,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 20.h,
                                                  width: 20.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.r),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: imageProvider,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5.w),
                                            appText(
                                              notification.title.toString(),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.lightBlack,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 4.w),
                                          child: appText(
                                            notification.timeAgo.toString(),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.lightBlack
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 7.h),
                                    Container(
                                      constraints:
                                          BoxConstraints(maxHeight: 27.h),
                                      child: appText(
                                        notification.message,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.lightBlack,
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: appText(
                            AppStrings.no_notification,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            color: AppColors.lightBlack,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: notificationController.loading.value,
            child: appLoader(
              loaderColor: AppColors.white,
              giveOpacity: false,
            ),
          ),
        ],
      ),
    );
  }
}
