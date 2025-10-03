import 'dart:ui';

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
import '../../../../../constant/app_strings.dart';
import '../../../../../constant/app_urls.dart';
import '../../../../../services/api_service.dart';
import '../../../../../widgets/app_appbar.dart';
import '../../../../../widgets/app_input_field.dart';
import '../../../../../widgets/app_loader.dart';
import '../../../../../widgets/app_network_image.dart';
import '../../../../../widgets/app_snackbar.dart';
import '../../../../../widgets/app_text.dart';
import '../home_controller.dart';
import '../neartoyou/show_neartoyou_screen.dart';
import 'category_controller.dart';
import 'filter_category_screen.dart';

class CateShowScreen extends StatefulWidget {
  const CateShowScreen({
    super.key,
  });

  @override
  State<CateShowScreen> createState() => _CateShowScreenState();
}

class _CateShowScreenState extends State<CateShowScreen>
    with TickerProviderStateMixin {
  HomeController homeController = Get.put(HomeController());
  CategoryController categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();

    categoryController.getAllBusiness();
    categoryController.getCategory();
  }

  @override
  void dispose() {
    super.dispose();

    categoryController.searchBusiness.value = false;
    categoryController.filterBusiness.value = false;
    categoryController.categoryRefreshController.dispose();
    categoryController.speechToText.cancel();
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
                  title: categoryController.categoryName.value,
                  onTap: () {
                    Get.back();
                  },
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => FilterCategoryScreen(
                                location:
                                    categoryController.locationController.text,
                                sortBY: categoryController.sortBy.value,
                                sortByName: categoryController.sortByName.value,
                                categoryId: categoryController.categoryId.value,
                                distance: categoryController.sliderValue.value,
                                lat: categoryController.lat,
                                lng: categoryController.lng,
                              ));
                        },
                        child: Image.asset(
                          AppAssets.filter_ic,
                          height: 20.h,
                          width: 20.w,
                        ),
                      ),
                    )
                  ]),
              body: LazyLoadScrollView(
                isLoading: categoryController.loadingMore.value,
                scrollOffset: 100,
                onEndOfPage: () async {
                  if (!categoryController.loadingMore.value) {
                    await categoryController.moreData();
                  }
                },
                child: SmartRefresher(
                  enablePullDown: true,
                  controller: categoryController.showCategoryRefreshController,
                  onRefresh: () {
                    if (categoryController.filterBusiness.value) {
                      categoryController.getFilterBusiness();
                    } else if (categoryController.searchBusiness.value) {
                      categoryController.getSearchBusiness(
                          categoryController.searchController.text);
                    } else {
                      categoryController.getAllBusiness();
                    }
                    categoryController.showCategoryRefreshController
                        .refreshCompleted();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                    ),
                    child: Column(
                      children: [
                        appInputField(
                            height: 50.h,
                            hintText: AppStrings.search,
                            showSuffix: true,
                            showPrefix: true,
                            controller: categoryController.searchController,
                            suffixImg: AppAssets.mic_ic,
                            prefixImg: AppAssets.search_ic,
                            visibleTap: () {
                              categoryController.startListening();
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                categoryController.searchBusiness.value = true;
                                categoryController.filterBusiness.value = false;
                                categoryController.getSearchBusiness(value);
                              } else {
                                categoryController.searchBusiness.value = false;
                                categoryController.filterBusiness.value = false;
                                categoryController.getAllBusiness(
                                    loader: false);
                              }
                            }),
                        SizedBox(height: 5.h),
                        Container(
                          height: 47.h,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Obx(
                            () => ListView.separated(
                              itemCount: categoryController.categories.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 10.w),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (APIService.internet) {
                                      categoryController.currentTab.value =
                                          index;
                                      categoryController.categoryId.value =
                                          categoryController
                                              .categories[index].catId
                                              .toString();
                                      categoryController.categoryName.value =
                                          categoryController
                                              .categories[index].catName
                                              .toString();
                                      categoryController.searchController
                                          .clear();
                                      categoryController.getAllBusiness();
                                    } else {
                                      appSnackbar(
                                        error: true,
                                        content: AppStrings.no_internet,
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.h),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      decoration: BoxDecoration(
                                        color: index ==
                                                categoryController
                                                    .currentTab.value
                                            ? AppColors.customerMain
                                            : AppColors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.black
                                                .withOpacity(0.25),
                                            blurRadius: 4.r,
                                          ),
                                        ],
                                      ),
                                      child: appText(
                                        categoryController
                                                    .categories[index].catName
                                                    .toString()
                                                    .length >
                                                15
                                            ? "${categoryController.categories[index].catName.toString().substring(0, 15)}..."
                                            : categoryController
                                                .categories[index].catName
                                                .toString(),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: index ==
                                                categoryController
                                                    .currentTab.value
                                            ? Colors
                                                .white // Text color for selected tab
                                            : Colors
                                                .black, // Text color for unselected tabs
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Expanded(
                            child: categoryController.allBusinesses.isNotEmpty
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        GridView.builder(
                                          itemCount: categoryController
                                              .allBusinesses.length,
                                          shrinkWrap: true,
                                          cacheExtent: 1000,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 16.w,
                                                  mainAxisSpacing: 8.h,
                                                  childAspectRatio: 0.75),
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            final allBusiness =
                                                categoryController
                                                    .allBusinesses[index];
                                            String categoryName =
                                                categoryController
                                                    .setCategoryName(allBusiness
                                                        .businessCategory
                                                        .toString());

                                            return InkWell(
                                              onTap: () {
                                                Get.to(
                                                    () =>
                                                        const ShowNearToYouScreen(),
                                                    arguments: {
                                                      "from": "category",
                                                      "business_id": allBusiness
                                                          .sId
                                                          .toString(),
                                                      "owner_id": allBusiness
                                                          .businessOwner!.sId
                                                          .toString(),
                                                      "business_name":
                                                          allBusiness
                                                              .businessName
                                                              .toString(),
                                                      "business_Detail":
                                                          allBusiness
                                                              .businessDetail
                                                              .toString(),
                                                      "business_location":
                                                          allBusiness
                                                              .businessLocationDetails
                                                              .toString(),
                                                      "country_code":
                                                          allBusiness
                                                              .businessOwner!
                                                              .countryCode
                                                              .toString(),
                                                      "phone_number":
                                                          allBusiness
                                                              .businessOwner!
                                                              .phoneNumber
                                                              .toString(),
                                                      "business_images":
                                                          allBusiness
                                                              .businessImages!,
                                                      "business_profile":
                                                          allBusiness //
                                                              .businessOwner!
                                                              .ownerImg
                                                              .toString(),
                                                      "ratings": allBusiness
                                                          .averageRating!,
                                                      "rating_count":
                                                          allBusiness
                                                              .ratingCount
                                                              .toString(),
                                                      "rated": allBusiness
                                                          .userHasRated,
                                                      "lat": allBusiness
                                                          .businessLocation!
                                                          .coordinates![1],
                                                      "lng": allBusiness
                                                          .businessLocation!
                                                          .coordinates![0],
                                                      "favorite": allBusiness
                                                          .isFavorite,
                                                      "opening_hours_1":
                                                          allBusiness
                                                              .openingHours1,
                                                      "opening_hours_2":
                                                          allBusiness
                                                              .openingHours2,
                                                      "opening_hours_3":
                                                          allBusiness
                                                              .openingHours3,
                                                      "opening_hours_4":
                                                          allBusiness
                                                              .openingHours4,
                                                      "opening_hours_5":
                                                          allBusiness
                                                              .openingHours5,
                                                      "opening_hours_6":
                                                          allBusiness
                                                              .openingHours6,
                                                      "opening_hours_7":
                                                          allBusiness
                                                              .openingHours7,
                                                    });
                                              },
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    child: appNetworkImage(
                                                      url:
                                                          "${AppUrls.BASE_API}${allBusiness.businessImages![0].toString()}",
                                                      loaderColor: AppColors
                                                          .customerMain,
                                                      errorIconSize: 25.sp,
                                                      maxWidthDiskCache: 1000,
                                                      maxHeightDiskCache: 1000,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        height: 250.h,
                                                        //   width: 175.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  imageProvider),
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
                                                  Positioned(
                                                    left: 9.w,
                                                    bottom: 13.h,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth: 120.w,
                                                          ),
                                                          child: appText(
                                                              allBusiness
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
                                                                    'Inter')
                                                            : const SizedBox(),
                                                        categoryName.isNotEmpty
                                                            ? SizedBox(
                                                                height: 5.h,
                                                              )
                                                            : const SizedBox(),
                                                        Row(
                                                          children: [
                                                            RatingBar.builder(
                                                              ignoreGestures:
                                                                  true,
                                                              itemSize: 10.h,
                                                              initialRating:
                                                                  allBusiness
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
                                                                  (rating) {
                                                                print(rating);
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 4.w,
                                                            ),
                                                            appText(
                                                                "(${allBusiness.ratingCount.toString()})",
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
                                                                    width: 4.w,
                                                                  ),
                                                                  appText(
                                                                      "${allBusiness.distance!.toInt().ceil().toString()} m",
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
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        categoryController.loadingMore.value
                                            ? Container(
                                                padding:
                                                    EdgeInsets.only(top: 10.h),
                                                alignment: Alignment.center,
                                                child:
                                                    const CupertinoActivityIndicator(
                                                  color: AppColors.customerMain,
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: appText('No Businesses Found!',
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                        textAlign: TextAlign.center),
                                  )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: categoryController.listening.value,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                color: AppColors.black.withOpacity(0.2),
                child: Center(
                  child: listeningLoader(
                    onTap: () async {
                      await categoryController.speechToText.stop();
                      await categoryController.speechToText.cancel();
                      categoryController.listening.value = false;
                    },
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: categoryController.loading.value,
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
