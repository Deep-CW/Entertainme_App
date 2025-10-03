import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../main.dart';
import '../../../../models/business_model/login_model.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/app_snackbar.dart';
import '../home/home_screen.dart';

class BusinessLoginController extends GetxController {
  RxBool loading = false.obs;
  //check box value
  RxBool check = false.obs;

  RxBool passwordVisible = true.obs;

  //editController
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginModel loginModel = LoginModel();

  @override
  void onInit() {
    bool rememberMe = box.read(AppConstants.REMEMBER_ME_BUSINESS) ?? false;

    if (rememberMe) {
      emailController = TextEditingController(
          text: box.read(AppConstants.EMAIL_ID).toString());
      passwordController = TextEditingController(
          text: box.read(AppConstants.PASSWORD).toString());
      check.value = rememberMe;
    }

    super.onInit();
  }

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

  //login call
  login() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        if (Platform.isAndroid) {
          await FirebaseMessaging.instance.getToken().then((value) async {
            String? token = value;
            box.write(AppConstants.FCM_TOKEN, token);
            print("FCM_TOKEN:${box.read(AppConstants.FCM_TOKEN).toString()}");
          });
        } else {
          await FirebaseMessaging.instance.getAPNSToken().then((value) {
            String? token = value;
            box.write(AppConstants.FCM_TOKEN, token);
            print("FCM_TOKEN:${box.read(AppConstants.FCM_TOKEN).toString()}");
          });
        }

        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };
        Map<String, dynamic> body = {
          "email": emailController.text.toString(),
          "password": passwordController.text.toString(),
        };

        await APIService.postRequest(
          url: AppUrls.BUSINESS_SIGN_IN,
          headers: headers,
          body: body,
        ).then((response) {
          var responseData = json.decode(response.body);
          print(responseData.toString());

          if (response.statusCode == 200) {
            loginModel = LoginModel.fromJson(responseData);
            saveDetail(loginModel);
            appSnackbar(content: "Login SuccessFull");
          } else {
            appSnackbar(content: responseData["message"], error: true);
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

  //save Detail
  saveDetail(LoginModel loginModel) {
    box.write(AppConstants.EMAIL_ID, emailController.text);
    box.write(AppConstants.PASSWORD, passwordController.text);
    box.write(AppConstants.TOKEN, loginModel.token.toString());
    box.write(
        AppConstants.OWNER_NAME, loginModel.ownerDetail!.ownerName.toString());
    box.write(AppConstants.PROFILE_IMG,
        "${AppUrls.BASE_API}${loginModel.ownerDetail!.ownerImg.toString()}");
    box.write(AppConstants.COUNTRY_CODE,
        loginModel.ownerDetail!.countryCode.toString());
    box.write(AppConstants.BUSINESS_OWNER_ID,
        loginModel.ownerDetail!.ownerId.toString());
    box.write(AppConstants.PHONE_NUMBER,
        loginModel.ownerDetail!.phoneNumber.toString());
    box.write(
        AppConstants.EMAIL_ID, loginModel.ownerDetail!.ownerEmail.toString());
    box.write(AppConstants.REMEMBER_ME_BUSINESS, check.value);
    box.write(AppConstants.SHOW_NOTIFICATION,
        loginModel.ownerDetail?.deviceToken.toString() != 'null');
    box.write(AppConstants.IS_NETWORK_IMG, true);
    box.write(AppConstants.IS_LOGIN, true);
    box.write(AppConstants.IS_USER, false);

    Get.off(() => const HomeScreen());

    emailController.clear();
    passwordController.clear();
  }
}
