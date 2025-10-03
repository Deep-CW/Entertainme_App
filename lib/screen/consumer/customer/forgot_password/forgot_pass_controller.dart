import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/app_snackbar.dart';
import '../login/customer_login_screen.dart';
import 'otp_screen.dart';
import 'reset_password_screen.dart';

class ForgotPassController extends GetxController {
  RxBool loading = false.obs;
  RxBool visiblePassword = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //email validation
  String? emailValidation() {
    String email = emailController.text.trim();

    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email)) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Email',
      );
      return '';
    }

    return null;
  }

  //otp validation
  String? otpValidation() {
    String otp = otpController.text.trim();

    if (otp.isEmpty || otp.length != 6) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid OTP',
      );
      return '';
    }

    return null;
  }

  //password validation
  String? passwordValidation() {
    String password = passwordController.text.trim();

    if (password.isEmpty ||
        !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(password)) {
      appSnackbar(
        error: true,
        content:
            'Password length should be minimum 8 with uppercase, lowercase, number, and special character.',
      );
      return '';
    }

    return null;
  }

  //forgot password
  forgotPassword() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };
        Map<String, dynamic> body = {
          'email': emailController.text.toString(),
        };

        await APIService.postRequest(
                url: AppUrls.USER_FORGOT_PASSWORD, headers: headers, body: body)
            .then((response) async {
          var responseData = await jsonDecode(response.body);
          print(responseData.toString());

          if (responseData['error'] == null) {
            appSnackbar(
              content: responseData.toString(),
            );
            Get.to(() => const OTPScreen());
          } else {
            appSnackbar(
              error: true,
              content: responseData['error'],
            );
          }
        });
      } else {
        appSnackbar(
          error: true,
          content: AppStrings.no_internet,
        );
      }
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }

    loading.value = false;
  }

  //verify otp
  verifyOTP() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };
        Map<String, dynamic> body = {
          'email': emailController.text.toString(),
          'otp': otpController.text.trim(),
        };

        await APIService.postRequest(
                url: AppUrls.USER_VERIFY_OTP, headers: headers, body: body)
            .then((response) async {
          var responseData = await jsonDecode(response.body);

          if (responseData['error'] == null) {
            Get.to(() => const ResetPasswordScreen());
          } else {
            appSnackbar(
              error: true,
              content: responseData['error'],
            );
          }
        });
      } else {
        appSnackbar(
          error: true,
          content: AppStrings.no_internet,
        );
      }
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }

    loading.value = false;
  }

  //reset password
  resetPassword() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };
        Map<String, dynamic> body = {
          'email': emailController.text.toString(),
          'new_password': passwordController.text.trim(),
        };

        await APIService.postRequest(
                url: AppUrls.USER_RESET_PASSWORD, headers: headers, body: body)
            .then((response) async {
          var responseData = await jsonDecode(response.body);

          if (responseData['error'] == null) {
            appSnackbar(
              content: 'Password reset successfully',
            );
            Get.offAll(() => const CustomerLoginScreen());
          } else {
            appSnackbar(
              error: true,
              content: responseData['error'],
            );
          }
        });
      } else {
        appSnackbar(
          error: true,
          content: AppStrings.no_internet,
        );
      }
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }

    loading.value = false;
  }
}
