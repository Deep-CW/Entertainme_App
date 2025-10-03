// ignore_for_file: library_private_types_in_public_api

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../constant/app_assets.dart';
import '../../../../../../constant/app_colors.dart';
import '../../../../../../constant/app_strings.dart';
import '../../../../../../widgets/app_appbar.dart';
import '../../../../../../widgets/app_input_field.dart';
import '../../../../../../widgets/app_text.dart';
import '../../../../../../widgets/custom_radiobutton.dart';
import 'category_location_controller.dart';

class CategoryLocationScreen extends StatefulWidget {
  const CategoryLocationScreen({Key? key}) : super(key: key);

  @override
  _CategoryLocationScreenState createState() => _CategoryLocationScreenState();
}

class _CategoryLocationScreenState extends State<CategoryLocationScreen> {
  CategoryLocationController categoryLocationController =
      Get.put(CategoryLocationController());

  @override
  void initState() {
    super.initState();

    categoryLocationController.locationController.addListener(() {
      categoryLocationController.onChangedLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: AppColors.white,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: appAppBar(
          title: AppStrings.select_location,
          onTap: () {
            Get.back();
          },
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(children: [
            appInputField(
              height: 50.h,
              hintText: AppStrings.search,
              showSuffix: false,
              showPrefix: true,
              givePadding: false,
              controller: categoryLocationController.locationController,
              prefixImg: AppAssets.search_ic,
            ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryLocationController.placeList.length,
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
                                categoryLocationController.choice = index;
                                categoryLocationController.placeName.value =
                                    categoryLocationController.placeList[index]
                                        ["description"];
                                setState(() {});
                                await categoryLocationController.getLatLng(
                                    categoryLocationController.placeList[index]
                                        ['place_id']);
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
                                  categoryLocationController.placeList[index]
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
                                groupValue: categoryLocationController.choice,
                                onChanged: (v) async {
                                  categoryLocationController.choice = v;
                                  categoryLocationController.placeName.value =
                                      categoryLocationController
                                          .placeList[index]["description"];
                                  setState(() {});
                                  await categoryLocationController.getLatLng(
                                      categoryLocationController
                                          .placeList[index]['place_id']);
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
      ),
    );
  }
}
