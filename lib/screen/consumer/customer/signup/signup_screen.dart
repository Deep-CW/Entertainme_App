// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_strings.dart';
import '../../../../helper/phone_input_formattor/flutter_multi_formatter.dart';
import '../../../../services/image_service.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_input_field.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../../../widgets/app_text.dart';
import '../login/customer_login_screen.dart';
import 'signup_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  SignupController signupController = Get.put(SignupController());
  final GlobalKey<FormState> signUpKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    signupController.phoneNumberFormat(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(children: [
        ColorfulSafeArea(
          color: Colors.white,
          child: Scaffold(
            backgroundColor: AppColors.white,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Form(
                  key: signUpKey,
                  child: Column(
                    children: [
                      appText(AppStrings.signup,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.lightBlack),
                      SizedBox(
                        height: 20.h,
                      ),
                      InkWell(
                        onTap: () async {
                          var pickedImg = await ImageService.pickImage(
                              color: AppColors.customerMain);

                          if (pickedImg != null) {
                            signupController.profileImage.value = pickedImg;
                          }
                        },
                        child: signupController.profileImage.value.isEmpty
                            ? Container(
                                height: 78.h,
                                width: 78.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.lightGrey),
                                child: Image.asset(
                                  AppAssets.gallery_ic,
                                  width: 20.w,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                height: 78.h,
                                width: 78.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.lightGrey,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                      File(signupController.profileImage.value),
                                    ),
                                  ),
                                )),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      appInputField(
                        height: 50.h,
                        controller: signupController.usernameController,
                        hintText: AppStrings.user_name,
                        prefixImg: AppAssets.user_ic,
                        showSuffix: false,
                        showPrefix: true,
                        validator: (value) {
                          return signupController.userNameValidation();
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      appInputField(
                        height: 50.h,
                        controller: signupController.emailController,
                        hintText: AppStrings.email,
                        prefixImg: AppAssets.email_ic,
                        showSuffix: false,
                        showPrefix: true,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return signupController.emailValidation();
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Container(
                          height: 50.h,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  final country = await showCountryPickerDialog(
                                      context,
                                      cornerRadius: 20.r,
                                      title: Container(
                                        width: double.maxFinite,
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            appText(AppStrings.select_country,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.lightBlack),
                                            SizedBox(
                                              width: 40.w,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 10.0.w),
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: appText(
                                                    AppStrings.cancel,
                                                    fontSize: 12.sp,
                                                    color: AppColors.lightBlack,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )
                                          ],
                                        ),
                                      ));

                                  signupController.countryFlag.value =
                                      country!.flag;
                                  signupController.countryCode.value =
                                      country.callingCode;
                                  PhoneCodes.getAllCountryDatas()
                                      .forEach((element) {
                                    if (element.countryCode ==
                                        country.countryCode) {
                                      signupController.initialCountryData =
                                          element;

                                      signupController.selectlengthPhone =
                                          signupController.initialCountryData
                                              .phoneMaskWithoutCountryCode
                                              .replaceAll('(', '')
                                              .replaceAll(" ", '')
                                              .replaceAll(")", '')
                                              .replaceAll("-", '')
                                              .toString();
                                    }
                                  });
                                  signupController.phoneInputFormatter =
                                      PhoneInputFormatter(
                                    allowEndlessPhone: false,
                                    defaultCountryCode: signupController
                                        .initialCountryData.countryCode,
                                  );

                                  signupController.phoneController.clear();

                                  setState(() {});
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20.w),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        signupController.countryFlag.value,
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
                                        signupController.initialCountryData),
                                    height: 50.h,
                                    hintText: AppStrings.phone_number,
                                    showSuffix: false,
                                    showPrefix: false,
                                    controller:
                                        signupController.phoneController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                      // signupController.phoneInputFormatter
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      appInputField(
                        height: 50.h,
                        controller: signupController.passwordController,
                        hintText: AppStrings.password,
                        prefixImg: AppAssets.password_ic,
                        showSuffix: true,
                        showPrefix: true,
                        visibleTap: () {
                          signupController.visiblePassword.value =
                              !signupController.visiblePassword.value;
                        },
                        visiblePassword: signupController.visiblePassword.value,
                        validator: (value) {
                          return signupController.passwordValidation();
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: appButton(
                            onTap: () {
                              signupController.lengthPhone = signupController
                                  .phoneInputFormatter.unmasked
                                  .replaceAll("+", "")
                                  .toString();

                              if (signupController.phoneValidation()) {
                                if (signUpKey.currentState!.validate()) {
                                  if (signupController
                                      .profileImage.isNotEmpty) {
                                    signupController.signUp();
                                  } else {
                                    appSnackbar(
                                        error: true,
                                        content: 'Select profile image');
                                  }
                                }
                              }
                            },
                            height: 61.h,
                            width: double.maxFinite,
                            buttonText: AppStrings.signup,
                            buttonColor: AppColors.customerMain,
                            textColor: AppColors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 1.h,
                              width: 110.w, //Get.width * 0.30.w,
                              color: AppColors.lightBlack.withOpacity(0.5),
                            ),
                            appText(AppStrings.or_sign,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.lightBlack),
                            Container(
                              height: 1.h,
                              width: 110.w, //Get.width * 0.30.w,
                              color: AppColors.lightBlack.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              await signupController
                                  .checkGoogleLogin()
                                  .then((l) {
                                setState(() {});
                              });
                            },
                            child: Image.asset(
                              AppAssets.google_ic,
                              width: 40.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          InkWell(
                            onTap: () async {
                              await signupController
                                  .checkFacebookLogin()
                                  .then(() {
                                setState(() {});
                              });
                            },
                            child: Image.asset(
                              AppAssets.facebook_ic,
                              width: 40.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Platform.isIOS
                              ? SizedBox(
                                  width: 20.w,
                                )
                              : SizedBox(),
                          Platform.isIOS
                              ? InkWell(
                                  onTap: () async {
                                    await signupController
                                        .checkAppleLogin()
                                        .then(() {
                                      setState(() {});
                                    });
                                  },
                                  child: Image.asset(
                                    AppAssets.apple_ic,
                                    width: 40.w,
                                    fit: BoxFit.cover,
                                  ))
                              : SizedBox(),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                              text: AppStrings.have_account,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.lightBlack,
                                  fontFamily: 'Urbanist'),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        Get.off(() => CustomerLoginScreen()),
                                  text: AppStrings.login,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800,
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
        ),
        Visibility(
          visible: signupController.loading.value,
          child: appLoader(
            loaderColor: AppColors.white,
            onWillPop: false,
          ),
        ),
      ]),
    );
  }
}
