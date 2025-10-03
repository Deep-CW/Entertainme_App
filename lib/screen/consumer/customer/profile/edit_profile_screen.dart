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
import '../../../../constant/app_strings.dart';
import '../../../../main.dart';
import '../../../../services/image_service.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_input_field.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_network_image.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../../../widgets/app_text.dart';
import 'profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());
  final GlobalKey<FormState> editKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    profileController.phoneNumberFormat(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          ColorfulSafeArea(
            color: AppColors.white,
            child: WillPopScope(
              onWillPop: () async {
                profileController.getProfileDetail();
                return true;
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: AppColors.white,
                appBar: appAppBar(
                    title: AppStrings.edit_profile,
                    onTap: () {
                      profileController.getProfileDetail();
                      Get.back();
                    }),
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    child: Form(
                      key: editKey,
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
                                      color: AppColors.customerMain);

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
                                  child: Stack(
                                    children: [
                                      profileController
                                              .profileImage.value.isEmpty
                                          ? Image.asset(
                                              AppAssets.profilepic_img,
                                              width: 97.w,
                                              fit: BoxFit.cover,
                                            )
                                          : box.read(
                                                  AppConstants.IS_NETWORK_IMG)
                                              ? appNetworkImage(
                                                  url: profileController
                                                      .profileImage.value,
                                                  loaderColor:
                                                      AppColors.customerMain,
                                                  errorIconSize: 20.sp,
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
                              controller: profileController.usernameController,
                              prefixColor: AppColors.lightBlack,
                              fillColor: AppColors.white,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: AppColors.black.withOpacity(0.10),
                                    blurRadius: 4.r)
                              ]),
                              validator: (value) {
                                return profileController.userNameValidation();
                              }),
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
                              readOnly: true,
                              prefixImg: AppAssets.email_ic,
                              keyboardType: TextInputType.emailAddress,
                              givePadding: false,
                              controller: profileController.emailController,
                              prefixColor: AppColors.lightBlack,
                              fillColor: AppColors.white,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: AppColors.black.withOpacity(0.10),
                                    blurRadius: 4.r)
                              ]),
                              validator: (value) {
                                return profileController.emailValidation();
                              }),
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
                                  //flex: 2,
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
                          SizedBox(
                            height: 100.h,
                          ),
                          appButton(
                              onTap: () {
                                if (editKey.currentState!.validate()) {
                                  if (profileController
                                      .profileImage.isNotEmpty) {
                                    profileController.editProfile();
                                  } else {
                                    appSnackbar(
                                        error: true,
                                        content: 'Select profile image');
                                  }
                                }
                              },
                              height: 61.h,
                              width: double.maxFinite,
                              borderRadius: BorderRadius.circular(10.r),
                              buttonColor: AppColors.customerMain,
                              buttonText: AppStrings.save,
                              textColor: AppColors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700),
                        ],
                      ),
                    ),
                  ),
                ),
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
