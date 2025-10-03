// ignore_for_file: library_private_types_in_public_api

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../constant/app_assets.dart';
import '../../../../../constant/app_colors.dart';
import '../../../../../constant/app_strings.dart';

import '../../../../../widgets/app_input_field.dart';
import '../../../../../widgets/app_text.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/custom_radiobutton.dart';
import 'business_location_controller.dart';

class BusinessLocation extends StatefulWidget {
  const BusinessLocation({Key? key}) : super(key: key);

  @override
  _BusinessLocationState createState() => _BusinessLocationState();
}

class _BusinessLocationState extends State<BusinessLocation> {
  BusinessLocationController businessLocationController =
      Get.put(BusinessLocationController());

  @override
  void initState() {
    super.initState();
    businessLocationController.locationController.addListener(() {
      businessLocationController.onChangedLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: AppColors.white,
      child: WillPopScope(
        onWillPop: () async {
          Get.back(result: {
            "location": businessLocationController.placeName.value.toString(),
            "lat": businessLocationController.lat,
            "lng": businessLocationController.lng
          });
          return true;
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: appAppBar(
              title: AppStrings.select_location,
              onTap: () {
                Get.back(result: {
                  "location":
                      businessLocationController.placeName.value.toString(),
                  "lat": businessLocationController.lat,
                  "lng": businessLocationController.lng
                });
              }),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(children: [
              appInputField(
                height: 50.h,
                hintText: AppStrings.search,
                showSuffix: false,
                showPrefix: true,
                givePadding: false,
                controller: businessLocationController.locationController,
                prefixImg: AppAssets.search_ic,
              ),
              SizedBox(
                height: 5.h,
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: businessLocationController.placeList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 40.h,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 0),
                              child: ListTile(
                                dense: true,
                                minVerticalPadding: 0.0,
                                onTap: () {
                                  setState(() {
                                    businessLocationController.getLatLng(
                                        businessLocationController
                                            .placeList[index]['place_id']);
                                    businessLocationController.choice = index;
                                    businessLocationController.placeName.value =
                                        businessLocationController
                                            .placeList[index]["description"];
                                  });
                                },
                                leading: Container(
                                  height: 30.h,
                                  width: 30.w,
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.mediumGrey,
                                  ),
                                  child: Image.asset(
                                    AppAssets.location_ic,
                                    width: 10.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: appText(
                                    businessLocationController.placeList[index]
                                        ["description"],
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.lightBlack,
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                trailing: CustomRadioWidget(
                                  height: 15.h,
                                  width: 15.w,
                                  value: index,
                                  groupValue: businessLocationController.choice,
                                  onChanged: (v) {
                                    setState(() {
                                      businessLocationController.getLatLng(
                                          businessLocationController
                                              .placeList[index]['place_id']);
                                      businessLocationController.choice = v;
                                      businessLocationController
                                              .placeName.value =
                                          businessLocationController
                                              .placeList[index]["description"];
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            height: 1.h,
                            width: double.maxFinite,
                            color: AppColors.lightBlack.withOpacity(0.1),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
