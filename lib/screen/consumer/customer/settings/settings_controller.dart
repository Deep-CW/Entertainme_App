import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../main.dart';
import '../../../../services/api_service.dart';
import '../../../../services/login_service.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../consumer_screen.dart';
import '../dashboard/dashboard_controller.dart';

class SettingController extends GetxController {
  RxBool loading = false.obs;
  RxBool notification = false.obs;
  RxBool socialLogin = false.obs;
  RxBool visibleCurrentPassword = true.obs;
  RxBool visibleNewPassword = true.obs;
  RxBool visibleConfirmPassword = true.obs;

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    notification.value = box.read(AppConstants.SHOW_NOTIFICATION);

    super.onInit();
  }

  //password validation
  String? passwordValidation(TextEditingController controller) {
    String password = controller.text.trim();

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

  //update notification
  updateNotification() async {
    try {
      if (APIService.internet) {
        if (box.read(AppConstants.FCM_TOKEN) == null) {
          if (Platform.isAndroid) {
            await FirebaseMessaging.instance.getToken().then((value) {
              var token = value;
              box.write(AppConstants.FCM_TOKEN, token);
            });
          } else {
            await FirebaseMessaging.instance.getAPNSToken().then((value) {
              var token = value;
              box.write(AppConstants.FCM_TOKEN, token);
            });
          }
        }

        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };
        Map<String, dynamic> body = {
          "user_id": box.read(AppConstants.USER_ID).toString(),
          "user_type": 'customer',
          "device_token": notification.value
              ? null.toString()
              : box.read(AppConstants.FCM_TOKEN),
        };

        await APIService.postRequest(
                url: AppUrls.NOTIFICATION_UPDATE, body: body, headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(response.body);

          if (response.statusCode == 200) {
            notification.toggle();
            box.write(AppConstants.SHOW_NOTIFICATION, notification.value);
          } else {
            appSnackbar(
              error: true,
              content: responseData['message'],
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
  }

  //term and condition
  termAndCondition() async {
    Uri termConditionUri = Uri.parse(AppUrls.termAndCondition);
    try {
      launchUrl(termConditionUri);
    } catch (e) {
      appSnackbar(content: 'Not Open Term And Condition', error: true);
    }
  }

  //privacy
  privacy() async {
    Uri privacyUri = Uri.parse(AppUrls.privacy);
    try {
      launchUrl(privacyUri);
    } catch (e) {
      appSnackbar(content: 'Not Open Privacy', error: true);
    }
  }

  //aboutus
  aboutUs() async {
    Uri privacyUri = Uri.parse(AppUrls.aboutUS);
    try {
      launchUrl(privacyUri);
    } catch (e) {
      appSnackbar(content: 'Not Open AboutUs', error: true);
    }
  }

  //change password
  changePassword() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };
        Map<String, dynamic> body = {
          "current_password": currentPasswordController.text.toString(),
          "new_password": newPasswordController.text.toString(),
          "confirm_password": confirmPasswordController.text.toString(),
        };

        await APIService.postRequest(
                url: AppUrls.CUSTOMER_CHANGE_PASSWORD,
                body: body,
                headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(response.body);
          if (responseData["message"] != AppStrings.invalid_token) {
            if (responseData["message"] !=
                AppStrings.incorrect_current_password) {
              saveDetail();
              appSnackbar(content: responseData["message"].toString());
            } else {
              appSnackbar(
                  content: responseData["message"].toString(), error: true);
            }
          } else {
            logoutCall();
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
  saveDetail() {
    box.write(AppConstants.PASSWORD, confirmPasswordController.text);

    Get.back();
  }

  //logout
  logoutCall() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };

        await APIService.postRequest(
          url: AppUrls.USER_LOGOUT,
          headers: headers,
        ).then((response) async {
          var responseData = await jsonDecode(await response.body);

          if (responseData['message'] == 'Logout successful.') {
            await LoginService.signOut();
            Get.delete<DashBoardController>();
            Get.offAll(() => const ConsumerScreen());
          } else {
            appSnackbar(
              error: true,
              content: responseData['message'],
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

  //delete
  deleteUser() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        await APIService.delRequest(
          url: AppUrls.USER_DELETE + box.read(AppConstants.USER_ID),
        ).then((response) async {
          var responseData = await jsonDecode(response);

          if (responseData['message'] == 'Record was deleted successfully!') {
            box.remove(AppConstants.REMEMBER_ME_USER);
            await LoginService.signOut();
            appSnackbar(
              content: 'Account deleted successfully!',
            );
            Get.delete<DashBoardController>();
            Get.offAll(() => const ConsumerScreen());
          } else {
            appSnackbar(
              error: true,
              content: responseData['message'],
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
