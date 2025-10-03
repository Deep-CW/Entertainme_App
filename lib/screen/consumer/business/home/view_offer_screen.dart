// ignore_for_file: must_be_immutable

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../widgets/app_appbar.dart';

import '../../../../widgets/app_network_image.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../../../widgets/app_text.dart';
import '../add_offer/add_offer_screen.dart';
import 'home_controller.dart';

class ViewOfferScreen extends StatefulWidget {
  String? offerId;
  String image;
  String date;
  String title;
  String description;
  String active;
  String offerEndDate;

  ViewOfferScreen(
      {super.key,
      this.offerId,
      required this.image,
      required this.date,
      required this.title,
      required this.description,
      required this.active,
      required this.offerEndDate});

  @override
  State<ViewOfferScreen> createState() => _ViewOfferScreenState();
}

class _ViewOfferScreenState extends State<ViewOfferScreen> {
  HomeController2 homeController2 = Get.put(HomeController2());

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: AppColors.white,
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        appBar: appAppBar(
            backgroundColor: AppColors.lightGrey,
            onTap: () {
              Get.back();
            },
            title: '',
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  appText(
                      widget.active == 'rejected'
                          ? AppStrings.rejected
                          : widget.active == "pending"
                              ? AppStrings.pending
                              : widget.active == "active"
                                  ? AppStrings.active
                                  : AppStrings.inactive,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightBlack),
                  SizedBox(
                    width: 5.w,
                  ),
                  Container(
                    height: 12.h,
                    width: 12.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.active == 'rejected'
                            ? AppColors.red
                            : widget.active == "pending"
                                ? AppColors.darkYellow
                                : widget.active == "active"
                                    ? AppColors.businessMain
                                    : AppColors.darkGrey,
                        boxShadow: widget.active == "active"
                            ? [
                                BoxShadow(
                                  color:
                                      AppColors.businessMain.withOpacity(0.5),
                                  blurRadius: 6.r,
                                )
                              ]
                            : []),
                  )
                ],
              ),
              widget.offerId != null && widget.active == "active"
                  ? SizedBox(width: 15.w)
                  : const SizedBox(),
              widget.offerId != null && widget.active == "active"
                  ? InkWell(
                      onTap: () {
                        if (homeController2.purchased.value) {
                          Get.to(() => const AddOfferScreen(), arguments: {
                            "offerId": widget.offerId,
                            "image": widget.image,
                            "date": widget.offerEndDate,
                            "title": widget.title,
                            "description": widget.description,
                          });
                        } else {
                          appSnackbar(
                            error: true,
                            content: 'Please purchase plan',
                          );
                        }
                      },
                      child: Icon(
                        Icons.edit_square,
                        size: 25.sp,
                        color: AppColors.black.withOpacity(0.5),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(width: 16.w),
            ]),
        body: Column(
          children: [
            SizedBox(
              width: double.maxFinite,
              height: 175.h,
              child: appNetworkImage(
                url: "${AppUrls.BASE_API}${widget.image}",
                loaderColor: AppColors.businessMain,
                errorIconSize: 30.sp,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    image: DecorationImage(
                        fit: BoxFit.contain, image: imageProvider),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appText(widget.title,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightBlack,
                        textAlign: TextAlign.left),
                    SizedBox(
                      height: 30.h,
                    ),
                    appText(widget.description,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkGrey,
                        textAlign: TextAlign.left),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.calender_ic,
                          width: 15.w,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                        appText("${AppStrings.valid_till} ${widget.date}",
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: AppColors.lightBlack)
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
