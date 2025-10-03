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

import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/app_input_field.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_network_image.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/opening_hour_widget.dart';
import 'edit_profile_screen.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    profileController.phoneNumberFormat(context);
    profileController.getProfileDetail();

    super.initState();
  }

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
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: InkWell(
                        onTap: () {
                          box.write(AppConstants.IS_NETWORK_IMG, true);
                          Get.to(() => const EditProfileScreen())
                              ?.then((value) {
                            profileController.getProfileDetail();
                          });
                        },
                        child: Image.asset(
                          AppAssets.edit_ic,
                          height: 20.h,
                          width: 20.w,
                        ),
                      ),
                    )
                  ]),
              body: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                shrinkWrap: true,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: DottedBorder(
                      borderType: BorderType.Circle,
                      color: AppColors.lightBlack,
                      dashPattern: const [15, 15],
                      child: Container(
                          height: 115.h,
                          width: 115.w,
                          padding: EdgeInsets.all(9.r),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: appNetworkImage(
                            url: profileController.profileImage.value,
                            loaderColor: AppColors.businessMain,
                            errorIconSize: 20.sp,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 115.h,
                              width: 115.w,
                              padding: EdgeInsets.all(9.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: imageProvider),
                              ),
                            ),
                          )),
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
                    readOnly: true,
                    controller: profileController.ownernameController,
                    prefixColor: AppColors.lightBlack,
                    fillColor: AppColors.white,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.black.withOpacity(0.10),
                              blurRadius: 4.r)
                        ]),
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
                    alignment: Alignment.center,
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
                                key: ValueKey(
                                    profileController.initialCountryData),
                                height: 50.h,
                                hintText: AppStrings.phone_number,
                                showSuffix: false,
                                showPrefix: false,
                                givePadding: false,
                                readOnly: true,
                                controller: profileController.numberController,
                                keyboardType: TextInputType.phone,
                                fillColor: Colors.white,
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
                    readOnly: true,
                    controller: profileController.businesslocationController,
                    fillColor: AppColors.white,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.black.withOpacity(0.10),
                              blurRadius: 4.r)
                        ]),
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
                  profileController.categoryNames.isNotEmpty
                      ? Container(
                          // height: 150.h,
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
                          child: Obx(() => Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: 10.w,
                                    runSpacing: 10.h,
                                    children: List.generate(
                                      profileController.categoryNames.length,
                                      (index) => Obx(
                                        () => Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h, horizontal: 15.w),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                            color: profileController
                                                        .businessCategory
                                                        .value ==
                                                    profileController
                                                            .categoryNames[
                                                        index]['id']
                                                ? AppColors.businessMain
                                                : AppColors.lightWhite,
                                          ),
                                          child: appText(
                                            profileController
                                                .categoryNames[index]['name'],
                                            color: profileController
                                                        .businessCategory
                                                        .value ==
                                                    profileController
                                                            .categoryNames[
                                                        index]['id']
                                                ? AppColors.white
                                                : AppColors.darkGrey,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              // appChip(
                              //     value: profileController
                              //         .businessCategory.value,
                              //     direction: Axis.horizontal,
                              //     height: 100.h,
                              //     onChanged: (val) {},
                              //     chipList: profileController.categoryNames,
                              //     selectColor: AppColors.white,
                              //     selectFillColor: AppColors.businessMain,
                              //     unselecteColor: AppColors.darkGrey,
                              //     unselecteFillColor: AppColors.lightWhite,
                              //     scrollController: profileController
                              //         .chipsScrollController),
                              // Container(
                              //   constraints: BoxConstraints(maxHeight: 100.h),
                              //   child: Wrap(
                              //      child: ChipsChoice<String>.single(
                              //       value: profileController
                              //           .businessCategory.value,
                              //       onChanged: (value) {},
                              //       direction: Axis.horizontal,
                              //       choiceItems:
                              //           C2Choice.listFrom<String, dynamic>(
                              //         source: profileController.categoryNames,
                              //         value: (i, v) => v["id"],
                              //         label: (i, v) => v["name"],
                              //         tooltip: (i, v) => v["name"],
                              //       ),
                              //       alignment: WrapAlignment.start,
                              //       runAlignment: WrapAlignment.start,
                              //       wrapCrossAlignment:
                              //           WrapCrossAlignment.start,
                              //       choiceCheckmark: false,
                              //       padding: EdgeInsets.zero,
                              //       choiceStyle: C2ChipStyle.filled(
                              //         padding: EdgeInsets.symmetric(
                              //             vertical: 5.h, horizontal: 15.w),
                              //         backgroundOpacity: 1.0,
                              //         color: AppColors.lightWhite,
                              //         borderRadius: BorderRadius.circular(50.r),
                              //         borderStyle: BorderStyle.solid,
                              //         foregroundStyle: TextStyle(
                              //             fontSize: 14.sp,
                              //             fontWeight: FontWeight.w500,
                              //             color: AppColors.darkGrey,
                              //             fontFamily: 'Urbanist'),
                              //         selectedStyle: C2ChipStyle.filled(
                              //           color: AppColors.businessMain,
                              //           backgroundOpacity: 1.0,
                              //           borderRadius:
                              //               BorderRadius.circular(50.r),
                              //           foregroundStyle: TextStyle(
                              //               fontSize: 14.sp,
                              //               fontWeight: FontWeight.w500,
                              //               color: AppColors.white,
                              //               fontFamily: 'Urbanist'),
                              //         ),
                              //       ),
                              //       wrapped: true,
                              //     ),
                              //   ),
                              //  ),
                              ),
                        )
                      : const SizedBox(),
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
                    readOnly: true,
                    maxLines: 300,
                    controller: profileController.businessdetailController,
                    prefixColor: AppColors.lightBlack,
                    fillColor: AppColors.white,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.black.withOpacity(0.25),
                              blurRadius: 4.r)
                        ]),
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 1),
                        scrollDirection: Axis.vertical,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Obx(
                            () => profileController.businessImages.isNotEmpty
                                ? profileController
                                        .businessImages[index].value.isEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          color: AppColors.lightWhite,
                                        ),
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          AppAssets.gallery_ic,
                                          width: 20.w,
                                          // height: 20.h,
                                          fit: BoxFit.cover,
                                        ))
                                    : box.read(AppConstants.IS_NETWORK_IMG)
                                        ? appNetworkImage(
                                            url:
                                                "${AppUrls.BASE_API}${profileController.businessImages[index].value}",
                                            loaderColor: AppColors.businessMain,
                                            errorIconSize: 15.sp,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                color: AppColors.lightWhite,
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: imageProvider,
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                color: AppColors.lightWhite,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(
                                                      File(profileController
                                                          .businessImages[index]
                                                          .value),
                                                    ))),
                                            alignment: Alignment.center,
                                          )
                                : const SizedBox(),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    // height: 340.h,
                    // constraints: BoxConstraints(maxHeight: 500.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
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
                            return openingHourWidget(
                                days: AppList.daysList[index],
                                closeValue: profileController.check[index],
                                openTimeText:
                                    profileController.openTime[index].value,
                                closeTimeText:
                                    profileController.closeTime[index].value,
                                onChanged: (v) {});
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 20.h,
                          ),
                        ),
                      ],
                    ),
                  ),
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
