// ignore_for_file: sort_child_properties_last, must_be_immutable

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinch_to_zoom_scrollable/pinch_to_zoom_scrollable.dart';

import '../../../../../constant/app_colors.dart';
import '../../../../../constant/app_urls.dart';

import '../../../../../widgets/app_network_image.dart';
import '../../../../../widgets/dot_indicator.dart';
import 'neartoyou_controller.dart';

class ImageViewScreen extends StatefulWidget {
  List<String> imageList;
  bool locally;

  ImageViewScreen({
    super.key,
    required this.imageList,
    required this.locally,
  });

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  NearToTouController nearToTouController = Get.put(NearToTouController());
  final viewTransformationController = TransformationController();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColorfulSafeArea(
        color: Colors.black,
        child: Scaffold(
          backgroundColor: AppColors.black,
          body: Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: CarouselSlider.builder(
                    carouselController: nearToTouController.carouselController,
                    itemCount: widget.imageList.length,
                    options: CarouselOptions(
                      height: double.maxFinite,
                      viewportFraction: 1,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        nearToTouController.carouselIndex.value = index;
                      },
                    ),
                    itemBuilder: (context, index, realIndex) =>
                        PinchToZoomScrollableWidget(
                      child: widget.locally
                          ? Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: MemoryImage(
                                    base64Decode(nearToTouController
                                        .businessImages[index]),
                                  ),
                                ),
                              ),
                            )
                          : appNetworkImage(
                              url:
                                  "${AppUrls.BASE_API}${widget.imageList[index]}",
                              loaderColor: AppColors.customerMain,
                              errorIconSize: 15.sp,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: double.maxFinite,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  // shape: BoxShape.circle,
                                  // color: AppColors.darkGrey,
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: imageProvider),
                                ),
                              ),
                            ),
                    ),
                  )),
              Positioned(
                top: 20.h,
                right: 16.w,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 30.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
              Obx(
                () => Positioned(
                  bottom: 20.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.imageList.length,
                      (index) => DotIndicator(
                        gap: 5.w,
                        activeColor: AppColors.white,
                        inActivecolor: AppColors.white.withOpacity(0.5),
                        isActive:
                            index == nearToTouController.carouselIndex.value,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
