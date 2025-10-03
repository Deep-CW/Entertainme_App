import 'dart:io';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:country_calling_code_picker/picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_strings.dart';

import '../../../../helper/phone_input_formattor/formatters/phone_input_formatter.dart';
import '../../../../services/image_service.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_input_field.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../../../widgets/app_text.dart';
import '../location/business_location.dart';
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
    // ImageService.getPermission();
    signupController.phoneNumberFormat(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
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
                                color: AppColors.businessMain);

                            if (pickedImg != null) {
                              signupController.profileImage.value = pickedImg;
                            }
                          },
                          child: signupController.profileImage.value.isEmpty
                              ? Container(
                                  height: 78.h,
                                  width: 78.w,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
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
                                        File(signupController
                                            .profileImage.value),
                                      ),
                                    ),
                                  )),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        appInputField(
                          height: 50.h,
                          controller: signupController.ownernameController,
                          hintText: AppStrings.owner_name,
                          prefixImg: AppAssets.owner_ic,
                          showSuffix: false,
                          showPrefix: true,
                          validator: (value) {
                            return signupController.ownerNameValidation();
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
                          visiblePassword:
                              signupController.visiblePassword.value,
                          validator: (value) {
                            return signupController.passwordValidation();
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        appInputField(
                          height: 50.h,
                          controller: signupController.businessnameController,
                          hintText: AppStrings.business_name,
                          prefixImg: AppAssets.business_name_ic,
                          showSuffix: false,
                          showPrefix: true,
                          validator: (value) {
                            return signupController.businessNameValidation();
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
                                    final country =
                                        await showCountryPickerDialog(context,
                                            cornerRadius: 20.r,
                                            title: Container(
                                              width: double.maxFinite,
                                              color: Colors.white,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  appText(
                                                      AppStrings.select_country,
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors.lightBlack),
                                                  SizedBox(
                                                    width: 40.w,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0.w),
                                                    child: GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .translucent,
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      child: appText(
                                                          AppStrings.cancel,
                                                          fontSize: 12.sp,
                                                          color: AppColors
                                                              .lightBlack,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ));

                                    if (country != null) {
                                      signupController.countryFlag.value =
                                          country.flag;
                                      signupController.countryCode.value =
                                          country.callingCode
                                              .replaceAll('+', '');

                                      PhoneCodes.getAllCountryDatas()
                                          .forEach((element) {
                                        if (element.countryCode ==
                                            country.countryCode) {
                                          signupController.initialCountryData =
                                              element;

                                          signupController.selectlengthPhone =
                                              signupController
                                                  .initialCountryData
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
                                    }
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
                          controller:
                              signupController.businesslocationController,
                          hintText: AppStrings.business_location,
                          prefixImg: AppAssets.location_ic,
                          showSuffix: false,
                          showPrefix: true,
                          keyboardType: TextInputType.none,
                          validator: (value) {
                            return signupController
                                .businessLocationValidation();
                          },
                          maxLines: 1,
                          onTap: () async {
                            final locationValue =
                                await Get.to(() => const BusinessLocation());
                            if (locationValue != null) {
                              signupController.businesslocationController.text =
                                  locationValue["location"];
                              signupController.lat = locationValue["lat"];
                              signupController.lng = locationValue["lng"];
                            }
                          },
                        ),
                        SizedBox(
                          height: 25.h,
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
                                      signupController.goToNext();
                                    } else {
                                      appSnackbar(
                                          error: true,
                                          content: 'Select Profile Image.');
                                    }
                                  }
                                }
                              },
                              height: 61.h,
                              width: double.maxFinite,
                              buttonText: AppStrings.next,
                              buttonColor: AppColors.businessMain,
                              textColor: AppColors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 30.h,
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
        ],
      ),
    );
  }
}
