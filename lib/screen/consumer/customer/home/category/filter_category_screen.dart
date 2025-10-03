// ignore_for_file: must_be_immutable, avoid_function_literals_in_foreach_calls

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../constant/app_assets.dart';
import '../../../../../constant/app_colors.dart';
import '../../../../../constant/app_constants.dart';
import '../../../../../constant/app_list.dart';
import '../../../../../constant/app_strings.dart';
import '../../../../../main.dart';
import '../../../../../widgets/app_appbar.dart';
import '../../../../../widgets/app_button.dart';
import '../../../../../widgets/app_chips.dart';
import '../../../../../widgets/app_input_field.dart';
import '../../../../../widgets/app_loader.dart';
import '../../../../../widgets/app_text.dart';
import 'category_controller.dart';
import 'location/category_location_screen.dart';

class FilterCategoryScreen extends StatefulWidget {
  String location;
  String sortBY;
  String sortByName;
  String categoryId;
  double distance;
  double lat;
  double lng;

  FilterCategoryScreen({
    super.key,
    required this.location,
    required this.sortBY,
    required this.sortByName,
    required this.categoryId,
    required this.distance,
    required this.lat,
    required this.lng,
  });

  @override
  State<FilterCategoryScreen> createState() => _FilterCategoryScreenState();
}

