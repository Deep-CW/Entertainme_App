// ignore_for_file: sort_child_properties_last

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../constant/app_assets.dart';
import '../../../../../constant/app_colors.dart';
import '../../../../../constant/app_strings.dart';
import '../../../../../constant/app_urls.dart';
import '../../../../../services/api_service.dart';
import '../../../../../widgets/app_loader.dart';
import '../../../../../widgets/app_network_image.dart';
import '../../../../../widgets/app_snackbar.dart';
import '../../../../../widgets/app_text.dart';
import '../../../../../widgets/dot_indicator.dart';
import 'aboutus_screen.dart';
import 'image_view_screen.dart';
import 'neartoyou_controller.dart';
import 'offer_screen.dart';

class ShowNearToYouScreen extends StatefulWidget {
  const ShowNearToYouScreen({super.key});

  @override
  State<ShowNearToYouScreen> createState() => _ShowNearToYouScreenState();
}

class _ShowNearToYouScreenState extends State<ShowNearToYouScreen>
    with TickerProviderStateMixin {
  NearToTouController nearToTouController = Get.put(NearToTouController());
  final ScrollController _controller = ScrollController();
  bool locally = Get.arguments['locally'] ?? false;

  @override
  void initState() {
    nearToTouController.tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: nearToTouController.currentTab.value);
    nearToTouController.tabController!.addListener(() {
      nearToTouController.currentTab.value =
          nearToTouController.tabController!.index;
    });
    _controller.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);

    super.dispose();
  }

  //scroll check
  void _onScroll() {
    final maxScrollExtent = _controller.position.maxScrollExtent;
    final currentScrollOffset = _controller.offset;
    final halfScrollExtent = maxScrollExtent / 1.5;

    if (currentScrollOffset > halfScrollExtent) {
      nearToTouController.scrollUp.value = true;
    } else {
      nearToTouController.scrollUp.value = false;
    }
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
              body: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  controller: _controller,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor: AppColors.white,
                        pinned: false,
                        expandedHeight: 390.h,
                        automaticallyImplyLeading: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(
                            children: [
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      bool locally =
                                          Get.arguments['locally'] ?? false;
                                      Get.to(() => ImageViewScreen(
                                            imageList: nearToTouController
                                                .businessImages,
                                            locally: locally,
                                          ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(20.r),
                                      ),
                                      child: CarouselSlider.builder(
                                        carouselController: nearToTouController
                                            .carouselController,
                                        itemCount: nearToTouController
                                            .businessImages.length,
                                        options: CarouselOptions(
                                          viewportFraction: 1.3,
                                          height: 255.h,
                                          enlargeCenterPage: false,
                                          enableInfiniteScroll: false,
                                          onPageChanged: (index, reason) {
                                            nearToTouController
                                                .carouselIndex.value = index;
                                          },
                                        ),
                                        itemBuilder:
                                            (context, index, realIndex) =>
                                                Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            locally
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        bottom: Radius.circular(
                                                            20.r),
                                                      ),
                                                      image: DecorationImage(
                                                        fit: BoxFit.contain,
                                                        image: MemoryImage(
                                                          base64Decode(
                                                              nearToTouController
                                                                      .businessImages[
                                                                  index]),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      bottom:
                                                          Radius.circular(20.r),
                                                    ),
                                                    child: appNetworkImage(
                                                      url:
                                                          "${AppUrls.BASE_API}${nearToTouController.businessImages[index]}",
                                                      loaderColor: AppColors
                                                          .customerMain,
                                                      errorIconSize: 15.sp,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit
                                                                  .contain,
                                                              image:
                                                                  imageProvider),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            Image.asset(
                                              AppAssets.overlay_horizontal_img,
                                              fit: BoxFit.cover,
                                              width: double.maxFinite,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: 50.h,
                                          width: double.maxFinite,
                                          foregroundDecoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.8)
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              //  stops: [0, 0.2, ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 16.w,
                                          right: 16.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Image.asset(
                                                  AppAssets.backround_ic,
                                                  fit: BoxFit.cover,
                                                  width: 20.w,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        nearToTouController
                                                            .shareDetail();
                                                      },
                                                      child: Image.asset(
                                                        AppAssets.share_ic,
                                                        fit: BoxFit.cover,
                                                        width: 25.w,
                                                      )),
                                                  SizedBox(
                                                    width: 20.w,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      nearToTouController
                                                          .setFavouriteBusiness();
                                                    },
                                                    child: Image.asset(
                                                      AppAssets
                                                          .favourite_fill_ic,
                                                      fit: BoxFit.cover,
                                                      width: 20.w,
                                                      color: nearToTouController
                                                              .favorite.value
                                                          ? AppColors
                                                              .customerMain
                                                          : AppColors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8.h,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          nearToTouController
                                              .businessImages.length,
                                          (index) => Obx(
                                            () => DotIndicator(
                                              gap: 5.w,
                                              activeColor: AppColors.white,
                                              inActivecolor: AppColors.white
                                                  .withOpacity(0.5),
                                              isActive: index ==
                                                  nearToTouController
                                                      .carouselIndex.value,
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                                alignment: Alignment.bottomCenter,
                              ),
                              SizedBox(
                                height: 22.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      appText(
                                          nearToTouController.businessName
                                              .toString(),
                                          fontSize: 25.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightBlack,
                                          textAlign: TextAlign.left),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            AppAssets.phone_ic,
                                            color: AppColors.lightBlack,
                                            width: 15.w,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              nearToTouController.callPhone(
                                                  "+${nearToTouController.countryCode.toString()} ${nearToTouController.phoneNumber.toString()}");
                                            },
                                            child: appText(
                                                "+${nearToTouController.countryCode.toString()} ${nearToTouController.phoneNumber.toString()}",
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.lightBlack,
                                                decoration:
                                                    TextDecoration.underline),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              GetBuilder<NearToTouController>(
                                                  builder: (controller) {
                                                    return RatingBar.builder(
                                                      ignoreGestures: true,
                                                      itemSize: 20.h,
                                                      initialRating:
                                                          nearToTouController
                                                              .getRating,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      unratedColor:
                                                          AppColors.darkWhite,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  2.0.w),
                                                      itemBuilder:
                                                          (context, _) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color: AppColors
                                                            .darkYellow,
                                                      ),
                                                      onRatingUpdate:
                                                          (rating) {},
                                                    );
                                                  },
                                                  id: "update"),
                                              SizedBox(
                                                width: 4.w,
                                              ),
                                              appText(
                                                  "(${nearToTouController.ratingCount.value})",
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Inter',
                                                  color: AppColors.lightBlack),
                                            ],
                                          ),
                                          nearToTouController.rated.value
                                              ? const SizedBox()
                                              : InkWell(
                                                  onTap: () {
                                                    if (APIService.internet) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15.r)),
                                                              child: Container(
                                                                height: 200.h,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .white,
                                                                    borderRadius: BorderRadius.circular(15.r),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: AppColors.black.withOpacity(
                                                                              0.25),
                                                                          blurRadius:
                                                                              4.r)
                                                                    ]),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          15.h,
                                                                    ),
                                                                    appText(
                                                                        "Give Rating",
                                                                        fontSize: 20
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: AppColors
                                                                            .lightBlack),
                                                                    SizedBox(
                                                                      height:
                                                                          30.h,
                                                                    ),
                                                                    RatingBar
                                                                        .builder(
                                                                      itemSize:
                                                                          30.h,
                                                                      initialRating:
                                                                          0,
                                                                      minRating:
                                                                          1,
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      allowHalfRating:
                                                                          false,
                                                                      itemCount:
                                                                          5,
                                                                      unratedColor:
                                                                          AppColors
                                                                              .darkWhite,
                                                                      itemPadding:
                                                                          EdgeInsets.symmetric(
                                                                              horizontal: 2.0.w),
                                                                      itemBuilder:
                                                                          (context, _) =>
                                                                              const Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: AppColors
                                                                            .darkYellow,
                                                                      ),
                                                                      onRatingUpdate:
                                                                          (rating) {
                                                                        nearToTouController
                                                                            .rating
                                                                            .value = rating.toStringAsFixed(0); // Converts 1.0 to "1.0"
                                                                      },
                                                                    ),
                                                                    const Spacer(),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: 16
                                                                              .w,
                                                                          vertical:
                                                                              20.h),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 40.h,
                                                                              width: 100.w,
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                color: AppColors.lightBlack,
                                                                                borderRadius: BorderRadius.circular(25.r),
                                                                              ),
                                                                              child: appText(AppStrings.cancel, fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.white),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              Get.back();
                                                                              await nearToTouController.giveRating().then((response) async {
                                                                                setState(() {});
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 40.h,
                                                                              width: 100.w,
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                color: AppColors.customerMain,
                                                                                borderRadius: BorderRadius.circular(25.r),
                                                                              ),
                                                                              child: appText(AppStrings.save, fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.white),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    } else {
                                                      appSnackbar(
                                                        error: true,
                                                        content: AppStrings
                                                            .no_internet,
                                                      );
                                                    }
                                                  },
                                                  child: appText(
                                                      AppStrings.give_rating,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          AppColors.lightBlack,
                                                      decoration: TextDecoration
                                                          .underline),
                                                )
                                        ],
                                      ),
                                      // Container(
                                      //   color: Colors.red,
                                      //   height: 20.h,
                                      // ),
                                    ]),
                              ),
                            ],
                          ),
                          stretchModes: const [StretchMode.zoomBackground],
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: MySliverPersistentHeaderDelegate(
                          TabBar(
                              controller: nearToTouController.tabController,
                              indicatorColor: AppColors.transparent,
                              labelPadding: EdgeInsets.zero,
                              dividerColor: AppColors.transparent,
                              onTap: (index) {
                                if (index == 1) {
                                  nearToTouController.getBusinessOffer();
                                }
                              },
                              tabs: [
                                Obx(
                                  () => Padding(
                                    padding: EdgeInsets.only(right: 7.5.w),
                                    child: Container(
                                      height: 70.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: nearToTouController
                                                      .currentTab.value ==
                                                  0
                                              ? AppColors.lightBlack
                                              : AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border: Border.all(
                                              color: AppColors.lightBlack)),
                                      child: appText(AppStrings.about_us,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: nearToTouController
                                                      .currentTab.value ==
                                                  0
                                              ? AppColors.white
                                              : AppColors.lightBlack),
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Padding(
                                    padding: EdgeInsets.only(left: 7.5.w),
                                    child: Container(
                                      height: 70.h,
                                      // width: 150.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: nearToTouController
                                                      .currentTab.value ==
                                                  1
                                              ? AppColors.lightBlack
                                              : AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border: Border.all(
                                              color: AppColors.lightBlack)),
                                      child: appText(AppStrings.offers,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: nearToTouController
                                                      .currentTab.value ==
                                                  1
                                              ? AppColors.white
                                              : AppColors.lightBlack),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        pinned: true,
                      ),
                    ];
                  },
                  body: Padding(
                    padding: EdgeInsets.only(
                        top: nearToTouController.scrollUp.value ? 90.h : 20.h),
                    child: TabBarView(
                      controller: nearToTouController.tabController,
                      children: const [AboutUsScreen(), OfferScreen()],
                    ),
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

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        height: 70.h,
        color: AppColors.white,
        padding: EdgeInsets.only(
          top: 20.h,
          left: 16.w,
          right: 16.w,
        ),
        child: _tabBar);
  }

  @override
  double get maxExtent => 70.h;

  @override
  double get minExtent => 70.h; //_tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
