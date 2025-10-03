import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';

import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';

import '../../../../services/api_service.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_input_field.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_network_image.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../../../widgets/app_text.dart';
import 'category/category_seeall_screen.dart';
import 'category/category_show_screen.dart';
import 'home_controller.dart';
import 'location_sheet.dart';
import 'neartoyou/neartoyou_screen.dart';
import 'neartoyou/show_neartoyou_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());

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
                backgroundColor: AppColors.white,
                scrolledUnderElevation: 0.0,
                automaticallyImplyLeading: false,
                toolbarHeight: 70.h,
                leadingWidth: 0.0,
                elevation: 0.0,
                // title: Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     SizedBox(
                //       height: 40.h,
                //       width: 40.w,
                //       child: appNetworkImage(
                //         url: homeController.profileImage.value,
                //         loaderColor: AppColors.customerMain,
                //         errorIconSize: 15.sp,
                //         imageBuilder: (context, imageProvider) => Container(
                //           height: 40.h,
                //           width: 40.w,
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: AppColors.darkGrey,
                //             image: DecorationImage(
                //                 fit: BoxFit.cover, image: imageProvider),
                //           ),
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 5.w),
                //     Expanded(
                //       child: Container(
                //         color: Colors.amber,
                //         child: appText(
                //           "${AppStrings.hey}${homeController.userName.value}",
                //           overflow: TextOverflow.ellipsis,
                //           textAlign: TextAlign.left,
                //           fontSize: 14.sp,
                //           fontWeight: FontWeight.w500,
                //           color: AppColors.lightBlack,
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                actions: [
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          height: 40.h,
                          width: 40.w,
                          child: appNetworkImage(
                            url: homeController.profileImage.value,
                            loaderColor: AppColors.customerMain,
                            errorIconSize: 15.sp,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.darkGrey,
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: imageProvider),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: appText(
                            "${AppStrings.hey}${homeController.userName.value}",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5.w),
                  homeController.placeName.isNotEmpty
                      ? Expanded(
                          child: InkWell(
                            onTap: () {
                              if (APIService.internet) {
                                locationSheet(
                                  context,
                                );
                              } else {
                                appSnackbar(
                                  error: true,
                                  content: AppStrings.no_internet,
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  AppAssets.location_ic,
                                  width: 12.w,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 5.w),
                                Expanded(
                                  child: appText(
                                    homeController.placeName.value,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Image.asset(
                                  AppAssets.down_ic,
                                  width: 9.w,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: appButton(
                            onTap: () {
                              if (APIService.internet) {
                                homeController.getCurrentLocation();
                              } else {
                                appSnackbar(
                                  error: true,
                                  content: AppStrings.no_internet,
                                );
                              }
                            },
                            height: 40.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            borderRadius: BorderRadius.circular(10.r),
                            buttonColor: AppColors.customerMain,
                            buttonText: AppStrings.give_permission,
                            textColor: AppColors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                  SizedBox(width: 16.w),
                ],
              ),
              body: Column(
                children: [
                  appInputField(
                      height: 50.h,
                      hintText: AppStrings.search,
                      showSuffix: true,
                      showPrefix: false,
                      suffixImg: AppAssets.search_ic,
                      controller: homeController.searchController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          homeController.searchBusiness.value = true;
                          homeController.getSearchBusiness(value);
                        } else {
                          homeController.searchBusiness.value = false;
                          homeController.getAllBusiness(loader: false);
                        }
                      }),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        // vertical: 20.h,
                        vertical: 5.h,
                      ),
                      child: LazyLoadScrollView(
                        isLoading: homeController.loadingMore.value,
                        scrollOffset: 100,
                        onEndOfPage: () async {
                          if (!homeController.loadingMore.value) {
                            await homeController.moreData();
                          }
                        },
                        child: SmartRefresher(
                          enablePullDown: true,
                          controller: homeController.homeRefreshController,
                          onRefresh: () async {
                            homeController.getCategory();
                            homeController.getBanners();

                            if (homeController.searchBusiness.value) {
                              homeController.getSearchBusiness(
                                  homeController.searchController.text);
                            } else {
                              homeController.getAllBusiness();
                            }
                            homeController.homeRefreshController
                                .refreshCompleted();
                          },
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              //banners
                              homeController.banners.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.w),
                                            child: appText(
                                                AppStrings.latest_offer,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.lightBlack,
                                                textAlign: TextAlign.left),
                                          ),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          CarouselSlider.builder(
                                              itemCount:
                                                  homeController.banners.length,
                                              options: CarouselOptions(
                                                height: 150.h,
                                                viewportFraction: 0.9,
                                                // autoPlay: true,
                                                enableInfiniteScroll: false,
                                                autoPlayInterval:
                                                    const Duration(seconds: 3),
                                                onPageChanged: (index, reason) {
                                                  homeController.carouselIndex
                                                      .value = index;
                                                },
                                              ),
                                              itemBuilder:
                                                  (context, index, realIndex) {
                                                final banner = homeController
                                                    .banners[index];

                                                return Container(
                                                  width: double.maxFinite,
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          index == 0 ? 0 : 10.w,
                                                      top: 5.h,
                                                      bottom: 5.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    boxShadow: banner.locally ??
                                                            false
                                                        ? [
                                                            BoxShadow(
                                                                color: AppColors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.10),
                                                                blurRadius: 4.r)
                                                          ]
                                                        : [],
                                                    image: banner.locally ??
                                                            false
                                                        ? DecorationImage(
                                                            fit: BoxFit.contain,
                                                            image: MemoryImage(
                                                              base64Decode(
                                                                banner.banImg
                                                                    .toString(),
                                                              ),
                                                            ),
                                                          )
                                                        : null,
                                                  ),
                                                  child: !(banner.locally ??
                                                          false)
                                                      ? appNetworkImage(
                                                          url:
                                                              "${AppUrls.BASE_API}${banner.banImg.toString()}",
                                                          loaderColor: AppColors
                                                              .customerMain,
                                                          errorIconSize: 15.sp,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: AppColors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.10),
                                                                    blurRadius:
                                                                        4.r)
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r),
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  image:
                                                                      imageProvider),
                                                            ),
                                                          ),
                                                        )
                                                      : null,
                                                );
                                              }),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                        ])
                                  : const SizedBox(),
                              //category
                              homeController.categories.isNotEmpty
                                  ? Column(children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            appText(AppStrings.categories,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.lightBlack),
                                            InkWell(
                                              onTap: () {
                                                if (APIService.internet) {
                                                  Get.to(
                                                      () =>
                                                          const CategorySeeAllScreen(),
                                                      arguments: {
                                                        "categories":
                                                            homeController
                                                                .categories,
                                                        "current_index": 0,
                                                        "category_name": "",
                                                        "category_id": ""
                                                      });
                                                } else {
                                                  appSnackbar(
                                                    error: true,
                                                    content:
                                                        AppStrings.no_internet,
                                                  );
                                                }
                                              },
                                              child: appText(AppStrings.see_all,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.customerMain,
                                                  fontFamily: 'Inter',
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      AppColors.customerMain),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 14.w,
                                        ),
                                        child: SizedBox(
                                          height: 95.h,
                                          child: ListView.separated(
                                              padding: EdgeInsets.only(
                                                  top: 5.h,
                                                  bottom: 5.h,
                                                  left: 2.w,
                                                  right: 16.w),
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                final category = homeController
                                                    .categories[index];
                                                return InkWell(
                                                  onTap: () {
                                                    if (APIService.internet) {
                                                      Get.to(
                                                          () =>
                                                              const CateShowScreen(),
                                                          arguments: {
                                                            "categories":
                                                                homeController
                                                                    .categories,
                                                            "current_index":
                                                                index,
                                                            "category_name":
                                                                category.catName
                                                                    .toString(),
                                                            "category_id":
                                                                category.catId
                                                                    .toString()
                                                          });
                                                    } else {
                                                      appSnackbar(
                                                        error: true,
                                                        content: AppStrings
                                                            .no_internet,
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 90.h,
                                                    width: 125.w,
                                                    decoration: BoxDecoration(
                                                        color: AppColors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: AppColors
                                                                .black
                                                                .withOpacity(
                                                                    0.25),
                                                            blurRadius: 4.r,
                                                          )
                                                        ]),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: 40.h,
                                                          width: 54.w,
                                                          decoration: category
                                                                      .locally ??
                                                                  false
                                                              ? BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.r),
                                                                  image:
                                                                      DecorationImage(
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    image:
                                                                        MemoryImage(
                                                                      base64Decode(
                                                                        category
                                                                            .catImg
                                                                            .toString(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : null,
                                                          child: !(category
                                                                      .locally ??
                                                                  false)
                                                              ? appNetworkImage(
                                                                  url:
                                                                      "${AppUrls.BASE_API}${category.catImg.toString()}",
                                                                  loaderColor:
                                                                      AppColors
                                                                          .customerMain,
                                                                  height: 40.h,
                                                                  width: 54.w,
                                                                  errorIconSize:
                                                                      15.sp,
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    height:
                                                                        40.h,
                                                                    width: 54.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.r),
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .contain,
                                                                          image:
                                                                              imageProvider),
                                                                    ),
                                                                  ),
                                                                )
                                                              : null,
                                                        ),
                                                        SizedBox(
                                                          height: 6.h,
                                                        ),
                                                        Container(
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth: 90.w,
                                                          ),
                                                          child: appText(
                                                              category.catName
                                                                  .toString(),
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColors
                                                                  .lightBlack,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                        width: 10.w,
                                                      ),
                                              itemCount: homeController
                                                  .categories.length),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                    ])
                                  : const SizedBox(),
                              //near business
                              homeController.allBusinesses.isNotEmpty
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              appText(
                                                homeController.placeName.isEmpty
                                                    ? AppStrings.all_shops
                                                    : AppStrings.near_to_you,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.lightBlack,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (APIService.internet) {
                                                    Get.to(
                                                        () => NearToYouScreen(
                                                              title: homeController
                                                                      .placeName
                                                                      .isEmpty
                                                                  ? AppStrings
                                                                      .all_shops
                                                                  : AppStrings
                                                                      .near_to_you,
                                                            ));
                                                  } else {
                                                    appSnackbar(
                                                      error: true,
                                                      content: AppStrings
                                                          .no_internet,
                                                    );
                                                  }
                                                },
                                                child: appText(
                                                  AppStrings.see_all,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.customerMain,
                                                  fontFamily: 'Inter',
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      AppColors.customerMain,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        GridView.builder(
                                          itemCount: homeController
                                              .allBusinesses.length,
                                          shrinkWrap: true,
                                          cacheExtent: 1000,
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h, horizontal: 16.w),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 16.w,
                                            mainAxisSpacing: 8.h,
                                            childAspectRatio: 0.75,
                                          ),
                                          itemBuilder: (context, index) {
                                            final businesses = homeController
                                                .allBusinesses[index];
                                            String categoryName =
                                                homeController.setCategoryName(
                                                    businesses.businessCategory
                                                        .toString());
                                            return InkWell(
                                              onTap: () {
                                                Get.to(
                                                    () =>
                                                        const ShowNearToYouScreen(),
                                                    arguments: {
                                                      "from": "home",
                                                      "locally":
                                                          businesses.locally,
                                                      "business_id": businesses
                                                          .sId
                                                          .toString(),
                                                      "owner_id": businesses
                                                          .businessOwner!.sId
                                                          .toString(),
                                                      "business_name":
                                                          businesses
                                                              .businessName
                                                              .toString(),
                                                      "business_Detail":
                                                          businesses
                                                              .businessDetail
                                                              .toString(),
                                                      "business_location":
                                                          businesses
                                                              .businessLocationDetails
                                                              .toString(),
                                                      "country_code": businesses
                                                          .businessOwner!
                                                          .countryCode
                                                          .toString(),
                                                      "phone_number": businesses
                                                          .businessOwner!
                                                          .phoneNumber
                                                          .toString(),
                                                      "business_images":
                                                          businesses
                                                              .businessImages!,
                                                      "business_profile":
                                                          businesses
                                                              .businessOwner!
                                                              .ownerImg
                                                              .toString(),
                                                      "ratings": businesses
                                                          .averageRating!,
                                                      "rating_count": businesses
                                                          .ratingCount
                                                          .toString(),
                                                      "favorite":
                                                          businesses.isFavorite,
                                                      "rated": businesses
                                                          .userHasRated,
                                                      "lat": businesses
                                                          .businessLocation!
                                                          .coordinates![1],
                                                      "lng": businesses
                                                          .businessLocation!
                                                          .coordinates![0],
                                                      "opening_hours_1":
                                                          businesses
                                                              .openingHours1,
                                                      "opening_hours_2":
                                                          businesses
                                                              .openingHours2,
                                                      "opening_hours_3":
                                                          businesses
                                                              .openingHours3,
                                                      "opening_hours_4":
                                                          businesses
                                                              .openingHours4,
                                                      "opening_hours_5":
                                                          businesses
                                                              .openingHours5,
                                                      "opening_hours_6":
                                                          businesses
                                                              .openingHours6,
                                                      "opening_hours_7":
                                                          businesses
                                                              .openingHours7,
                                                    });
                                              },
                                              child: Stack(
                                                children: [
                                                  businesses.locally ?? false
                                                      ? Container(
                                                          height: 250.h,
                                                          width: 175.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.r),
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  MemoryImage(
                                                                base64Decode(
                                                                  businesses
                                                                      .businessImages![
                                                                          0]
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : appNetworkImage(
                                                          url:
                                                              "${AppUrls.BASE_API}${businesses.businessImages![0].toString()}",
                                                          loaderColor: AppColors
                                                              .customerMain,
                                                          errorIconSize: 25.sp,
                                                          maxWidthDiskCache:
                                                              1000,
                                                          maxHeightDiskCache:
                                                              1000,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            height: 250.h,
                                                            width: 175.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r),
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      imageProvider),
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
                                                          BorderRadius.circular(
                                                              10.r),
                                                      child: Image.asset(
                                                        AppAssets.overlay_img,
                                                        height: 250.h,
                                                        width: 175.w,
                                                        //width: 54.w,
                                                        //fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),

                                                  // SizedBox(
                                                  //   height: 300.h,
                                                  //   width: 175.w,
                                                  //   child: Image.asset(
                                                  //     AppAssets.overlay_img,
                                                  //     height: 300.h,
                                                  //     width: 175.w,
                                                  //     //width: 54.w,
                                                  //     fit: BoxFit.cover,
                                                  //   ),
                                                  // ),
                                                  Positioned(
                                                    left: 9.w,
                                                    bottom: 13.h,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth: 120.w,
                                                          ),
                                                          child: appText(
                                                              businesses
                                                                  .businessName
                                                                  .toString(),
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColors
                                                                  .white,
                                                              fontFamily:
                                                                  'Inter',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        categoryName.isNotEmpty
                                                            ? appText(
                                                                categoryName,
                                                                fontSize: 10.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .darkWhite,
                                                                fontFamily:
                                                                    'Inter',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start)
                                                            : const SizedBox(),
                                                        categoryName.isNotEmpty
                                                            ? SizedBox(
                                                                height: 5.h)
                                                            : const SizedBox(),
                                                        Row(
                                                          children: [
                                                            RatingBar.builder(
                                                              ignoreGestures:
                                                                  true,
                                                              itemSize: 10.h,
                                                              initialRating:
                                                                  businesses
                                                                      .averageRating!
                                                                      .toDouble(),
                                                              minRating: 1,
                                                              direction: Axis
                                                                  .horizontal,
                                                              allowHalfRating:
                                                                  true,
                                                              itemCount: 5,
                                                              unratedColor:
                                                                  AppColors
                                                                      .darkWhite,
                                                              itemPadding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          2.0.w),
                                                              itemBuilder:
                                                                  (context,
                                                                          _) =>
                                                                      const Icon(
                                                                Icons.star,
                                                                color: AppColors
                                                                    .darkYellow,
                                                              ),
                                                              onRatingUpdate:
                                                                  (rating) {},
                                                            ),
                                                            SizedBox(
                                                              width: 4.w,
                                                            ),
                                                            appText(
                                                                "(${businesses.ratingCount.toString()})",
                                                                fontSize: 10.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'Inter',
                                                                color: AppColors
                                                                    .darkWhite)
                                                          ],
                                                        ),
                                                        homeController.placeName
                                                                .isNotEmpty
                                                            ? SizedBox(
                                                                height: 5.h)
                                                            : const SizedBox(),
                                                        homeController.placeName
                                                                .isNotEmpty
                                                            ? Row(
                                                                children: [
                                                                  Image.asset(
                                                                    AppAssets
                                                                        .distance_ic,
                                                                    width: 10.w,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          4.w),
                                                                  appText(
                                                                      "${businesses.distance!.toInt().ceil().toString()} miles",
                                                                      fontSize:
                                                                          10.sp,
                                                                      fontWeight: FontWeight
                                                                          .w400,
                                                                      fontFamily:
                                                                          'Inter',
                                                                      color: AppColors
                                                                          .darkWhite)
                                                                ],
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
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
                              homeController.loadingMore.value
                                  ? Container(
                                      padding: EdgeInsets.only(top: 10.h),
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
                ],
              ),
            ),
          ),
          Visibility(
            visible: homeController.loading.value,
            child: appLoader(
              loaderColor: AppColors.transparent,
              giveOpacity: false,
            ),
          ),
        ],
      ),
    );
  }
}
