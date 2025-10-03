import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_strings.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_input_field.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_text.dart';
import 'forgot_pass_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  ForgotPassController forgotPassController = Get.put(ForgotPassController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    forgotPassController.passwordController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        alignment: Alignment.center,
        children: [
          ColorfulSafeArea(
            color: AppColors.white,
            child: Scaffold(
              backgroundColor: AppColors.white,
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Column(
                    children: [
                      Image.asset(
                        AppAssets.logo_img,
                        width: 118.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      SizedBox(
                        width: 200.w,
                        child: appText(AppStrings.reset_your_password,
                            fontSize: 35.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightBlack),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      appText(AppStrings.enter_new_password,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.lightBlack),
                      SizedBox(
                        height: 60.h,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            appInputField(
                                height: 50.h,
                                controller:
                                    forgotPassController.passwordController,
                                hintText: AppStrings.password,
                                prefixImg: AppAssets.password_ic,
                                showSuffix: true,
                                showPrefix: true,
                                visibleTap: () {
                                  forgotPassController.visiblePassword.value =
                                      !forgotPassController
                                          .visiblePassword.value;
                                },
                                visiblePassword:
                                    forgotPassController.visiblePassword.value,
                                validator: (value) {
                                  return forgotPassController
                                      .passwordValidation();
                                }),
                            SizedBox(
                              height: 30.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: appButton(
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      forgotPassController.resetPassword();
                                    }
                                  },
                                  height: 61.h,
                                  width: double.maxFinite,
                                  buttonText: AppStrings.reset,
                                  buttonColor: AppColors.customerMain,
                                  textColor: AppColors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700),
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
            visible: forgotPassController.loading.value,
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
