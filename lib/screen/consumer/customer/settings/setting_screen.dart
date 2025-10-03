import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../main.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/app_dialog_box.dart';
import '../../../../widgets/app_drawer_Item.dart';
import '../../../../widgets/app_loader.dart';
import 'change_password_screen.dart';
import 'settings_controller.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SettingController settingController = Get.put(SettingController());

  @override
  void initState() {
    settingController.socialLogin.value = box.read(AppConstants.SOCIAL_LOGIN);

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
                  title: AppStrings.setting,
                  onTap: () {
                    Get.back();
                  }),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  children: [
                    appDrawerItem(
                      title: AppStrings.notification,
                      image: AppAssets.notification_fill_ic,
                      trailing: AdvancedSwitch(
                        height: 25.h,
                        width: 54.w,
                        borderRadius: BorderRadius.circular(150.r),
                        activeColor: AppColors.customerMain,
                        inactiveColor: AppColors.darkGrey,
                        initialValue: settingController.notification.value,
                        onChanged: (value) {
                          settingController.updateNotification();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    appDrawerItem(
                        title: AppStrings.terms_condition,
                        image: AppAssets.terms_ic,
                        onTap: () {
                          settingController.termAndCondition();
                        }),
                    SizedBox(
                      height: 15.h,
                    ),
                    appDrawerItem(
                      title: AppStrings.privacy,
                      image: AppAssets.privacy_ic,
                      onTap: () {
                        settingController.privacy();
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    settingController.socialLogin.value
                        ? const SizedBox()
                        : appDrawerItem(
                            title: AppStrings.change_password,
                            image: AppAssets.password_ic,
                            onTap: () {
                              Get.to(() => const ChangePasswordScreen());
                            }),
                    settingController.socialLogin.value
                        ? const SizedBox()
                        : SizedBox(
                            height: 15.h,
                          ),
                    appDrawerItem(
                        title: AppStrings.about_us,
                        image: AppAssets.about_us_ic,
                        onTap: () {
                          settingController.aboutUs();
                        }),
                    SizedBox(
                      height: 15.h,
                    ),
                    appDrawerItem(
                      title: AppStrings.logout,
                      image: AppAssets.logout_ic,
                      onTap: () {
                        appDialogBox(
                            title: AppStrings.logout,
                            content: AppStrings.logout_confirm,
                            confirmText: AppStrings.yes_text,
                            cancelText: AppStrings.no_text,
                            confirmBtnColor: AppColors.customerMain,
                            confirm: () {
                              Get.back();
                              settingController.logoutCall();
                            });
                      },
                    ),
                    const Spacer(),
                    appDrawerItem(
                      title: AppStrings.delete_account,
                      image: AppAssets.delete_ic,
                      fontSize: 15.sp,
                      imageColor: AppColors.red,
                      textColor: AppColors.red,
                      onTap: () {
                        appDialogBox(
                            title: AppStrings.delete_account,
                            content: AppStrings.delete_confirm,
                            confirmText: AppStrings.yes_text,
                            cancelText: AppStrings.no_text,
                            confirmBtnColor: AppColors.red,
                            confirm: () {
                              Get.back();
                              settingController.deleteUser();
                            });
                      },
                    ),
                  ],
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
