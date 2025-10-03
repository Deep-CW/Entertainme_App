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
import '../../../../constant/app_strings.dart';
import '../../../../main.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/app_input_field.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_network_image.dart';
import '../../../../widgets/app_text.dart';
import 'edit_profile_screen.dart';
import 'profile_controller.dart';
import '../settings/setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.phoneNumberFormat(context);
    profileController.getCountryFlagFromCode(
        context, box.read(AppConstants.COUNTRY_CODE).toString());
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
                  backgroundColor: AppColors.white,
                  leadingImg: AppAssets.edit_ic,
                  title: AppStrings.your_profile,
                  onTap: () {
                    Get.to(() => EditProfileScreen());
                  },
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const SettingScreen());
                        },
                        child: Image.asset(
                          AppAssets.setting_ic,
                          height: 20.h,
                          width: 20.w,
                        ),
                      ),
                    )
                  ]),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: profileController.profileImage.value.isEmpty
                                ? Image.asset(
                                    AppAssets.profilepic_img,
                                    width: 97.w,
                                  )
                                : box.read(AppConstants.IS_NETWORK_IMG)
                                    ? appNetworkImage(
                                        url: profileController
                                            .profileImage.value,
                                        loaderColor: AppColors.customerMain,
                                        errorIconSize: 20.sp,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 115.h,
                                          width: 115.w,
                                          padding: EdgeInsets.all(9.r),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: imageProvider),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 115.h,
                                        width: 115.w,
                                        padding: EdgeInsets.all(9.r),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                              File(profileController
                                                  .profileImage.value),
                                            ),
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      appText(AppStrings.user_name,
                          color: AppColors.lightBlack.withOpacity(0.5),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                      SizedBox(
                        height: 10.h,
                      ),
                      appInputField(
                        height: 50.h,
                        hintText: AppStrings.user_name,
                        showSuffix: false,
                        showPrefix: true,
                        prefixImg: AppAssets.user_ic,
                        givePadding: false,
                        readOnly: true,
                        controller: profileController.usernameController,
                        prefixColor: AppColors.lightBlack,
                        fillColor: AppColors.white,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: AppColors.black.withOpacity(0.10),
                              blurRadius: 4.r)
                        ]),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      appText(AppStrings.email,
                          color: AppColors.lightBlack.withOpacity(0.5),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                      SizedBox(
                        height: 10.h,
                      ),
                      appInputField(
                        height: 50.h,
                        hintText: AppStrings.email,
                        showSuffix: false,
                        showPrefix: true,
                        prefixImg: AppAssets.email_ic,
                        givePadding: false,
                        readOnly: true,
                        controller: profileController.emailController,
                        prefixColor: AppColors.lightBlack,
                        fillColor: AppColors.white,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: AppColors.black.withOpacity(0.10),
                              blurRadius: 4.r)
                        ]),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      appText(AppStrings.phone_number,
                          color: AppColors.lightBlack.withOpacity(0.5),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        height: 50.h,
                        width: double.maxFinite,
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
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
                            Padding(
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
                            Container(
                              height: 50.h,
                              color: AppColors.darkGrey,
                              width: 1.w,
                            ),
                            Expanded(
                              //  flex: 2,
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
                                    controller:
                                        profileController.phoneController,
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: profileController.loading.value,
            child: appLoader(
              loaderColor: AppColors.transparent,
              giveOpacity: false,
            ),
          ),
        ],
      ),
    );
  }
}
