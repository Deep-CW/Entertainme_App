import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_strings.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_text.dart';
import 'forgot_pass_controller.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  ForgotPassController forgotPassController = Get.put(ForgotPassController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                        child: appText(AppStrings.otp,
                            fontSize: 35.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightBlack),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      appText(AppStrings.enter_otp,
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
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Pinput(
                                controller: forgotPassController.otpController,
                                length: 6,
                                validator: (value) {
                                  return forgotPassController.otpValidation();
                                },
                                defaultPinTheme: PinTheme(
                                  height: 50.h,
                                  width: 60.w,
                                  textStyle: TextStyle(
                                    color: AppColors.lightBlack,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      width: 1.w,
                                      color:
                                          AppColors.darkGrey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                focusedPinTheme: PinTheme(
                                  height: 50.h,
                                  width: 60.w,
                                  textStyle: TextStyle(
                                    color: AppColors.lightBlack,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      width: 1.w,
                                      color: AppColors.customerMain,
                                    ),
                                  ),
                                ),
                                errorPinTheme: PinTheme(
                                  height: 50.h,
                                  width: 60.w,
                                  textStyle: TextStyle(
                                    color: AppColors.lightBlack,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      width: 1.w,
                                      color: AppColors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: appButton(
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      forgotPassController.verifyOTP();
                                    }
                                  },
                                  height: 61.h,
                                  width: double.maxFinite,
                                  buttonText: AppStrings.verify,
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
