// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../main.dart';
import '../../../../models/customer_model/customer_login_model.dart';
import '../../../../models/customer_model/customer_signup_model.dart';
import '../../../../services/api_service.dart';
import '../../../../services/login_service.dart';
import '../../../../widgets/app_snackbar.dart';
import '../location_permission_screen.dart';

import 'package:http/http.dart' as http;

class CustomerLoginController extends GetxController {
  RxBool loading = false.obs;
  //check box value
  RxBool check = false.obs;
  RxBool visiblePassword = true.obs;
  String? token;
  //editController
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  CustomerLoginModel customerLoginModel = CustomerLoginModel();
  CustomerSignUpModel customerSignUpModel = CustomerSignUpModel();

  @override
  void onInit() {
    bool rememberMe = box.read(AppConstants.REMEMBER_ME_USER) ?? false;

    if (Platform.isAndroid) {
      FirebaseMessaging.instance.getToken().then((value) {
        token = value;
        box.write(AppConstants.FCM_TOKEN, token);
      });
    } else {
      FirebaseMessaging.instance.getAPNSToken().then((value) {
        token = value;
        box.write(AppConstants.FCM_TOKEN, token);
      });
    }

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

  //check google login
  checkGoogleLogin() async {
    loading.value = true;

    if (APIService.internet) {
      await LoginService.signOut();
      UserCredential? userCredential = await LoginService.googleLogin();

      if (userCredential != null) {
        try {
          var multipartFile;
          final response =
              await http.get(Uri.parse(userCredential.user!.photoURL!));

          if (response.statusCode == 200) {
            // Step 2: Convert the image bytes to a File object
            final bytes = response.bodyBytes;
            //  final filename = basename(imageUrl); // Get the file name from the URL
            final tempDir = Directory.systemTemp; // Use temporary directory
            final file = File('${tempDir.path}/profile.png');

            // Step 3: Write the downloaded image bytes to the file
            await file.writeAsBytes(bytes);
            var mime = lookupMimeType(file.path.toString())!.split("/");
            multipartFile = await http.MultipartFile.fromPath(
              'user_img',
              file.path.toString(),
              contentType: MediaType(mime[0], mime[1]),
            );
          }

          Map<String, String> body = {
            "user_name": userCredential.user?.displayName ?? '',
            "user_email": userCredential.user?.email ?? '',
            "country_code": null.toString(),
            "phone_number": null.toString(),
            "password": null.toString(),
            "user_type": '3',
            "device_token": token.toString()
          };

          await APIService.uploadDataImage(
            reqType: "POST",
            url: AppUrls.CUSTOMER_SIGN_UP,
            multipartFile: multipartFile,
            body: body,
          ).then((response) async {
            var responseData = await json.decode(await response.body);

            if (response.statusCode == 201) {
              customerSignUpModel = CustomerSignUpModel.fromJson(responseData);
              saveSocialLoginDetails(customerSignUpModel);
              appSnackbar(content: responseData["message"]);
            } else {
              await userCredential.user?.delete();
              appSnackbar(
                error: true,
                content: responseData["message"],
              );
            }
          });
        } catch (error) {
          appSnackbar(
            error: true,
            content: error.toString(),
          );
        }
      }
    } else {
      appSnackbar(
        error: true,
        content: AppStrings.no_internet,
      );
    }

    loading.value = false;
  }

  //check facebook login
  checkFacebookLogin() async {
    loading.value = true;

    if (APIService.internet) {
      await LoginService.signOut();
      UserCredential? userCredential = await LoginService.facebookLogin();

      if (userCredential != null) {
        try {
          var multipartFile;
          final response =
              await http.get(Uri.parse(userCredential.user!.photoURL!));

          if (response.statusCode == 200) {
            // Step 2: Convert the image bytes to a File object
            final bytes = response.bodyBytes;
            //  final filename = basename(imageUrl); // Get the file name from the URL
            final tempDir = Directory.systemTemp; // Use temporary directory
            final file = File('${tempDir.path}/profile.png');

            // Step 3: Write the downloaded image bytes to the file
            await file.writeAsBytes(bytes);
            var mime = lookupMimeType(file.path.toString())!.split("/");
            multipartFile = await http.MultipartFile.fromPath(
              'user_img',
              file.path.toString(),
              contentType: MediaType(mime[0], mime[1]),
            );
          }

          Map<String, String> body = {
            "user_name": userCredential.user?.displayName ?? '',
            "user_email": userCredential.user?.email ?? '',
            "country_code": null.toString(),
            "phone_number": null.toString(),
            "password": null.toString(),
            "user_type": '2',
            "device_token": box.read(AppConstants.FCM_TOKEN).toString()
          };

          await APIService.uploadDataImage(
            reqType: "POST",
            url: AppUrls.CUSTOMER_SIGN_UP,
            multipartFile: multipartFile,
            body: body,
          ).then((response) async {
            var responseData = await json.decode(await response.body);

            if (response.statusCode == 201) {
              customerSignUpModel = CustomerSignUpModel.fromJson(responseData);
              saveSocialLoginDetails(customerSignUpModel);
              appSnackbar(content: responseData["message"]);
            } else {
              await userCredential.user?.delete();
              appSnackbar(
                error: true,
                content: responseData["message"],
              );
            }
          });
        } catch (error) {
          appSnackbar(
            error: true,
            content: error.toString(),
          );
        }
      }
    } else {
      appSnackbar(
        error: true,
        content: AppStrings.no_internet,
      );
    }

    loading.value = false;
  }

  //check apple login
  checkAppleLogin() async {
    loading.value = true;

    if (APIService.internet) {
      await LoginService.signOut();
      AuthorizationCredentialAppleID? userCredential =
          await LoginService.appleLogin();

      if (userCredential != null) {
        try {
          var multipartFile;

          // Step 2: Convert the image bytes to a File object
          // final bytes = response.bodyBytes;
          //  final filename = basename(imageUrl); // Get the file name from the URL
          // final tempDir = Directory.systemTemp; // Use temporary directory
          final file = File(AppAssets.user_img);

          // Step 3: Write the downloaded image bytes to the file
          // await file.writeAsBytes(bytes);
          var mime = lookupMimeType(file.path.toString())!.split("/");
          multipartFile = await http.MultipartFile.fromPath(
            'user_img',
            file.path.toString(),
            contentType: MediaType(mime[0], mime[1]),
          );

          Map<String, String> body = {
            "user_name": userCredential.givenName ?? '',
            "user_email": userCredential.email ?? '',
            "country_code": null.toString(),
            "phone_number": null.toString(),
            "password": null.toString(),
            "user_type": '4',
            "device_token": box.read(AppConstants.FCM_TOKEN).toString()
          };

          await APIService.uploadDataImage(
            reqType: "POST",
            url: AppUrls.CUSTOMER_SIGN_UP,
            multipartFile: multipartFile,
            body: body,
          ).then((response) async {
            var responseData = await json.decode(await response.body);

            if (response.statusCode == 201) {
              customerSignUpModel = CustomerSignUpModel.fromJson(responseData);
              saveSocialLoginDetails(customerSignUpModel);
              appSnackbar(content: responseData["message"]);
            } else {
              // await userCredential.user?.delete();
              appSnackbar(
                error: true,
                content: responseData["message"],
              );
            }
          });
        } catch (error) {
          appSnackbar(
            error: true,
            content: error.toString(),
          );
        }
      }
    } else {
      appSnackbar(
        error: true,
        content: AppStrings.no_internet,
      );
    }

    loading.value = false;
  }

  //customer login
  login() async {
    loading.value = true;

    if (APIService.internet) {
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      Map<String, dynamic> body = {
        "email": emailController.text.toString(),
        "password": passwordController.text.toString(),
      };

      await APIService.postRequest(
        url: AppUrls.CUSTOMER_SIGN_IN,
        headers: headers,
        body: body,
      ).then((response) {
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print(responseData.toString());

          customerLoginModel = CustomerLoginModel.fromJson(responseData);
          saveDetail(customerLoginModel);
          appSnackbar(content: "Login SuccessFull");
        } else {
          var responseData = json.decode(response.body);
          appSnackbar(content: responseData["message"], error: true);
        }
      });
    } else {
      appSnackbar(
        error: true,
        content: AppStrings.no_internet,
      );
    }

    loading.value = false;
  }