class _FilterCategoryScreenState extends State<FilterCategoryScreen> {
  CategoryController categoryController = Get.put(CategoryController());
  final GlobalKey<FormState> filterKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (box.read(AppConstants.SELECTED_LOCATION) != null &&
        categoryController.locationController.text.isEmpty) {
      categoryController.locationController = TextEditingController(
          text: box.read(AppConstants.SELECTED_LOCATION).toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: AppColors.white,
      child: Obx(
        () => Stack(
          children: [
            WillPopScope(
              onWillPop: () async {
                categoryController.locationController.text = widget.location;
                categoryController.categoryId.value = widget.categoryId;
                categoryController.sortBy.value = widget.sortBY;
                categoryController.sortByName.value = widget.sortByName;
                categoryController.sliderValue.value = widget.distance;
                categoryController.lat = widget.lat;
                categoryController.lng = widget.lng;
                return true;
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: AppColors.white,
                appBar: appAppBar(
                  title: AppStrings.filter,
                  onTap: () {
                    categoryController.locationController.text =
                        widget.location;
                    categoryController.categoryId.value = widget.categoryId;
                    categoryController.sortBy.value = widget.sortBY;
                    categoryController.sortByName.value = widget.sortByName;
                    categoryController.sliderValue.value = widget.distance;
                    categoryController.lat = widget.lat;
                    categoryController.lng = widget.lng;
                    Get.back();
                  },
                ),
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                    ),
                    child: Form(
                      key: filterKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: appText(AppStrings.your_location,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.lightBlack),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          appInputField(
                              height: 50.h,
                              hintText: AppStrings.search,
                              showSuffix: true,
                              showPrefix: false,
                              controller: categoryController.locationController,
                              suffixImg: AppAssets.search_ic,
                              fillColor: AppColors.white,
                              readOnly: true,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: AppColors.black.withOpacity(0.10),
                                    blurRadius: 4.r)
                              ]),
                              validator: (value) {
                                return categoryController
                                    .yourLocationValidation();
                              },
                              onTap: () async {
                                final locationValue = await Get.to(
                                    () => const CategoryLocationScreen());
                                if (locationValue != null) {
                                  categoryController.locationController.text =
                                      locationValue["location"];
                                  categoryController.lat = locationValue["lat"];
                                  categoryController.lng = locationValue["lng"];
                                }
                              }),
                          SizedBox(
                            height: 11.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Container(
                              height: 250.h,
                              width: double.maxFinite,
                              padding: EdgeInsets.only(
                                  left: 15.w,
                                  right: 15.w,
                                  top: 30.h,
                                  bottom: 20.h),
                              // symmetric(
                              //     horizontal: 15.w, vertical: 20.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            AppColors.black.withOpacity(0.25),
                                        blurRadius: 4.r)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  appText(AppStrings.sort_by,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.lightBlack),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  appChip(
                                    value: categoryController.sortBy.value,
                                    direction: Axis.horizontal,
                                    onChanged: (val) {
                                      categoryController.sortBy.value = val;

                                      if (categoryController.sortBy.value ==
                                          '1') {
                                        categoryController.sortByName.value =
                                            'nearest';
                                      } else if (categoryController
                                              .sortBy.value ==
                                          '2') {
                                        categoryController.sortByName.value =
                                            'top_rated';
                                      } else {
                                        categoryController.sortByName.value =
                                            'new';
                                      }
                                    },
                                    chipList: AppList.selectedTag1,
                                    selectColor: AppColors.white,
                                    selectFillColor: AppColors.customerMain,
                                    unselecteColor: AppColors.darkGrey,
                                    unselecteFillColor: AppColors.lightGrey,
                                  ),
                                  // appChips(
                                  //     value: categoryController.sortedCategory,
                                  //     direction: Axis.horizontal,
                                  //     height: 50.h,
                                  //     onChanged: (val) {
                                  //       setState(() {
                                  //         categoryController.sortedCategory.value = val;
                                  //       });
                                  //       // state(() {
                                  //       //   favouriteController.selectFavCategory.value =
                                  //       //   [];
                                  //       //   if (storyController.selectedCategory != '') {
                                  //       //     favouriteController.selectFavCategory.insert(
                                  //       //         0, storyController.selectedCategory);
                                  //       //   }
                                  //       //   favouriteController.selectFavCategory.value
                                  //       //       .addAll(favouriteController.favTagSelected);
                                  //       // });
                                  //       //state(() =>
                                  //       // categoryController
                                  //       //     .selectFavCategory.value
                                  //       //     .add(val.last);
                                  //       //  favouriteController.update(['favitem']);
                                  //     },
                                  //     chipList: AppList.selectedTag1,
                                  //     selectColor: AppColors.white,
                                  //     selectFillColor: AppColors.customerMain,
                                  //     unselecteColor: AppColors.darkGrey,
                                  //     unselecteFillColor: AppColors.lightGrey,
                                  //     scrollController:
                                  //         categoryController.chipsScrollController),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  appText(AppStrings.categories,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.lightBlack),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  appChip(
                                    value: categoryController.categoryId.value,
                                    direction: Axis.vertical,
                                    onChanged: (val) {
                                      categoryController.categoryId.value = val;
                                    },
                                    chipList: categoryController.categoryNames,
                                    selectColor: AppColors.white,
                                    selectFillColor: AppColors.customerMain,
                                    unselecteColor: AppColors.darkGrey,
                                    unselecteFillColor: AppColors.lightGrey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight: 100.h,
                                maxWidth: double.maxFinite,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 15.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            AppColors.black.withOpacity(0.25),
                                        blurRadius: 4.r)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        appText(
                                          AppStrings.distance,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightBlack,
                                        ),
                                        appText(
                                          categoryController.sliderValue.value
                                              .toInt()
                                              .toString(),
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightBlack,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackShape:
                                          const RoundedRectSliderTrackShape(),
                                      trackHeight: 3.h,
                                      thumbColor: AppColors.customerMain,
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 8.r),
                                      overlayShape:
                                          SliderComponentShape.noOverlay,
                                    ),
                                    child: Slider(
                                      min: 0.0,
                                      max: 100.0,
                                      value:
                                          categoryController.sliderValue.value,
                                      activeColor: AppColors.customerMain,
                                      inactiveColor: AppColors.lightBlack
                                          .withOpacity(0.25),
                                      onChanged: (value) {
                                        categoryController.sliderValue.value =
                                            value.toInt().toDouble();
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 7.h),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        appText(AppStrings.dist_min,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            color: AppColors.lightBlack),
                                        appText(AppStrings.dist_max,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            color: AppColors.lightBlack),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: appButton(
                    onTap: () async {
                      if (categoryController.sortByValidation()) {
                        if (categoryController.categoryValidation()) {
                          if (filterKey.currentState!.validate()) {
                            await categoryController
                                .getFilterBusiness()
                                .then((response) async {
                              Get.back();
                            });
                          }
                        }
                      }
                    },
                    height: 61.h,
                    width: double.maxFinite,
                    buttonColor: AppColors.customerMain,
                    borderRadius: BorderRadius.circular(10.r),
                    buttonText: AppStrings.apply_filter,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: categoryController.loading.value,
              child: appLoader(
                loaderColor: AppColors.white,
                onWillPop: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
