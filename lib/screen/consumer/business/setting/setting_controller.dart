// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../constant/app_constants.dart';
import '../../../../../constant/app_urls.dart';
import '../../../../../main.dart';
import '../../../../../services/login_service.dart';
import '../../../../../widgets/app_snackbar.dart';
import '../../../../constant/app_strings.dart';
import '../../../../services/api_service.dart';
import '../../consumer_screen.dart';

class SettingController extends GetxController {
  RxBool loading = false.obs;
  RxBool notification = false.obs;
  RxBool visibleCurrentPassword = true.obs;
  RxBool visibleNewPassword = true.obs;
  RxBool visibleConfirmPassword = true.obs;

  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? subscription;

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
          "user_id": box.read(AppConstants.BUSINESS_OWNER_ID).toString(),
          "user_type": 'business_owner',
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
    try {
      Uri termConditionUri = Uri.parse(AppUrls.termAndCondition);
      launchUrl(termConditionUri);
    } catch (e) {
      appSnackbar(content: 'Not Open Term And Condition', error: true);
    }
  }

  //privacy
  privacy() async {
    try {
      Uri privacyUri = Uri.parse(AppUrls.privacy);
      launchUrl(privacyUri);
    } catch (e) {
      appSnackbar(content: 'Not Open Privacy', error: true);
    }
  }

  //aboutus
  aboutUs() async {
    try {
      Uri privacyUri = Uri.parse(AppUrls.aboutUS);
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
          "user_id": box.read(AppConstants.BUSINESS_OWNER_ID).toString(),
          "old_pass": currentPasswordController.text.toString(),
          "new_pass": confirmPasswordController.text.toString(),
        };

        await APIService.postRequest(
                url: AppUrls.BUSINESS_CHANGE_PASSWORD,
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

    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  //add purchase listner
  purchaseUpdate() async {
    final purchaseStream = inAppPurchase.purchaseStream;

    subscription = purchaseStream.listen((purchaseDetailsList) async {
      await listenToPurchaseUpdate(purchaseDetailsList);
    });
  }

  //listner of purchase update
  listenToPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    purchaseDetailsList.forEach((purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.error) {
        loading.value = false;
        appSnackbar(
          error: true,
          content: purchaseDetails.error!.message.toString(),
        );
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        loading.value = false;
        appSnackbar(
          error: true,
          content: 'Purchase cancelled',
        );
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        await inAppPurchase.completePurchase(purchaseDetails);

        if (loading.value) {
          Get.back();
        }
        loading.value = false;
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        loading.value = false;
        appSnackbar(content: "Purchase restored");
      }
    });
  }

  //restore purchase
  restorePurchase() async {
    if (APIService.internet) {
      // Restore purchases
      await inAppPurchase.isAvailable();
      await inAppPurchase.restorePurchases(applicationUserName: null);
      purchaseUpdate();
    } else {
      appSnackbar(
        error: true,
        content: AppStrings.no_internet,
      );
    }
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
          url: AppUrls.BUSINESS_LOGOUT,
          headers: headers,
        ).then((response) async {
          var responseData = await jsonDecode(await response.body);

          if (responseData['message'] == 'Logout successful.') {
            await LoginService.signOut();
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
  deleteOwner() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        // await APIService.delRequest(
        //   url: AppUrls.BUSINESS_DELETE + box.read(AppConstants.BUSINESS_OWNER_ID),
        // ).then((response) async {
        //   var responseData = await jsonDecode(response);

        //   if (responseData['message'] == 'Record was deleted successfully!') {
        box.remove(AppConstants.REMEMBER_ME_USER);
        await LoginService.signOut();
        appSnackbar(
          content: 'Account deleted successfully!',
        );
        Get.offAll(() => const ConsumerScreen());
        //   } else {
        //     appSnackbar(
        //       error: true,
        //       content: responseData['message'],
        //     );
        //   }
        // });

        // loading.value = false;
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
}