  //save Detail
  saveDetail(CustomerLoginModel customerLoginModel) {
    box.write(AppConstants.TOKEN, customerLoginModel.token.toString());
    box.write(AppConstants.EMAIL_ID,
        customerLoginModel.userDetail!.userEmail.toString());
    box.write(AppConstants.PASSWORD, passwordController.text.toString());
    box.write(AppConstants.PROFILE_IMG,
        customerLoginModel.userDetail!.userImg.toString());
    box.write(AppConstants.USER_NAME,
        customerLoginModel.userDetail!.userName.toString());
    box.write(AppConstants.EMAIL_ID,
        customerLoginModel.userDetail!.userEmail.toString());
    box.write(AppConstants.COUNTRY_CODE,
        customerLoginModel.userDetail!.countryCode.toString());
    box.write(AppConstants.PHONE_NUMBER,
        customerLoginModel.userDetail!.phoneNumber.toString());
    box.write(
        AppConstants.USER_ID, customerLoginModel.userDetail!.userId.toString());
    box.write(AppConstants.USER_TYPE,
        customerLoginModel.userDetail!.userType.toString());
    box.write(AppConstants.REMEMBER_ME_USER, check.value);
    box.write(AppConstants.SHOW_NOTIFICATION,
        customerLoginModel.userDetail?.deviceToken.toString() != 'null');
    box.write(AppConstants.IS_NETWORK_IMG, true);
    box.write(AppConstants.IS_LOGIN, true);
    box.write(AppConstants.IS_USER, true);
    box.write(AppConstants.SOCIAL_LOGIN, false);

    Get.offAll(() => const LocationPermissionScreen());

    emailController.clear();
    passwordController.clear();
  }

