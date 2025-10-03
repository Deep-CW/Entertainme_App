// ignore_for_file: must_be_immutable

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../constant/app_assets.dart';
import '../../../../../constant/app_colors.dart';
import '../../../../../constant/app_urls.dart';
import '../../../../../widgets/app_appbar.dart';
import '../../../../../widgets/app_loader.dart';
import '../../../../../widgets/app_network_image.dart';
import '../../../../../widgets/app_text.dart';
import '../home_controller.dart';
import 'neartoyou_controller.dart';
import 'show_neartoyou_screen.dart';

class NearToYouScreen extends StatefulWidget {
  String title;

  NearToYouScreen({
    super.key,
    required this.title,
  });

  @override
  State<NearToYouScreen> createState() => _NearToYouScreenState();
}

class _NearToYouScreenState extends State<NearToYouScreen> {
  HomeController homeController = Get.put(HomeController());
  NearToTouController nearToTouController = Get.put(NearToTouController());

  @override
  void initState() {
    nearToTouController.getAllBusiness();

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
              backgroundColor: AppColors.white,
              appBar: appAppBar(
                title: widget.title,
                onTap: () {
                  Get.back();
                },
              ),
              body: LazyLoadScrollView(
                isLoading: nearToTouController.loadingMore.value,
                scrollOffset: 100,
                onEndOfPage: () async {
                  if (!nearToTouController.loadingMore.value) {
                    await nearToTouController.moreData();
                  }
                },
                child: SmartRefresher(
                  enablePullDown: true,
                  controller: nearToTouController.neartoyouRefreshController,
                  onRefresh: () {
                    nearToTouController.getAllBusiness();
                    nearToTouController.neartoyouRefreshController
                        .refreshCompleted();
                  },
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      nearToTouController.allBusinesses.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.h, horizontal: 16.w),
                              child: GridView.builder(
                                itemCount:
                                    nearToTouController.allBusinesses.length,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                cacheExtent: 1000,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 8.h,
                                  childAspectRatio: 0.75,
                                ),
                                itemBuilder: (context, index) {
                                  final allBusiness =
                                      nearToTouController.allBusinesses[index];
                                  String categoryName =
                                      homeController.setCategoryName(allBusiness
                                          .businessCategory
                                          .toString());

                                  return InkWell(
                                    onTap: () {
                                      Get.delete<NearToTouController>();
                                      Get.to(() => const ShowNearToYouScreen(),
                                          arguments: {
                                            "from": "near",
                                            "business_id":
                                                allBusiness.sId.toString(),
                                            "owner_id": allBusiness
                                                .businessOwner!.sId
                                                .toString(),
                                            "business_name": allBusiness
                                                .businessName
                                                .toString(),
                                            "business_Detail": allBusiness
                                                .businessDetail
                                                .toString(),
                                            "business_location": allBusiness
                                                .businessLocationDetails
                                                .toString(),
                                            "country_code": allBusiness
                                                .businessOwner!.countryCode
                                                .toString(),
                                            "phone_number": allBusiness
                                                .businessOwner!.phoneNumber
                                                .toString(),
                                            "business_images":
                                                allBusiness.businessImages!,
                                            "business_profile": allBusiness
                                                .businessOwner!.ownerImg
                                                .toString(),
                                            "ratings":
                                                allBusiness.averageRating!,
                                            "rating_count": allBusiness
                                                .ratingCount
                                                .toString(),
                                            "favorite": allBusiness.isFavorite,
                                            "rated": allBusiness.userHasRated,
                                            "lat": allBusiness.businessLocation!
                                                .coordinates![1],
                                            "lng": allBusiness.businessLocation!
                                                .coordinates![0],
                                            "opening_hours_1":
                                                allBusiness.openingHours1,
                                            "opening_hours_2":
                                                allBusiness.openingHours2,
                                            "opening_hours_3":
                                                allBusiness.openingHours3,
                                            "opening_hours_4":
                                                allBusiness.openingHours4,
                                            "opening_hours_5":
                                                allBusiness.openingHours5,
                                            "opening_hours_6":
                                                allBusiness.openingHours6,
                                            "opening_hours_7":
                                                allBusiness.openingHours7,
                                          });
                                    },
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          child: appNetworkImage(
                                            url:
                                                "${AppUrls.BASE_API}${allBusiness.businessImages![0].toString()}",
                                            loaderColor: AppColors.customerMain,
                                            errorIconSize: 25.sp,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 250.h,
                                              width: 175.w,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: imageProvider),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: -3,
                                          right: -3,
                                          bottom: -6,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            child: Image.asset(
                                              AppAssets.overlay_img,
                                              height: 250.h,
                                              width: 175.w,
                                              //width: 54.w,
                                              //fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 9.w,
                                          bottom: 13.h,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                  maxWidth: 150.w,
                                                ),
                                                child: appText(
                                                    allBusiness.businessName
                                                        .toString(),
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.white,
                                                    fontFamily: 'Inter',
                                                    textAlign: TextAlign.start,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              categoryName.isNotEmpty
                                                  ? appText(categoryName,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.darkWhite,
                                                      fontFamily: 'Inter')
                                                  : const SizedBox(),
                                              categoryName.isNotEmpty
                                                  ? SizedBox(height: 5.h)
                                                  : const SizedBox(),
                                              Row(
                                                children: [
                                                  RatingBar.builder(
                                                    ignoreGestures: true,
                                                    itemSize: 10.h,
                                                    initialRating: allBusiness
                                                        .averageRating!
                                                        .toDouble(),
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: false,
                                                    itemCount: 5,
                                                    unratedColor:
                                                        AppColors.darkWhite,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2.0.w),
                                                    itemBuilder: (context, _) =>
                                                        const Icon(
                                                      Icons.star,
                                                      color:
                                                          AppColors.darkYellow,
                                                    ),
                                                    onRatingUpdate: (rating) {},
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  appText(
                                                    "(${allBusiness.ratingCount.toString()})",
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Inter',
                                                    color: AppColors.darkWhite,
                                                  )
                                                ],
                                              ),
                                              homeController
                                                      .placeName.isNotEmpty
                                                  ? SizedBox(height: 5.h)
                                                  : const SizedBox(),
                                              homeController
                                                      .placeName.isNotEmpty
                                                  ? Row(
                                                      children: [
                                                        Image.asset(
                                                          AppAssets.distance_ic,
                                                          width: 10.w,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        SizedBox(
                                                          width: 4.w,
                                                        ),
                                                        appText(
                                                          "${allBusiness.distance!.toInt().ceil().toString()} miles",
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: 'Inter',
                                                          color: AppColors
                                                              .darkWhite,
                                                        )
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: appText(
                                'No Businesses Found!',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                                textAlign: TextAlign.center,
                              ),
                            ),
                      nearToTouController.loadingMore.value
                          ? Container(
                              padding: EdgeInsets.only(bottom: 10.h),
                              alignment: Alignment.center,
                              child: const CupertinoActivityIndicator(
                                color: AppColors.customerMain,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: nearToTouController.loading.value,
            child: appLoader(
              loaderColor: AppColors.white,
              onWillPop: false,
            ),
          ),
        ],
      ),
    );
  }
}
