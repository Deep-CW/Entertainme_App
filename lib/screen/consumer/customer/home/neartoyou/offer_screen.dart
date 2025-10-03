import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../constant/app_colors.dart';
import '../../../../../constant/app_strings.dart';
import '../../../../../constant/app_urls.dart';

import '../../../../../services/api_service.dart';
import '../../../../../widgets/app_network_image.dart';
import '../../../../../widgets/app_snackbar.dart';
import '../../../../../widgets/app_text.dart';
import '../../../business/home/view_offer_screen.dart';
import 'neartoyou_controller.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  NearToTouController nearToTouController = Get.put(NearToTouController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: APIService.internet
          ? Obx(
              () => nearToTouController.getBusinessOffers.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            cacheExtent: 1000,
                            physics: const ScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16.w,
                                    mainAxisSpacing: 16.h,
                                    childAspectRatio: 0.70),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final offer =
                                  nearToTouController.getBusinessOffers[index];
                              return InkWell(
                                onTap: () async {
                                  if (APIService.internet) {
                                    await nearToTouController
                                        .clickBusinessOffer(
                                            offer.offerId.toString());
                                    Get.to(() => ViewOfferScreen(
                                          image: offer.offerImg.toString(),
                                          active: offer.approvalStatus ==
                                                  'pending'
                                              ? offer.approvalStatus.toString()
                                              : offer.status.toString(),
                                          title: offer.offerTitle.toString(),
                                          description:
                                              offer.offerDesc.toString(),
                                          date: nearToTouController
                                              .getDaysLeft(int.parse(
                                                  nearToTouController.getDays(
                                                      offer.offerEndDate
                                                          .toString())))
                                              .toString(),
                                          offerEndDate:
                                              offer.offerEndDate.toString(),
                                        ));
                                  } else {
                                    appSnackbar(
                                      error: true,
                                      content: AppStrings.no_internet,
                                    );
                                  }
                                },
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxHeight: 270.h, maxWidth: 171.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: AppColors.lightGrey),
                                  padding: EdgeInsets.only(
                                    bottom: 15.h,
                                    top: 10.h,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.w),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 10.h,
                                            width: 10.w,
                                            decoration: BoxDecoration(
                                                color: offer.status != "active"
                                                    ? AppColors.darkGrey
                                                    : AppColors.businessMain,
                                                boxShadow:
                                                    offer.status == "active"
                                                        ? [
                                                            BoxShadow(
                                                                color: AppColors
                                                                    .businessMain,
                                                                blurRadius: 6.r)
                                                          ]
                                                        : null,
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxHeight: 52.h, maxWidth: 79.w),
                                        child: Container(
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
                                          nearToTouController
                                                  .getDays(offer.offerEndDate
                                                      .toString())
                                                  .toString()
                                                  .contains('-')
                                              ? "${AppStrings.active_ago}${nearToTouController.getDays(offer.offerEndDate.toString()).replaceAll('-', '')}${AppStrings.day_ago}"
                                              : "${AppStrings.active_till_day} ${nearToTouController.getDaysLeft(int.parse(nearToTouController.getDays(offer.offerEndDate.toString()))).toString()}",
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
                                                          : Colors.transparent,
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
                                      appText(
                                          "${AppStrings.active_till_day} ${nearToTouController.getDaysLeft(int.parse(nearToTouController.getDays(offer.offerEndDate.toString()))).toString()}",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.sp,
                                          color: AppColors.lightBlack),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount:
                                nearToTouController.getBusinessOffers.length,
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    )
                  : Center(
                      child: appText(
                        AppStrings.no_offers,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.lightBlack,
                      ),
                    ),
            )
          : Column(
              children: [
                appText(
                  AppStrings.no_internet,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: AppColors.lightBlack,
                ),
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () {
                    if (APIService.internet) {
                      setState(() {});
                      nearToTouController.getBusinessOffer();
                    } else {
                      appSnackbar(
                        error: true,
                        content: AppStrings.no_internet,
                      );
                    }
                  },
                  child: appText(
                    AppStrings.retry,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.customerMain,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: AppColors.customerMain,
                  ),
                ),
              ],
            ),
    );
  }
}
