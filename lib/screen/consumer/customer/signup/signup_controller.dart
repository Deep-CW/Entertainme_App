// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:country_calling_code_picker/picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../helper/phone_input_formattor/flutter_multi_formatter.dart';
import '../../../../main.dart';

import '../../../../models/customer_model/customer_signup_model.dart';
import '../../../../services/api_service.dart';
import '../../../../services/login_service.dart';
import '../../../../widgets/app_snackbar.dart';
import '../location_permission_screen.dart';

class SignupController extends GetxController {
  RxBool loading = false.obs;
  //check box value
  RxBool check = false.obs;

  RxBool visiblePassword = true.obs;

  RxString profileImage = ''.obs;

  var selectedCountry = "".obs;
  String? token;
  RxString countryFlag = "flags/usa.png".obs;
  RxString countryName = "us".obs;
  var countryCode = "".obs;
  String selectlengthPhone = "";
  String lengthPhone = "";
  var selectedCountryCode = "+1".obs;
  RxString phoneNumber = ''.obs;
  late PhoneCountryData initialCountryData;
  late PhoneInputFormatter phoneInputFormatter;

  //editController
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  CustomerSignUpModel customerSignUpModel = CustomerSignUpModel();

  @override
  void onInit() {
    super.onInit();

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

    if (Get.arguments != null) {
      emailController.text = box.read(AppConstants.EMAIL_ID) != null
          ? box.read(AppConstants.EMAIL_ID).toString()
          : "";
      usernameController.text = box.read(AppConstants.USER_NAME) != null
          ? box.read(AppConstants.USER_NAME).toString()
          : "";
      profileImage.value = box.read(AppConstants.PROFILE_IMG) != null
          ? box.read(AppConstants.PROFILE_IMG).toString()
          : "";
    }
  }

  //for phonenumber format
  phoneNumberFormat(BuildContext context) {
    phoneNumber = "".obs;
    phoneController.text = "";
    setCountry(context);

    Map<String, dynamic> map = {
      'country': 'United States',
      'internalPhoneCode': '1',
      'countryCode': 'US',
      'phoneMask': '+0 (000) 000 0000',
    };

    initialCountryData = PhoneCountryData.fromMap(map);
    phoneInputFormatter = PhoneInputFormatter(
      allowEndlessPhone: false,
      defaultCountryCode: initialCountryData.countryCode,
    );
    selectlengthPhone = initialCountryData.phoneMaskWithoutCountryCode
        .replaceAll('(', '')
        .replaceAll(" ", '')
        .replaceAll(")", '')
        .replaceAll("-", '')
        .toString();
    countryCode.value = initialCountryData.phoneCode.toString();
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
            print(responseData.toString());

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
            print(responseData.toString());

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

  //username validation
  String? userNameValidation() {
    String name = usernameController.text.trim();

    if (name.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Name',
      );
      return '';
    }

    return null;
  }

  //phone number validation
  bool phoneValidation() {
    String phone = phoneController.text.trim();
    if (selectedCountryCode.isEmpty) {
      appSnackbar(error: true, content: "Please select country code!!");
      return false;
    }
    if (phone.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Phone Number',
      );
      return false;
    } else if (selectlengthPhone.length != 10) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Phone Number',
      );
      return false;
    }

    return true;
  }

  //customer signup
  signUp() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        var multipartFile;
        if (box.read(AppConstants.IS_NETWORK_IMG)) {
          final response = await http.get(Uri.parse(profileImage.value));

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
        } else {
          var mime = lookupMimeType(profileImage.value.toString())!.split("/");
          multipartFile = await http.MultipartFile.fromPath(
            'user_img',
            profileImage.value.toString(),
            contentType: MediaType(mime[0], mime[1]),
          );
        }
        Map<String, String> body = {
          "user_name": usernameController.text.toString(),
          "user_email": emailController.text.toString(),
          "country_code": countryCode.value.toString(),
          "phone_number": phoneController.text.toString(),
          "password": passwordController.text.toString(),
          "user_type": '1',
          "device_token": null.toString(),
        };

        await APIService.uploadDataImage(
          reqType: "POST",
          url: AppUrls.CUSTOMER_SIGN_UP,
          multipartFile: multipartFile,
          body: body,
        ).then((response) {
          if (response.statusCode == 200) {
            var responseData = json.decode(response.body);

            customerSignUpModel = CustomerSignUpModel.fromJson(responseData);
            saveDetail(customerSignUpModel);
            appSnackbar(content: "SignUp Successfully");
          } else {
            var responseData = json.decode(response.body);
            appSnackbar(content: responseData["error"], error: true);
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
  saveDetail(CustomerSignUpModel customerSignUpModel) {
    loading.value = true;

    box.write(AppConstants.TOKEN, customerSignUpModel.token.toString());
    box.write(AppConstants.PROFILE_IMG,
        customerSignUpModel.userDetail!.userImg.toString());
    box.write(AppConstants.USER_NAME,
        customerSignUpModel.userDetail!.userName.toString());
    box.write(AppConstants.EMAIL_ID,
        customerSignUpModel.userDetail!.userEmail.toString());
    box.write(AppConstants.PHONE_NUMBER,
        customerSignUpModel.userDetail!.phoneNumber.toString());
    box.write(AppConstants.COUNTRY_FLAG, countryFlag.value.toString());
    box.write(AppConstants.COUNTRY_CODE,
        customerSignUpModel.userDetail!.countryCode.toString());
    box.write(AppConstants.PASSWORD, passwordController.text);
    box.write(AppConstants.COUNTRY_NAME, countryName.value);
    box.write(AppConstants.USER_ID,
        customerSignUpModel.userDetail!.userId.toString());
    box.write(AppConstants.USER_TYPE,
        customerSignUpModel.userDetail!.userType.toString());
    box.write(AppConstants.SHOW_NOTIFICATION,
        customerSignUpModel.userDetail?.deviceToken.toString() != 'null');
    box.write(AppConstants.IS_NETWORK_IMG, true);
    box.write(AppConstants.IS_LOGIN, true);
    box.write(AppConstants.IS_USER, true);

    Get.offAll(() => const LocationPermissionScreen());

    profileImage.value = '';
    usernameController.clear();
    emailController.clear();
    phoneController.clear();
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

    profileImage.value = '';
    usernameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
  }

  void setCountry(BuildContext context) async {
    var country = await getDefaultCountry(context);
    selectedCountry.value = "${country.countryCode} ${country.callingCode}";
    selectedCountryCode.value = country.callingCode;
  }
}
