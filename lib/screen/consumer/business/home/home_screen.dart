import 'package:colorful_safe_area/colorful_safe_area.dart';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../main.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_network_image.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../../../widgets/app_text.dart';
import '../add_offer/add_offer_screen.dart';
import '../setting/setting_screen.dart';
import '../subscription/subscription_screen.dart';
import 'home_controller.dart';

import 'view_offer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController2 homeController = Get.put(HomeController2());
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    print(box.read(AppConstants.BUSINESS_OWNER_ID).toString());
    print('Bearer ${box.read(AppConstants.TOKEN).toString()}');
    homeController.getDashboardDetail();
    homeController.getRatingRatio();
    homeController.homeRefreshController =
        RefreshController(initialRefresh: false);

    _controller.addListener(_onScroll);
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
      homeController.scrollUp.value = true;
    } else {
      homeController.scrollUp.value = false;
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
              appBar: AppBar(
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0.0,
                backgroundColor: AppColors.white,
                elevation: 0.0,
                leadingWidth: 70.w,
                toolbarHeight: 80.h,
                centerTitle: true,
                leading: InkWell(
                  onTap: () {
                    Get.to(() => const SettingScreen());
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: appNetworkImage(
                      url: homeController.profileImage.value,
                      loaderColor: AppColors.businessMain,
                      errorIconSize: 15.sp,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.darkGrey,
                          image: DecorationImage(
                              fit: BoxFit.cover, image: imageProvider),
                        ),
                      ),
                    ),
                  ),
                ),
                title: Container(
                  height: 70.h,
                  width: 75.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(AppAssets.logo_img),
                  )),
                ),
                actions: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 20.h, right: 16.w, bottom: 20.h),
                    child: homeController.purchased.value
                        ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.r),
                              color: AppColors.businessMain,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.25),
                                  blurRadius: 4.r,
                                  offset: const Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.25),
                                  blurRadius: 4.r,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            child: appText(
                              homeController.expiresIn.value,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Get.to(() => const SubscriptionScreen());
                            },
                            child: Image.asset(
                              AppAssets.buy_now_img,
                              height: 33.h,
                              width: 91.w,
                            ),
                          ),
                  ),
                ],
              ),
              backgroundColor: AppColors.white,
              body: NestedScrollView(
                controller: _controller,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: AppColors.white,
                      pinned: false,
                      expandedHeight: 170.h,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15.h, horizontal: 16.w),
                            child: Column(children: [
                              InkWell(
                                onTap: () {
                                  if (homeController.purchased.value) {
                                    Get.to(() => const AddOfferScreen());
                                  } else {
                                    appSnackbar(
                                      error: true,
                                      content: 'Please purchase plan',
                                    );
                                  }
                                },
                                child: Container(
                                  height: 50.h,
                                  width: double.maxFinite,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    color: AppColors.lightLavender,
                                  ),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      appText(AppStrings.add_offer,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightBlack),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.h),
                                        child: Image.asset(
                                          AppAssets.next_arrow_ic,
                                          width: 22.h,
                                          height: 22.h,
                                          // fit: BoxFit.cover,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 160.w, maxHeight: 70.h),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                                AssetImage(AppAssets.bg_img))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            appText(
                                                homeController
                                                    .ratingCount.value,
                                                fontSize: 25.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.lightBlack),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            appText(
                                                homeController.ratingCount
                                                                .value ==
                                                            "0" ||
                                                        homeController
                                                                .ratingCount
                                                                .value ==
                                                            "1"
                                                    ? AppStrings.rating
                                                    : AppStrings.ratings,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.lightBlack)
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppAssets.star_ic,
                                              height: 24.h,
                                              width: 24.w,
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            appText(
                                                homeController
                                                    .averageRating.value,
                                                fontSize: 25.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.lightBlack)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 160.w, maxHeight: 70.h),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        color: AppColors.lightblue),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: RegExp(r'^[15]+$')
                                                          .hasMatch(
                                                              homeController
                                                                  .profileView
                                                                  .value)
                                                      ? 10.w
                                                      : 0),
                                              child: appText(
                                                  homeController
                                                      .profileView.value,
                                                  fontSize: 25.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.lightBlack,
                                                  textAlign: TextAlign.center),
                                            ),
                                            Image.asset(
                                              AppAssets.eye_ic,
                                              height: 24.h,
                                              width: 24.w,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        appText(
                                            homeController.profileView.value ==
                                                        "0" ||
                                                    homeController.profileView
                                                            .value ==
                                                        "1"
                                                ? AppStrings.view
                                                : AppStrings.views,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.lightBlack),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: MySliverPersistentHeaderDelegate(
                        Container(
                          height: 60.h,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: AppColors.lightGrey),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(AppStrings.inactive_active_text,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lightBlack),
                              AdvancedSwitch(
                                height: 25.h,
                                width: 54.w,
                                borderRadius: BorderRadius.circular(150.r),
                                controller: homeController.switchController,
                                initialValue: homeController.activeValue.value,
                                activeColor: AppColors.lightGrayShade,
                                inactiveColor: AppColors.lightGrayShade,
                                onChanged: (value) {
                                  if (APIService.internet) {
                                    homeController.activeValue.value = value;
                                    homeController.getOffers(loader: false);
                                  } else {
                                    appSnackbar(
                                      error: true,
                                      content: AppStrings.no_internet,
                                    );
                                  }
                                },
                                thumb: Obx(() => Container(
                                      height: 22.h,
                                      width: 22.w,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              homeController.activeValue.value
                                                  ? AppColors.businessMain
                                                  : AppColors.white),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: SmartRefresher(
                  enablePullDown: true,
                  controller: homeController.homeRefreshController,
                  onRefresh: () async {
                    await homeController.getDashboardDetail();
                    homeController.homeRefreshController.refreshCompleted();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: homeController.scrollUp.value ? 80.h : 15.h),
                    child: homeController.products.isNotEmpty
                        ? Theme(
                            data: Theme.of(context).copyWith(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              cacheExtent: 1000,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.w,
                                mainAxisSpacing: 16.h,
                                childAspectRatio: 0.68,
                              ),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                var offer = homeController.products[index];
                                homeController
                                    .activeTill(offer.offerEndDate.toString());

                                return InkWell(
                                  onTap: () {
                                    Get.to(() => ViewOfferScreen(
                                          offerId: offer.sId.toString(),
                                          image: offer.offerImg.toString(),
                                          active: offer.approvalStatus ==
                                                      'pending' ||
                                                  offer.approvalStatus ==
                                                      'rejected'
                                              ? offer.approvalStatus.toString()
                                              : offer.status.toString(),
                                          title: offer.offerTitle.toString(),
                                          description:
                                              offer.offerDesc.toString(),
                                          date: homeController
                                              .getDaysLeft(int.parse(
                                                  homeController.getDays(offer
                                                      .offerEndDate
                                                      .toString())))
                                              .toString(),
                                          offerEndDate:
                                              offer.offerEndDate.toString(),
                                        ));
                                  },
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxHeight: 275.h, maxWidth: 171.w),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        color: AppColors.lightGrey),
                                    padding: EdgeInsets.only(
                                      bottom: 15.h,
                                      // top: 10.h,
                                    ),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxHeight: 18.h,
                                                maxWidth: 50.w),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              color: offer.approvalStatus ==
                                                      'rejected'
                                                  ? AppColors.red
                                                  : offer.approvalStatus ==
                                                          'pending'
                                                      ? AppColors.darkYellow
                                                      : offer.status == 'active'
                                                          ? AppColors
                                                              .businessMain
                                                          : AppColors.darkGrey,
                                            ),
                                            child: appText(
                                                offer.approvalStatus ==
                                                        'rejected'
                                                    ? AppStrings.rejected
                                                    : offer.approvalStatus ==
                                                            'pending'
                                                        ? AppStrings.pending
                                                        : offer.status ==
                                                                'active'
                                                            ? AppStrings.active
                                                            : AppStrings
                                                                .inactive,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          // child: Container(
                                          //   height: 10.h,
                                          //   width: 10.w,
                                          //   decoration: BoxDecoration(
                                          //       color: offer.status !=
                                          //               "active"
                                          //           ? AppColors.darkGrey
                                          //           : AppColors.businessMain,
                                          //       boxShadow: offer.status ==
                                          //               "active"
                                          //           ? [
                                          //               BoxShadow(
                                          //                   color: AppColors
                                          //                       .businessMain,
                                          //                   blurRadius: 6.r)
                                          //             ]
                                          //           : null,
                                          //       shape: BoxShape.circle),
                                          // ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Container(
                                          constraints: BoxConstraints(
                                              maxHeight: 51.h, maxWidth: 79.w),
                                          child: appNetworkImage(
                                            url:
                                                "${AppUrls.BASE_API}${offer.offerImg.toString()}",
                                            loaderColor: AppColors.businessMain,
                                            errorIconSize: 20.sp,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: imageProvider),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                          // height: index.isOdd ? 25.h : 15.h,
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                          child: appText(
                                              offer.offerTitle.toString(),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15.sp,
                                              color: AppColors.lightBlack,
                                              maxLines: 2),
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        appText(
                                            "${AppStrings.active_till_day} ${homeController.activeTill(offer.offerEndDate.toString()).toString()}",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10.sp,
                                            color: AppColors.darkGrey),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        SizedBox(
                                          width: 170.w,
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Row(children: [
                                              for (int i = 0; i < 32; i++)
                                                Container(
                                                  width: 5.w,
                                                  height: 1.h,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        width: 1.w,
                                                        color: i % 2 == 0
                                                            ? AppColors.darkGrey
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxHeight: 18.h,
                                                    maxWidth: 80.w),
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: appText(
                                                      "${AppStrings.active_till_day} ${homeController.getDaysLeft(int.parse(homeController.getDays(offer.offerEndDate.toString()))).toString()}",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 10.sp,
                                                      color:
                                                          AppColors.lightBlack),
                                                ),
                                              ),
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxHeight: 18.h,
                                                    maxWidth: 50.w),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    color:
                                                        AppColors.businessMain),
                                                child: appText(
                                                    "${offer.clickCount.toString()} ${AppStrings.click}",
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: homeController.products.length,
                            ),
                          )
                        : appText(AppStrings.no_offers,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightBlack),
                  ),
                ),
              ),
            ),
          ),
          // ),
          Visibility(
              visible: homeController.loading.value,
              child: appLoader(loaderColor: AppColors.white))
        ],
      ),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate(this.widget);
  final Widget widget;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 60.h,
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: widget,
    );
  }

  @override
  double get maxExtent => 60.h;

  @override
  double get minExtent => 60.h;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
