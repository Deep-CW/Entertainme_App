import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:readmore/readmore.dart';

import '../../../../../constant/app_assets.dart';
import '../../../../../constant/app_colors.dart';
import '../../../../../constant/app_strings.dart';
import '../../../../../widgets/app_button.dart';
import '../../../../../widgets/app_loader.dart';
import '../../../../../widgets/app_text.dart';
import 'neartoyou_controller.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  NearToTouController nearToTouController = Get.put(NearToTouController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nearToTouController.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      children: [
        ReadMoreText(
          nearToTouController.businessDetail.toString(),
          trimMode: TrimMode.Line,
          trimLines: 3,
          trimCollapsedText: AppStrings.see_more,
          trimExpandedText: AppStrings.see_less,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.lightBlack,
          ),
          moreStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.lightBlack,
          ),
          lessStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.lightBlack,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          children: [
            Image.asset(
              AppAssets.time_ic,
              width: 16.w,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 10.w,
            ),
            appText(AppStrings.open_hours,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.lightBlack),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        nearToTouController.openHours.isNotEmpty
            ? Container(
                constraints: BoxConstraints(maxHeight: 280.h),
                //  height: 150.h,
                child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final openHour = nearToTouController.openDays[index];
                      return
                          // openHour["is_closed"] == false
                          //   ?
                          RichText(
                        text: TextSpan(
                            text: openHour["day"],
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.lightBlack,
                                fontFamily: 'Urbanist'),
                            children: [
                              TextSpan(
                                text:
                                    "  (${openHour["from_time"].toString()} AM to ${openHour["to_time"].toString()} PM)",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.lightBlack,
                                    fontFamily: 'Urbanist'),
                              )
                            ]),
                      );
                      //: const SizedBox();
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: 15.h,
                        ),
                    itemCount: nearToTouController.openDays.length),
              )
            : const SizedBox(),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appText(AppStrings.our_location,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.lightBlack,
                textAlign: TextAlign.start),
            appButton(
                onTap: () {
                  nearToTouController.openGoogleMap(
                      nearToTouController.lat.value,
                      nearToTouController.long.value);
                },
                height: 30.h,
                width: 80.w,
                borderRadius: BorderRadius.circular(5.r),
                buttonColor: AppColors.white,
                buttonText: AppStrings.direction,
                textColor: AppColors.lightBlack,
                borderColor: AppColors.lightBlack,
                borderWidth: 1.w,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Container(
          height: 150.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              boxShadow: [
                BoxShadow(
                    color: AppColors.black.withOpacity(0.25), blurRadius: 4.r)
              ]),
          child: Obx(() => nearToTouController.loading.value
              ? appLoader(
                  loaderColor: AppColors.customerMain,
                  giveOpacity: false,
                  onWillPop: false,
                )
              : GoogleMap(
                  onTap: (lat) {
                    nearToTouController.openGoogleMap(
                        nearToTouController.lat.value,
                        nearToTouController.long.value);
                  },
                  mapType: MapType.normal,
                  myLocationEnabled: false,
                  compassEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    nearToTouController.mapControler.complete(controller);
                  },
                  initialCameraPosition: nearToTouController.kGoogle,
                  markers: Set<Marker>.of(nearToTouController.markers),
                )),
        ),
        SizedBox(
          height: 15.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.location_ic,
              color: AppColors.lightBlack,
              width: 12.w,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 7.w,
            ),
            Container(
              alignment: Alignment.centerLeft,
              constraints: BoxConstraints(
                maxWidth: 300,
              ),
              child: appText(nearToTouController.businessLocation.value,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightBlack,
                  textAlign: TextAlign.start),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}
