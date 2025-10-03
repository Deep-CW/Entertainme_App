import 'package:colorful_safe_area/colorful_safe_area.dart';

import 'package:flutter/gestures.dart';
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
import '../forgot_password/forgot_password_screen.dart';
import '../signup/signup_screen.dart';
import 'login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  BusinessLoginController loginController = Get.put(BusinessLoginController());
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
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
                        //  height: 151.h,
                        width: 118.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      appText(AppStrings.welcome,
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.lightBlack),
                      SizedBox(
                        height: 10.h,
                      ),
                      appText(AppStrings.loginandstart,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.lightBlack),
                      SizedBox(
                        height: 60.h,
                      ),
                      Form(
                        key: loginKey,
                        child: Column(
                          children: [
                            appInputField(
                                height: 50.h,
                                controller: loginController.emailController,
                                hintText: AppStrings.email,
                                prefixImg: AppAssets.email_ic,
                                keyboardType: TextInputType.emailAddress,
                                showSuffix: false,
                                showPrefix: true,
                                validator: (value) {
                                  return loginController.emailValidation();
                                }),
                            SizedBox(
                              height: 10.h,
                            ),
                            appInputField(
                                height: 50.h,
                                controller: loginController.passwordController,
                                hintText: AppStrings.password,
                                prefixImg: AppAssets.password_ic,
                                showSuffix: true,
                                showPrefix: true,
                                visibleTap: () {
                                  loginController.passwordVisible.value =
                                      !loginController.passwordVisible.value;
                                },
                                visiblePassword:
                                    loginController.passwordVisible.value,
                                maxLines: null,
                                validator: (value) {
                                  return loginController.passwordValidation();
                                }),
                            SizedBox(
                              height: 15.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: Checkbox(
                                      value: loginController.check.value,
                                      activeColor: AppColors.businessMain,
                                      side: BorderSide(
                                          color: AppColors.lightBlack,
                                          width: 1.w),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                      ),
                                      onChanged: (value) {
                                        loginController.check.value = value!;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  appText(AppStrings.remember,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightBlack),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                          () => const ForgotPasswordScreen());
                                    },
                                    child: appText(AppStrings.forgot_password,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.lightBlack),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: appButton(
                                  onTap: () {
                                    if (loginKey.currentState!.validate()) {
                                      loginController.login();
                                      // loginController.saveDetail();
                                    }
                                  },
                                  height: 61.h,
                                  width: double.maxFinite,
                                  buttonText: AppStrings.login_text,
                                  buttonColor: AppColors.businessMain,
                                  textColor: AppColors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                              text: AppStrings.donthave_account,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.lightBlack,
                                  fontFamily: 'Urbanist'),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        Get.to(() => const SignupScreen()),
                                  text: AppStrings.signup,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightBlack,
                                      fontFamily: 'Urbanist'),
                                )
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: loginController.loading.value,
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
