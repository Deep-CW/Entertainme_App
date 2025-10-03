// ignore_for_file: sort_child_properties_last

import 'dart:io';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_list.dart';
import '../../../../constant/app_strings.dart';
import '../../../../services/image_service.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_chips.dart';
import '../../../../widgets/app_input_field.dart';

import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/opening_hour_widget.dart';
import 'signup_controller.dart';

class SecondSignupScreen extends StatefulWidget {
  const SecondSignupScreen({super.key});

  @override
  State<SecondSignupScreen> createState() => _SecondSignupScreenState();
}

class _SecondSignupScreenState extends State<SecondSignupScreen> {
  SignupController signupController = Get.put(SignupController());
  final GlobalKey<FormState> secondSignUpKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          ColorfulSafeArea(
            color: AppColors.white,
            child: Scaffold(
              backgroundColor: AppColors.white,
              appBar: appAppBar(
                  title: '',
                  onTap: () {
                    Get.back();
                  }),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: ListView(shrinkWrap: true, children: [
                  Form(
                    key: secondSignUpKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 170.h,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.lightGrey,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 15.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              appText(AppStrings.business_category,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lightBlack),
                              SizedBox(
                                height: 20.h,
                              ),
                              appChip(
                                  value:
                                      signupController.businessCategory.value,
                                  direction: Axis.horizontal,
                                  height: 100.h,
                                  onChanged: (val) {
                                    setState(() {
                                      signupController.businessCategory.value =
                                          val;
                                      signupController.categories
                                          .forEach((element) {
                                        if (element.catId == val) {
                                          signupController
                                                  .businessCategoryName.value =
                                              element.catName.toString();
                                        }
                                      });
                                      // signupController
                                      //     .businessCategoryName!.value = val;
                                      // signupController
                                      //     .businessCategoryName!.value =  signupController.categoryNames[int.parse(val)];
                                      print(signupController
                                          .businessCategoryName.value);
                                      // signupController.categories
                                      //     .forEach((element) {
                                      //   if (element.catName ==
                                      //       signupController
                                      //           .businessCategoryName.value) {
                                      //     signupController.businessCategory
                                      //         .value = element.catId.toString();
                                      //   }
                                      // });
                                    });
                                  },
                                  chipList: signupController.categoryNames,
                                  selectColor: AppColors.white,
                                  selectFillColor: AppColors.businessMain,
                                  unselecteColor: AppColors.darkGrey,
                                  unselecteFillColor: AppColors.lightWhite,
                                  scrollController:
                                      signupController.chipsScrollController),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                            height: 180.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColors.lightGrey,
                            ),
                            padding: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                              top: 15.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                appText(AppStrings.business_detail,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.lightBlack),
                                appInputField(
                                    height: 145.h,
                                    hintText: '',
                                    showSuffix: false,
                                    showPrefix: false,
                                    givePadding: false,
                                    controller:
                                        signupController.detailController,
                                    maxLines: 300,
                                    validator: (value) {
                                      return signupController
                                          .detailValidation();
                                    })
                              ],
                            )),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          height: 240.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.lightGrey,
                          ),
                          padding: EdgeInsets.only(
                              left: 10.w, right: 10.w, top: 15.h),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                appText(AppStrings.business_photos,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.lightBlack),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 200.h,
                                    width: double.maxFinite,
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        cacheExtent: 1000,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 16.w,
                                                mainAxisSpacing: 10.h,
                                                childAspectRatio: 1),
                                        scrollDirection: Axis.vertical,
                                        itemCount: 6,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () async {
                                              if (signupController
                                                      .businessImages[index]
                                                      .value ==
                                                  '') {
                                                var pickedImg =
                                                    await ImageService
                                                        .pickImage(
                                                            color: AppColors
                                                                .businessMain);

                                                if (pickedImg != null) {
                                                  signupController
                                                      .businessImages[index]
                                                      .value = pickedImg;
                                                }
                                              }
                                            },
                                            child: Obx(
                                              () => signupController
                                                      .businessImages[index]
                                                      .value
                                                      .isEmpty
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.r),
                                                        color: AppColors
                                                            .lightWhite,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Image.asset(
                                                        AppAssets.gallery_ic,
                                                        width: 20.w,
                                                        // height: 20.h,
                                                        fit: BoxFit.cover,
                                                      ))
                                                  : Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(5
                                                                              .r),
                                                                  color: AppColors
                                                                      .lightWhite,
                                                                  image: DecorationImage(
                                                                      fit: BoxFit.cover,
                                                                      image: FileImage(
                                                                        File(signupController
                                                                            .businessImages[index]
                                                                            .value),
                                                                      ))),
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                        Positioned(
                                                          top: -8,
                                                          right: -8,
                                                          child: InkWell(
                                                            onTap: () {
                                                              signupController
                                                                  .businessImages[
                                                                      index]
                                                                  .value = '';
                                                            },
                                                            child: Image.asset(
                                                              AppAssets
                                                                  .cancel_ic,
                                                              width: 18.w,
                                                              height: 18.h,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                      alignment:
                                                          Alignment.topRight,
                                                    ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          // height: 340.h,
                          // constraints: BoxConstraints(maxHeight: 500.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.lightGrey,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 15.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              appText(AppStrings.open_hour,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lightBlack),
                              SizedBox(
                                height: 25.h,
                              ),
                              ListView.separated(
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: 7,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Obx(
                                    () => openingHourWidget(
                                      days: AppList.daysList[index],
                                      closeValue: signupController.check[index],
                                      openTimeText: signupController
                                          .openTime[index].value,
                                      closeTimeText: signupController
                                          .closeTime[index].value,
                                      onChanged: (value) {
                                        signupController.check[index].value =
                                            value!;
                                      },
                                      onChangedOpenTime: (String? newValue) {
                                        signupController.openTime[index].value =
                                            newValue!;
                                      },
                                      onChangedCloseTime: (String? newValue) {
                                        signupController
                                            .closeTime[index].value = newValue!;
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 20.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        appButton(
                            onTap: () {
                              signupController.openHours = [];

                              for (int i = 0;
                                  i < signupController.check.length;
                                  i++) {
                                if (i == 0) {
                                  signupController.mon =
                                      "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${signupController.openTime[i].value.toString()}\", \"to_time\": \"${signupController.closeTime[i].value.toString()}\",\"is_closed\":${signupController.check[i].value.toString()}}";
                                } else if (i == 1) {
                                  signupController.tue =
                                      "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${signupController.openTime[i].value.toString()}\", \"to_time\": \"${signupController.closeTime[i].value.toString()}\",\"is_closed\":${signupController.check[i].value.toString()}}";
                                } else if (i == 2) {
                                  signupController.wed =
                                      "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${signupController.openTime[i].value.toString()}\", \"to_time\": \"${signupController.closeTime[i].value.toString()}\",\"is_closed\":${signupController.check[i].value.toString()}}";
                                } else if (i == 3) {
                                  signupController.thu =
                                      "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${signupController.openTime[i].value.toString()}\", \"to_time\": \"${signupController.closeTime[i].value.toString()}\",\"is_closed\":${signupController.check[i].value.toString()}}";
                                } else if (i == 4) {
                                  signupController.fri =
                                      "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${signupController.openTime[i].value.toString()}\", \"to_time\": \"${signupController.closeTime[i].value.toString()}\",\"is_closed\":${signupController.check[i].value.toString()}}";
                                } else if (i == 5) {
                                  signupController.sat =
                                      "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${signupController.openTime[i].value.toString()}\", \"to_time\": \"${signupController.closeTime[i].value.toString()}\",\"is_closed\":${signupController.check[i].value.toString()}}";
                                } else if (i == 6) {
                                  signupController.sun =
                                      "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${signupController.openTime[i].value.toString()}\", \"to_time\": \"${signupController.closeTime[i].value.toString()}\",\"is_closed\":${signupController.check[i].value.toString()}}";
                                }

                                signupController.openHours.add({
                                  'day': AppList.daysList[i].toString(),
                                  'from_time': signupController.check[i].value
                                      ? ""
                                      : signupController.openTime[i].value
                                          .toString(),
                                  'to_time': signupController.check[i].value
                                      ? ""
                                      : signupController.closeTime[i].value
                                          .toString(),
                                  'is_closed': signupController.check[i].value
                                      .toString(),
                                });
                              }

                              if (signupController
                                  .businessCategoryValidation()) {
                                if (signupController
                                    .businessOutletImageValidation()) {
                                  if (signupController.openHourValidation()) {
                                    if (secondSignUpKey.currentState!
                                        .validate()) {
                                      signupController.signUp();
                                    }
                                  }
                                }
                              }
                            },
                            height: 61.h,
                            width: double.maxFinite,
                            buttonText: AppStrings.signup,
                            buttonColor: AppColors.businessMain,
                            textColor: AppColors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
          Visibility(
            visible: signupController.loading.value,
            child: appLoader(
              loaderColor: AppColors.white,
              onWillPop: false,
            ),
          ),
        ],
      ),
    );
  }
}