  //save social login Details
  saveSocialLoginDetails(CustomerSignUpModel customerSignUpModel) {
    loading.value = true;

    box.write(AppConstants.TOKEN, customerSignUpModel.token.toString());
    box.write(AppConstants.PROFILE_IMG,
        customerSignUpModel.userDetail!.userImg.toString());
    box.write(AppConstants.USER_NAME,
        customerSignUpModel.userDetail!.userName.toString());
    box.write(AppConstants.EMAIL_ID,
        customerSignUpModel.userDetail!.userEmail.toString());
    box.write(AppConstants.PHONE_NUMBER,
        customerSignUpModel.userDetail!.phoneNumber ?? '');
    // box.write(AppConstants.COUNTRY_FLAG, countryFlag.value.toString());
    box.write(AppConstants.COUNTRY_CODE,
        customerSignUpModel.userDetail!.countryCode ?? '');
    box.write(AppConstants.PASSWORD, '');
    // box.write(AppConstants.COUNTRY_NAME, countryName.value);
    box.write(AppConstants.USER_ID,
        customerSignUpModel.userDetail!.userId.toString());
    box.write(AppConstants.SHOW_NOTIFICATION,
        customerSignUpModel.userDetail?.deviceToken.toString() != 'null');
    box.write(AppConstants.USER_TYPE, customerSignUpModel.userDetail!.userType);
    box.write(AppConstants.IS_NETWORK_IMG, true);
    box.write(AppConstants.IS_LOGIN, true);
    box.write(AppConstants.IS_USER, true);
    box.write(AppConstants.SOCIAL_LOGIN, true);

    Get.offAll(() => const LocationPermissionScreen());

    emailController.clear();
    passwordController.clear();
  }
}
