// ignore_for_file: library_private_types_in_public_api

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_strings.dart';
import '../../../../widgets/app_input_field.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/custom_radiobutton.dart';
import 'home_controller.dart';

class GoogleMapSearchPlaces extends StatefulWidget {
  const GoogleMapSearchPlaces({Key? key}) : super(key: key);

  @override
  _GoogleMapSearchPlacesState createState() => _GoogleMapSearchPlacesState();
}

class _GoogleMapSearchPlacesState extends State<GoogleMapSearchPlaces> {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();

    homeController.locationSearchController.addListener(() {
      homeController.getSuggestion();
      if (homeController.locationSearchController.text.isEmpty) {
        homeController.placeList.clear();
      }
    });
  }

  @override
  void dispose() {
    homeController.locationSearchController.removeListener(() {});
    homeController.locationSearchController.clear();
    homeController.placeList.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: AppColors.white,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(children: [
          appText(
            AppStrings.your_location,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.lightBlack,
          ),
          SizedBox(height: 16.h),
          appInputField(
            height: 50.h,
            hintText: AppStrings.search,
            showSuffix: false,
            showPrefix: true,
            controller: homeController.locationSearchController,
            prefixImg: AppAssets.search_ic,
          ),
          SizedBox(height: 5.h),
          Expanded(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: homeController.placeList.length,
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
                            onTap: () async {
                              await homeController.getLatLong(
                                  input: homeController.placeList[index]
                                      ["description"]);
                              setState(() {
                                homeController.choice = index;
                                Get.back();
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
                              homeController.placeList[index]["description"],
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.lightBlack,
                              textAlign: TextAlign.left,
                              maxLines: 2,
                            ),
                            trailing: CustomRadioWidget(
                              height: 15.h,
                              width: 15.w,
                              value: index,
                              groupValue: homeController.choice,
                              onChanged: (v) {
                                setState(() {
                                  homeController.choice = v;
                                  homeController.placeName.value =
                                      homeController.placeList[index]
                                          ["description"];
                                  Get.back();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        height: 1.h,
                        width: double.maxFinite,
                        color: AppColors.lightBlack.withOpacity(0.1),
                      ),
                      SizedBox(height: 5.h),
                    ],
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
