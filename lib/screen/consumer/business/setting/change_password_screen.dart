import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_strings.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_input_field.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../../../widgets/app_text.dart';
import 'setting_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  SettingController settingController = Get.put(SettingController());
  final GlobalKey<FormState> changePasswordKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          ColorfulSafeArea(
            color: AppColors.white,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: AppColors.white,
              appBar: appAppBar(
                  title: AppStrings.change_password,
                  onTap: () {
                    Get.back();
                  }),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: Form(
                    key: changePasswordKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppAssets.business_change_password_img,
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        appText(AppStrings.current_password,
                            color: AppColors.lightBlack.withOpacity(0.5),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                        SizedBox(
                          height: 10.h,
                        ),
                        appInputField(
                          height: 50.h,
                          hintText: AppStrings.current_password,
                          showSuffix: true,
                          showPrefix: false,
                          givePadding: false,
                          controller:
                              settingController.currentPasswordController,
                          prefixColor: AppColors.lightBlack,
                          visibleTap: () {
                            settingController.visibleCurrentPassword.value =
                                !settingController.visibleCurrentPassword.value;
                          },
                          visiblePassword:
                              settingController.visibleCurrentPassword.value,
                          fillColor: AppColors.white,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: AppColors.black.withOpacity(0.10),
                                blurRadius: 4.r)
                          ]),
                          validator: (v) {
                            return settingController.passwordValidation(
                                settingController.currentPasswordController);
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        appText(AppStrings.new_password,
                            color: AppColors.lightBlack.withOpacity(0.5),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                        SizedBox(
                          height: 10.h,
                        ),
                        appInputField(
                          height: 50.h,
                          hintText: AppStrings.new_password,
                          showSuffix: true,
                          showPrefix: false,
                          givePadding: false,
                          controller: settingController.newPasswordController,
                          prefixColor: AppColors.lightBlack,
                          visibleTap: () {
                            settingController.visibleNewPassword.value =
                                !settingController.visibleNewPassword.value;
                          },
                          visiblePassword:
                              settingController.visibleNewPassword.value,
                          fillColor: AppColors.white,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: AppColors.black.withOpacity(0.10),
                                blurRadius: 4.r)
                          ]),
                          validator: (v) {
                            return settingController.passwordValidation(
                                settingController.newPasswordController);
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        appText(AppStrings.confirm_password,
                            color: AppColors.lightBlack.withOpacity(0.5),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                        SizedBox(
                          height: 10.h,
                        ),
                        appInputField(
                          height: 50.h,
                          hintText: AppStrings.confirm_password,
                          showSuffix: true,
                          showPrefix: false,
                          givePadding: false,
                          controller:
                              settingController.confirmPasswordController,
                          prefixColor: AppColors.lightBlack,
                          visibleTap: () {
                            settingController.visibleConfirmPassword.value =
                                !settingController.visibleConfirmPassword.value;
                          },
                          visiblePassword:
                              settingController.visibleConfirmPassword.value,
                          fillColor: AppColors.white,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: AppColors.black.withOpacity(0.10),
                                blurRadius: 4.r)
                          ]),
                          validator: (v) {
                            return settingController.passwordValidation(
                                settingController.confirmPasswordController);
                          },
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        appButton(
                            onTap: () {
                              if (changePasswordKey.currentState!.validate()) {
                                if (settingController
                                        .newPasswordController.text ==
                                    settingController
                                        .confirmPasswordController.text) {
                                  settingController.changePassword();
                                } else {
                                  appSnackbar(
                                    error: true,
                                    content: "Password doesn't match",
                                  );
                                }
                              }
                            },
                            height: 61.h,
                            width: double.maxFinite,
                            borderRadius: BorderRadius.circular(15.r),
                            buttonColor: AppColors.businessMain,
                            buttonText: AppStrings.change_password,
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
          Visibility(
            visible: settingController.loading.value,
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
