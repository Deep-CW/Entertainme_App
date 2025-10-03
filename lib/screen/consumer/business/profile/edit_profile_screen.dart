// ignore_for_file: sort_child_properties_last

import 'dart:io';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_constants.dart';
import '../../../../constant/app_list.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../main.dart';
import '../../../../services/image_service.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_input_field.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_network_image.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/opening_hour_widget.dart';
import '../location/business_location.dart';
import 'profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());
  final GlobalKey<FormState> editProfileKey = GlobalKey<FormState>();

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
                title: AppStrings.business_profile,
                onTap: () {
                  Get.back();
                },
              ),
              body: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                shrinkWrap: true,
                children: [
                  Form(
                    key: editProfileKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: DottedBorder(
                              borderType: BorderType.Circle,
                              color: AppColors.lightBlack,
                              dashPattern: const [15, 15],
                              child: InkWell(
                                onTap: () async {
                                  var pickedImg = await ImageService.pickImage(
                                      color: AppColors.businessMain);

                                  if (pickedImg != null) {
                                    profileController.profileImage.value =
                                        pickedImg;
                                  }
                                },
                                child: Container(
                                  height: 115.h,
                                  width: 115.w,
                                  padding: EdgeInsets.all(9.r),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Obx(
                                    () => Stack(
                                      children: [
                                        profileController
                                                .profileImage.value.isEmpty
                                            ? Image.asset(
                                                AppAssets.profilepic_img,
                                                width: 97.w,
                                              )
                                            : box.read(
                                                    AppConstants.IS_NETWORK_IMG)
                                                ? appNetworkImage(
                                                    url: profileController
                                                        .profileImage.value,
                                                    loaderColor:
                                                        AppColors.businessMain,
                                                    errorIconSize: 15.sp,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: 115.h,
                                                      width: 115.w,
                                                      padding:
                                                          EdgeInsets.all(9.r),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                imageProvider),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 115.h,
                                                    width: 115.w,
                                                    padding:
                                                        EdgeInsets.all(9.r),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: FileImage(
                                                          File(profileController
                                                              .profileImage
                                                              .value),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                        Container(
                                          height: 115.h,
                                          width: 115.w,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(9.r),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightBlack
                                                .withOpacity(0.6),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            AppAssets.pickimg_img,
                                            width: 11.w,
                                            height: 11.h,
                                          ),
                                        )
                                      ],
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          appText(AppStrings.owner_name,
                              color: AppColors.lightBlack.withOpacity(0.5),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start),
                          SizedBox(
                            height: 10.h,
                          ),
                          appInputField(
                            height: 50.h,
                            hintText: AppStrings.owner_name,
                            showSuffix: false,
                            showPrefix: false,
                            givePadding: false,
                            controller: profileController.ownernameController,
                            prefixColor: AppColors.lightBlack,
                            fillColor: AppColors.white,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: AppColors.black.withOpacity(0.10),
                                  blurRadius: 4.r)
                            ]),
                            validator: (value) {
                              return profileController.ownerNameValidation();
                            },
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          appText(AppStrings.number,
                              color: AppColors.lightBlack.withOpacity(0.5),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            height: 50.h,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.black.withOpacity(0.25),
                                      blurRadius: 4.r)
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          profileController.countryFlag.value,
                                          package: countryCodePackageName,
                                          width: 20.w,
                                          height: 20.h,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: AppColors.darkGrey,
                                          size: 20.sp,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50.h,
                                  color: AppColors.darkGrey,
                                  width: 1.w,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: appInputField(
                                        key: ValueKey(profileController
                                            .initialCountryData),
                                        height: 50.h,
                                        hintText: AppStrings.phone_number,
                                        showSuffix: false,
                                        showPrefix: false,
                                        givePadding: false,
                                        readOnly: true,
                                        controller:
                                            profileController.numberController,
                                        fillColor: AppColors.white,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          profileController.phoneInputFormatter
                                        ],
                                        decoration: const BoxDecoration()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          appText(AppStrings.location_text,
                              color: AppColors.lightBlack.withOpacity(0.5),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start),
                          SizedBox(
                            height: 10.h,
                          ),
                          appInputField(
                            height: 50.h,
                            hintText: AppStrings.location_text,
                            showSuffix: false,
                            showPrefix: false,
                            givePadding: false,
                            controller:
                                profileController.businesslocationController,
                            prefixColor: AppColors.lightBlack,
                            fillColor: AppColors.white,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: AppColors.black.withOpacity(0.10),
                                  blurRadius: 4.r)
                            ]),
                            validator: (value) {
                              return profileController
                                  .businessLocationValidation();
                            },
                            maxLines: 1,
                            onTap: () async {
                              final locationValue =
                                  await Get.to(() => const BusinessLocation());
                              if (locationValue != null) {
                                profileController.businesslocationController
                                    .text = locationValue["location"];
                                profileController.lat = locationValue["lat"];
                                profileController.lng = locationValue["lng"];
                              }
                            },
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          appText(AppStrings.business_category,
                              color: AppColors.lightBlack.withOpacity(0.5),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                              // height: 150.h,
                              width: double.maxFinite,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 15.h),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            AppColors.black.withOpacity(0.25),
                                        blurRadius: 4.r)
                                  ]),
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 10.w,
                                runSpacing: 10.h,
                                children: List.generate(
                                  profileController.categoryNames.length,
                                  (index) => Obx(
                                    () => InkWell(
                                      onTap: () {
                                        String id = profileController
                                            .categoryNames[index]['id'];
                                        profileController.categories
                                            .forEach((element) {
                                          if (element.catId == id) {
                                            profileController
                                                .businessCategory.value = id;
                                            profileController
                                                    .businessCategoryName
                                                    .value =
                                                element.catName.toString();
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.h, horizontal: 15.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                          color: profileController
                                                      .businessCategory.value ==
                                                  profileController
                                                          .categoryNames[index]
                                                      ['id']
                                              ? AppColors.businessMain
                                              : AppColors.lightWhite,
                                        ),
                                        child: appText(
                                          profileController.categoryNames[index]
                                              ['name'],
                                          color: profileController
                                                      .businessCategory.value ==
                                                  profileController
                                                          .categoryNames[index]
                                                      ['id']
                                              ? AppColors.white
                                              : AppColors.darkGrey,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              //  appChip(
                              //     value: profileController.businessCategory.value,
                              //     direction: Axis.horizontal,
                              //     height: 100.h,
                              //     onChanged: (val) {
                              //       setState(() {
                              //         profileController.categories
                              //             .forEach((element) {
                              //           if (element.catId == val) {
                              //             profileController
                              //                 .businessCategory.value = val;
                              //             profileController.businessCategoryName
                              //                 .value = element.catName.toString();
                              //           }
                              //         });
                              //       });
                              //     },
                              //     chipList: profileController.categoryNames.value,
                              //     selectColor: AppColors.white,
                              //     selectFillColor: AppColors.businessMain,
                              //     unselecteColor: AppColors.lightBlack,
                              //     unselecteFillColor: AppColors.lightWhite,
                              //     scrollController:
                              //         profileController.chipsScrollController),
                              ),
                          SizedBox(
                            height: 15.h,
                          ),
                          appText(AppStrings.business_detail,
                              color: AppColors.lightBlack.withOpacity(0.5),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start),
                          SizedBox(
                            height: 10.h,
                          ),
                          appInputField(
                            height: 145.h,
                            hintText: AppStrings.business_detail,
                            showSuffix: false,
                            showPrefix: false,
                            givePadding: false,
                            maxLines: 300,
                            controller:
                                profileController.businessdetailController,
                            prefixColor: AppColors.lightBlack,
                            fillColor: AppColors.white,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: AppColors.black.withOpacity(0.25),
                                  blurRadius: 4.r)
                            ]),
                            validator: (value) {
                              return profileController
                                  .businessDetailValidation();
                            },
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          appText(AppStrings.business_photos,
                              color: AppColors.lightBlack.withOpacity(0.5),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            height: 215.h,
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 15.h,
                            ),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.black.withOpacity(0.25),
                                      blurRadius: 4.r)
                                ]),
                            child: GridView.builder(
                                shrinkWrap: true,
                                cacheExtent: 1000,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 12.w,
                                        mainAxisSpacing: 12.h,
                                        childAspectRatio: 1),
                                scrollDirection: Axis.vertical,
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () async {
                                        if (profileController
                                                .businessImages[index].value ==
                                            '') {
                                          var pickedImg =
                                              await ImageService.pickImage(
                                                  color:
                                                      AppColors.businessMain);

                                          if (pickedImg != null) {
                                            profileController
                                                .businessImages[index]
                                                .value = pickedImg;
                                          }
                                        }
                                      },
                                      child: Obx(
                                        () => Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            profileController
                                                    .businessImages[index]
                                                    .value
                                                    .isEmpty
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.r),
                                                      color:
                                                          AppColors.lightWhite,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Image.asset(
                                                      AppAssets.gallery_ic,
                                                      width: 20.w,
                                                      // height: 20.h,
                                                      fit: BoxFit.cover,
                                                    ))
                                                : profileController
                                                            .businessNetworkImages[
                                                                index]
                                                            .value ==
                                                        true
                                                    ? appNetworkImage(
                                                        url:
                                                            "${AppUrls.BASE_API}${profileController.businessImages[index].value}",
                                                        loaderColor: AppColors
                                                            .businessMain,
                                                        errorIconSize: 15.sp,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.r),
                                                            color: AppColors
                                                                .lightWhite,
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  imageProvider,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(5
                                                                            .r),
                                                                color: AppColors
                                                                    .lightWhite,
                                                                image:
                                                                    DecorationImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image:
                                                                            FileImage(
                                                                          File(profileController
                                                                              .businessImages[index]
                                                                              .value),
                                                                        ))),
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(9.r),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                color: AppColors.lightBlack
                                                    .withOpacity(0.6),
                                              ),
                                              child: Image.asset(
                                                AppAssets.pickimg_img,
                                                width: 11.w,
                                                height: 11.h,
                                              ),
                                            ),
                                            profileController
                                                    .businessImages[index]
                                                    .value
                                                    .isNotEmpty
                                                ? Positioned(
                                                    top: -8,
                                                    right: -8,
                                                    child: InkWell(
                                                      onTap: () {
                                                        profileController
                                                            .businessImages[
                                                                index]
                                                            .value = '';
                                                        profileController
                                                            .businessNetworkImages[
                                                                index]
                                                            .value = false;
                                                      },
                                                      child: Image.asset(
                                                        AppAssets.cancel_ic,
                                                        width: 18.w,
                                                        height: 18.h,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox()
                                          ],
                                          alignment: Alignment.center,
                                        ),
                                      ));
                                }),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                            // height: 340.h,
                            // constraints: BoxConstraints(maxHeight: 500.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 15.h),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.black.withOpacity(0.25),
                                      blurRadius: 4.r)
                                ]),
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
                                    return Obx(() => openingHourWidget(
                                          days: AppList.daysList[index],
                                          closeValue:
                                              profileController.check[index],
                                          openTimeText: profileController
                                              .openTime[index].value,
                                          closeTimeText: profileController
                                              .closeTime[index].value,
                                          onChanged: (value) {
                                            profileController
                                                .check[index].value = value!;
                                          },
                                          onChangedOpenTime:
                                              (String? newValue) {
                                            profileController.openTime[index]
                                                .value = newValue!;
                                          },
                                          onChangedCloseTime:
                                              (String? newValue) {
                                            profileController.closeTime[index]
                                                .value = newValue!;
                                          },
                                        ));
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 20.h,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                        ]),
                  ),
                  appButton(
                      onTap: () {
                        for (int i = 0;
                            i < profileController.check.length;
                            i++) {
                          if (i == 0) {
                            profileController.mon =
                                "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${profileController.openTime[i].value.toString()}\", \"to_time\": \"${profileController.closeTime[i].value.toString()}\",\"is_closed\":${profileController.check[i].value.toString()}}";
                          } else if (i == 1) {
                            profileController.tue =
                                "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${profileController.openTime[i].value.toString()}\", \"to_time\": \"${profileController.closeTime[i].value.toString()}\",\"is_closed\":${profileController.check[i].value.toString()}}";
                          } else if (i == 2) {
                            profileController.wed =
                                "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${profileController.openTime[i].value.toString()}\", \"to_time\": \"${profileController.closeTime[i].value.toString()}\",\"is_closed\":${profileController.check[i].value.toString()}}";
                          } else if (i == 3) {
                            profileController.thu =
                                "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${profileController.openTime[i].value.toString()}\", \"to_time\": \"${profileController.closeTime[i].value.toString()}\",\"is_closed\":${profileController.check[i].value.toString()}}";
                          } else if (i == 4) {
                            profileController.fri =
                                "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${profileController.openTime[i].value.toString()}\", \"to_time\": \"${profileController.closeTime[i].value.toString()}\",\"is_closed\":${profileController.check[i].value.toString()}}";
                          } else if (i == 5) {
                            profileController.sat =
                                "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${profileController.openTime[i].value.toString()}\", \"to_time\": \"${profileController.closeTime[i].value.toString()}\",\"is_closed\":${profileController.check[i].value.toString()}}";
                          } else if (i == 6) {
                            profileController.sun =
                                "{\"day\":\"${AppList.daysList[i].toString()}\", \"from_time\": \"${profileController.openTime[i].value.toString()}\", \"to_time\": \"${profileController.closeTime[i].value.toString()}\",\"is_closed\":${profileController.check[i].value.toString()}}";
                          }
                        }
                        if (profileController.numberValidation()) {
                          if (profileController
                              .businessProfileImageValidation()) {
                            if (profileController
                                .businessCategoryValidation()) {
                              if (profileController
                                  .businessOutletImageValidation()) {
                                if (profileController.openHourValidation()) {
                                  if (editProfileKey.currentState!.validate()) {
                                    profileController.editProfileDetail();
                                  }
                                }
                              }
                            }
                          }
                        }
                      },
                      height: 61.h,
                      width: double.maxFinite,
                      buttonText: AppStrings.save,
                      buttonColor: AppColors.businessMain,
                      textColor: AppColors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700),
                ],
              ),
            ),
          ),
          Visibility(
            visible: profileController.loading.value,
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
