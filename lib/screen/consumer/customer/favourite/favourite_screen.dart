import 'dart:ui';

import 'package:colorful_safe_area/colorful_safe_area.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';

import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../widgets/app_input_field.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_network_image.dart';
import '../../../../widgets/app_text.dart';
import '../home/neartoyou/show_neartoyou_screen.dart';
import 'favourite_controller.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  FavouriteController favouriteController = Get.put(FavouriteController());

  @override
  void dispose() {
    super.dispose();

    favouriteController.speechToText.cancel();
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
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.white,
                elevation: 0.0,
                toolbarHeight: 40.h,
                title: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: appText(AppStrings.favourite,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightBlack),
                ),
                centerTitle: true,
              ),
              body: SmartRefresher(
                enablePullDown: true,
                controller: favouriteController.favouriteRefreshController,
                onRefresh: () {
                  if (favouriteController.searchBusiness.value) {
                    favouriteController.getSearchBusiness(
                        favouriteController.searchController.text);
                  } else {
                    favouriteController.getFavouriteBusiness();
                  }
                  favouriteController.favouriteRefreshController
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
                          controller: favouriteController.searchController,
                          suffixImg: AppAssets.mic_ic,
                          prefixImg: AppAssets.search_ic,
                          visibleTap: () {
                            favouriteController.startListening();
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              favouriteController.searchBusiness.value = true;
                              favouriteController.getSearchBusiness(value);
                            } else {
                              favouriteController.searchBusiness.value = false;
                              favouriteController.getFavouriteBusiness(
                                  loader: false);
                            }
                          }),
                      SizedBox(
                        height: 15.h,
                      ),
                      Expanded(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          ),
                          child: favouriteController.favourite.isNotEmpty
                              ?
                              // favouriteController
                              //         .searchFavBusinessModel.isNotEmpty
                              //     ? Padding(
                              //         padding: EdgeInsets.symmetric(
                              //             horizontal: 16.w),
                              //         child: GridView.builder(
                              //             shrinkWrap: true,
                              //             cacheExtent: 1000,
                              //             physics: const ScrollPhysics(),
                              //             gridDelegate:
                              //                 SliverGridDelegateWithFixedCrossAxisCount(
                              //                     crossAxisCount: 2,
                              //                     crossAxisSpacing: 16.w,
                              //                     mainAxisSpacing: 8.h,
                              //                     childAspectRatio: 0.75),
                              //             scrollDirection: Axis.vertical,
                              //             itemBuilder: (context, index) {
                              //               final favourite =
                              //                   favouriteController
                              //                           .searchFavBusinessModel[
                              //                       index];
                              //               return InkWell(
                              //                 onTap: () {
                              //                   // List<gb.OpeningHours> openHour =[];
                              //                   // List<OpeningHours> favOpeningHoursList = [
                              //                   //   OpeningHours(day: 'Monday', openTime: '09:00', closeTime: '18:00'),
                              //                   //   OpeningHours(day: 'Tuesday', openTime: '09:00', closeTime: '18:00'),
                              //                   //   // Add more as needed
                              //                   // ];
                              //                   // List<gb.OpeningHours>
                              //                   //     gbOpeningHoursList = favourite
                              //                   //         .business!.openingHours!
                              //                   //         .map((favOpeningHours) {
                              //                   //   return gb.OpeningHours(
                              //                   //       day: favOpeningHours.day,
                              //                   //       fromTime:
                              //                   //           favOpeningHours.fromTime,
                              //                   //       toTime: favOpeningHours.toTime,
                              //                   //       isClosed: favOpeningHours
                              //                   //           .isClosed
                              //                   //           .toString());
                              //                   // }).toList();
                              //                   // print(gbOpeningHoursList);
                              //                   Get.to(
                              //                       () =>
                              //                           const ShowNearToYouScreen(),
                              //                       arguments: {
                              //                         "business_id": favourite
                              //                             .sId
                              //                             .toString(),
                              //                         "owner_id": favourite
                              //                             .businessOwner
                              //                             .toString(),
                              //                         "business_name": favourite
                              //                             .business!
                              //                             .businessName
                              //                             .toString(),
                              //                         "business_Detail":
                              //                             favourite.business!
                              //                                 .businessDetail
                              //                                 .toString(),
                              //                         "business_location":
                              //                             favourite
                              //                                 .business!.city
                              //                                 .toString(),
                              //                         "country_code": favourite
                              //                             .business!
                              //                             .businessOwner!
                              //                             .countryCode
                              //                             .toString(),
                              //                         "phone_number": favourite
                              //                             .business!
                              //                             .businessOwner!
                              //                             .phoneNumber
                              //                             .toString(),
                              //                         "business_images":
                              //                             favourite.business!
                              //                                 .businessImages!,
                              //                         "business_profile":
                              //                             favourite
                              //                                 .business!
                              //                                 .businessOwner!
                              //                                 .ownerImg
                              //                                 .toString(),
                              //                         "ratings": favourite
                              //                             .business!
                              //                             .averageRating!,
                              //                         "rating_count": favourite
                              //                             .business!.ratingCount
                              //                             .toString(),
                              //                         "favorite": true,
                              //                         "rated": favourite
                              //                             .business!
                              //                             .userHasRated,
                              //                         "lat": favourite
                              //                             .business!
                              //                             .businessLocation!
                              //                             .coordinates![1],
                              //                         "lng": favourite
                              //                             .business!
                              //                             .businessLocation!
                              //                             .coordinates![0],
                              //                         "opening_hours_1":
                              //                             favourite.business!
                              //                                 .openingHours1,
                              //                         "opening_hours_2":
                              //                             favourite.business!
                              //                                 .openingHours2,
                              //                         "opening_hours_3":
                              //                             favourite.business!
                              //                                 .openingHours3,
                              //                         "opening_hours_4":
                              //                             favourite.business!
                              //                                 .openingHours4,
                              //                         "opening_hours_5":
                              //                             favourite.business!
                              //                                 .openingHours5,
                              //                         "opening_hours_6":
                              //                             favourite.business!
                              //                                 .openingHours6,
                              //                         "opening_hours_7":
                              //                             favourite.business!
                              //                                 .openingHours7,
                              //                       });
                              //                 },
                              //                 child: Stack(
                              //                   children: [
                              //                     ClipRRect(
                              //                       borderRadius:
                              //                           BorderRadius.circular(
                              //                               10.r),
                              //                       child: appNetworkImage(
                              //                         url:
                              //                             "${AppUrls.BASE_API}${favourite.business!.businessImages![0].toString()}",
                              //                         loaderColor: AppColors
                              //                             .customerMain,
                              //                         errorIconSize: 15.sp,
                              //                         maxWidthDiskCache: 1000,
                              //                         maxHeightDiskCache: 1000,
                              //                         imageBuilder: (context,
                              //                                 imageProvider) =>
                              //                             Container(
                              //                           height: 250.h,
                              //                           width: 175.w,
                              //                           decoration:
                              //                               BoxDecoration(
                              //                             image: DecorationImage(
                              //                                 fit: BoxFit.cover,
                              //                                 image:
                              //                                     imageProvider),
                              //                           ),
                              //                         ),
                              //                       ),

                              //                       // Image.asset(
                              //                       //   favourite.business!.businessImages![0]
                              //                       //       .toString(),
                              //                       //   height: 250.h,
                              //                       //   width: 175.w,
                              //                       //   //width: 54.w,
                              //                       //   fit: BoxFit.cover,
                              //                       // ),
                              //                     ),
                              //                     Positioned(
                              //                       top: 0,
                              //                       left: -3,
                              //                       right: -3,
                              //                       bottom: -6,
                              //                       child: ClipRRect(
                              //                         borderRadius:
                              //                             BorderRadius.circular(
                              //                                 10.r),
                              //                         child: Image.asset(
                              //                           AppAssets.overlay_img,
                              //                           height: 250.h,
                              //                           width: 175.w,
                              //                           //width: 54.w,
                              //                           //fit: BoxFit.cover,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     Positioned(
                              //                       left: 9.w,
                              //                       bottom: 13.h,
                              //                       child: Column(
                              //                         crossAxisAlignment:
                              //                             CrossAxisAlignment
                              //                                 .start,
                              //                         children: [
                              //                           Container(
                              //                             constraints:
                              //                                 BoxConstraints(
                              //                               maxWidth: 120.w,
                              //                             ),
                              //                             child: appText(
                              //                                 favourite
                              //                                     .business!
                              //                                     .businessName
                              //                                     .toString(),
                              //                                 fontSize: 14.sp,
                              //                                 fontWeight:
                              //                                     FontWeight
                              //                                         .w500,
                              //                                 color: AppColors
                              //                                     .white,
                              //                                 fontFamily:
                              //                                     'Inter',
                              //                                 textAlign:
                              //                                     TextAlign
                              //                                         .start,
                              //                                 maxLines: 3,
                              //                                 overflow:
                              //                                     TextOverflow
                              //                                         .ellipsis),
                              //                           ),
                              //                           SizedBox(
                              //                             height: 5.h,
                              //                           ),
                              //                           appText(
                              //                               favouriteController
                              //                                   .setCategoryName(favourite
                              //                                       .business!
                              //                                       .businessCategory
                              //                                       .toString()),
                              //                               fontSize: 10.sp,
                              //                               fontWeight:
                              //                                   FontWeight.w400,
                              //                               color: AppColors
                              //                                   .darkWhite,
                              //                               fontFamily:
                              //                                   'Inter'),
                              //                           SizedBox(
                              //                             height: 5.h,
                              //                           ),
                              //                           Row(
                              //                             children: [
                              //                               RatingBar.builder(
                              //                                 ignoreGestures:
                              //                                     true,
                              //                                 itemSize: 10.h,
                              //                                 initialRating: favourite
                              //                                     .business!
                              //                                     .averageRating!
                              //                                     .toDouble(),
                              //                                 minRating: 1,
                              //                                 direction: Axis
                              //                                     .horizontal,
                              //                                 allowHalfRating:
                              //                                     true,
                              //                                 itemCount: 5,
                              //                                 unratedColor:
                              //                                     AppColors
                              //                                         .darkWhite,
                              //                                 itemPadding: EdgeInsets
                              //                                     .symmetric(
                              //                                         horizontal:
                              //                                             2.0.w),
                              //                                 itemBuilder:
                              //                                     (context,
                              //                                             _) =>
                              //                                         const Icon(
                              //                                   Icons.star,
                              //                                   color: AppColors
                              //                                       .darkYellow,
                              //                                 ),
                              //                                 onRatingUpdate:
                              //                                     (rating) {},
                              //                               ),
                              //                               SizedBox(
                              //                                 width: 4.w,
                              //                               ),
                              //                               appText(
                              //                                   "(${favourite.business!.ratingCount.toString()})",
                              //                                   fontSize: 10.sp,
                              //                                   fontWeight:
                              //                                       FontWeight
                              //                                           .w400,
                              //                                   fontFamily:
                              //                                       'Inter',
                              //                                   color: AppColors
                              //                                       .darkWhite)
                              //                             ],
                              //                           ),
                              //                           SizedBox(
                              //                             height: 5.h,
                              //                           ),
                              //                           Row(
                              //                             children: [
                              //                               Image.asset(
                              //                                 AppAssets
                              //                                     .distance_ic,
                              //                                 width: 10.w,
                              //                                 fit: BoxFit.cover,
                              //                               ),
                              //                               SizedBox(
                              //                                 width: 4.w,
                              //                               ),
                              //                               appText(
                              //                                   "${favourite.business!.distance!.toInt().ceil().toString()} m",
                              //                                   fontSize: 10.sp,
                              //                                   fontWeight:
                              //                                       FontWeight
                              //                                           .w400,
                              //                                   fontFamily:
                              //                                       'Inter',
                              //                                   color: AppColors
                              //                                       .darkWhite)
                              //                             ],
                              //                           )
                              //                         ],
                              //                       ),
                              //                     ),
                              //                     Positioned(
                              //                       bottom: 13.h,
                              //                       right: 9.w,
                              //                       child: Image.asset(
                              //                         AppAssets
                              //                             .favourite_fill_ic,
                              //                         width: 17.w,
                              //                         fit: BoxFit.cover,
                              //                       ),
                              //                     )
                              //                   ],
                              //                 ),
                              //               );
                              //             },
                              //             itemCount: favouriteController
                              //                 .searchFavBusinessModel.length),
                              //       )
                              //     :
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      cacheExtent: 1000,
                                      physics: const ScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 16.w,
                                              mainAxisSpacing: 8.h,
                                              childAspectRatio: 0.75),
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        final favourite = favouriteController
                                            .favourite[index];
                                        return InkWell(
                                          onTap: () {
                                            // List<gb.OpeningHours> openHour =[];
                                            // List<OpeningHours> favOpeningHoursList = [
                                            //   OpeningHours(day: 'Monday', openTime: '09:00', closeTime: '18:00'),
                                            //   OpeningHours(day: 'Tuesday', openTime: '09:00', closeTime: '18:00'),
                                            //   // Add more as needed
                                            // ];
                                            // List<gb.OpeningHours>
                                            //     gbOpeningHoursList = favourite
                                            //         .business!.openingHours!
                                            //         .map((favOpeningHours) {
                                            //   return gb.OpeningHours(
                                            //       day: favOpeningHours.day,
                                            //       fromTime:
                                            //           favOpeningHours.fromTime,
                                            //       toTime: favOpeningHours.toTime,
                                            //       isClosed: favOpeningHours
                                            //           .isClosed
                                            //           .toString());
                                            // }).toList();
                                            // print(gbOpeningHoursList);
                                            Get.to(
                                                () =>
                                                    const ShowNearToYouScreen(),
                                                arguments: {
                                                  "from": "favourite",
                                                  "business_id": favourite
                                                      .business!.sId
                                                      .toString(),
                                                  "owner_id": favourite
                                                      .businessOwner
                                                      .toString(),
                                                  "business_name": favourite
                                                      .business!.businessName
                                                      .toString(),
                                                  "business_Detail": favourite
                                                      .business!.businessDetail
                                                      .toString(),
                                                  "business_location": favourite
                                                      .business!
                                                      .businessLocationDetails
                                                      .toString(),
                                                  "country_code": favourite
                                                      .business!
                                                      .businessOwnerDetail!
                                                      .countryCode
                                                      .toString(),
                                                  "phone_number": favourite
                                                      .business!
                                                      .businessOwnerDetail!
                                                      .phoneNumber
                                                      .toString(),
                                                  "business_images": favourite
                                                      .business!
                                                      .businessImages!,
                                                  "business_profile": favourite
                                                      .business!
                                                      .businessOwnerDetail!
                                                      .ownerImg
                                                      .toString(),
                                                  "ratings": favourite
                                                      .business!.averageRating!
                                                      .toInt(),
                                                  "rating_count": favourite
                                                      .business!.ratingCount
                                                      .toString(),
                                                  "favorite": true,
                                                  "rated": favourite
                                                      .business!.userHasRated,
                                                  "lat": favourite
                                                      .business!
                                                      .businessLocation!
                                                      .coordinates![1],
                                                  "lng": favourite
                                                      .business!
                                                      .businessLocation!
                                                      .coordinates![0],
                                                  "opening_hours_1": favourite
                                                      .business!.openingHours1,
                                                  "opening_hours_2": favourite
                                                      .business!.openingHours2,
                                                  "opening_hours_3": favourite
                                                      .business!.openingHours3,
                                                  "opening_hours_4": favourite
                                                      .business!.openingHours4,
                                                  "opening_hours_5": favourite
                                                      .business!.openingHours5,
                                                  "opening_hours_6": favourite
                                                      .business!.openingHours6,
                                                  "opening_hours_7": favourite
                                                      .business!.openingHours7,
                                                });
                                          },
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                child: appNetworkImage(
                                                  url:
                                                      "${AppUrls.BASE_API}${favourite.business!.businessImages![0].toString()}",
                                                  loaderColor:
                                                      AppColors.customerMain,
                                                  errorIconSize: 15.sp,
                                                  maxWidthDiskCache: 1000,
                                                  maxHeightDiskCache: 1000,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
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

                                                // Image.asset(
                                                //   favourite.business!.businessImages![0]
                                                //       .toString(),
                                                //   height: 250.h,
                                                //   width: 175.w,
                                                //   //width: 54.w,
                                                //   fit: BoxFit.cover,
                                                // ),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: 120.w,
                                                      ),
                                                      child: appText(
                                                          favourite.business!
                                                              .businessName
                                                              .toString(),
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              AppColors.white,
                                                          fontFamily: 'Inter',
                                                          textAlign:
                                                              TextAlign.start,
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    appText(
                                                        favouriteController
                                                            .setCategoryName(
                                                                favourite
                                                                    .business!
                                                                    .businessCategory
                                                                    .toString()),
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppColors.darkWhite,
                                                        fontFamily: 'Inter'),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        RatingBar.builder(
                                                          ignoreGestures: true,
                                                          itemSize: 10.h,
                                                          initialRating:
                                                              favourite
                                                                  .business!
                                                                  .averageRating!
                                                                  .toDouble(),
                                                          minRating: 1,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          unratedColor:
                                                              AppColors
                                                                  .darkWhite,
                                                          itemPadding: EdgeInsets
                                                              .symmetric(
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
                                                        ),
                                                        SizedBox(
                                                          width: 4.w,
                                                        ),
                                                        appText(
                                                            "(${favourite.business!.ratingCount.toString()})",
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily: 'Inter',
                                                            color: AppColors
                                                                .darkWhite)
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Row(
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
                                                            // AppStrings
                                                            //     .distance,
                                                            "${favourite.business!.distance!.toInt().ceil().toString()} m",
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily: 'Inter',
                                                            color: AppColors
                                                                .darkWhite)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 13.h,
                                                right: 9.w,
                                                child: Image.asset(
                                                  AppAssets.favourite_fill_ic,
                                                  width: 17.w,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      itemCount:
                                          favouriteController.favourite.length),
                                )
                              : Center(
                                  child: appText(AppStrings.no_favourite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                      color: AppColors.lightBlack),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: favouriteController.listening.value,
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
                      await favouriteController.speechToText.stop();
                      await favouriteController.speechToText.cancel();
                      favouriteController.listening.value = false;
                    },
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: favouriteController.loading.value,
            child: appLoader(
              loaderColor: AppColors.transparent,
              giveOpacity: false,
            ),
          )
        ],
      ),
    );
  }
}
