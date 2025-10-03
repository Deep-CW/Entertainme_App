import 'dart:convert';
import 'dart:io';

import 'package:country_calling_code_picker/picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../helper/phone_input_formattor/flutter_multi_formatter.dart';
import '../../../../main.dart';
import '../../../../models/customer_model/customer_edit_profile_model.dart';
import '../../../../models/customer_model/customer_profile_model.dart';
import '../../../../services/api_service.dart';
import '../../../../services/login_service.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../consumer_screen.dart';
import '../dashboard/dashboard_controller.dart';

import 'package:http/http.dart' as http;

import '../home/home_controller.dart';

class ProfileController extends GetxController {
  RxBool loading = false.obs;
  RxString countryFlag = "".obs;
  RxString profileImage = ''.obs;
  RxBool visiblePassword = true.obs;
  RxString countryName = "".obs;

  //---------------------------------------
  var selectedCountry = "".obs;
  String selectlengthPhone = "";
  String lengthPhone = "";
  var selectedCountryCode = "+1".obs;
  RxString phoneNumber = ''.obs;
  late PhoneCountryData initialCountryData;
  late PhoneInputFormatter phoneInputFormatter;

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController =
      TextEditingController(text: box.read(AppConstants.PASSWORD).toString());
  TextEditingController usernameController = TextEditingController();

  CustomerProfileModel customerProfileModel = CustomerProfileModel();
  CustomerEditProfileModel customerEditProfileModel =
      CustomerEditProfileModel();
  final dashboaedController = Get.put(DashBoardController());

  @override
  void onInit() {
    super.onInit();

    getProfileDetail();

    countryFlag.value = box.read(AppConstants.COUNTRY_FLAG) ?? "flags/usa.png";

    profileImage.value =
        "${AppUrls.BASE_API}${box.read(AppConstants.PROFILE_IMG)}";

    countryName.value = box.read(AppConstants.COUNTRY_NAME).toString();
  }

  phoneNumberFormat(BuildContext context) {
    phoneNumber = "".obs;

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

  getCountryFlagFromCode(BuildContext context, String callingCode) async {
    try {
      var country = await getCountryByCallingCode(context, callingCode);

      countryFlag.value = country!.flag;
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<Country?> getCountryByCallingCode(
      BuildContext context, String countryCode) async {
    final list = await getCountries(context);
    return list.firstWhere((element) => element.callingCode == countryCode);
  }

  //get Profile Detail
  getProfileDetail() async {
    dashboaedController.loading.value = true;
    loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'accept': 'application/json',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
          'content-type': 'application/json',
        };

        await APIService.getRequest(
                url: AppUrls.CUSTOMER_PROFILE_DETAIL, headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData["message"] != AppStrings.invalid_token) {
            if (response != null) {
              customerProfileModel =
                  CustomerProfileModel.fromJson(responseData);
              getDetail(customerProfileModel);
            } else {
              appSnackbar(
                error: true,
                content: "Error while getting profile data",
              );
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

    dashboaedController.loading.value = false;
    loading.value = false;
  }

  //edit profile
  editProfile() async {
    loading.value = true;
    dashboaedController.loading.value = true;

    try {
      if (APIService.internet) {
        var multipartFile;
        if (box.read(AppConstants.IS_NETWORK_IMG) == false) {
          var mime = lookupMimeType(profileImage.value.toString())!.split("/");
          multipartFile = await http.MultipartFile.fromPath(
            'user_img',
            profileImage.value.toString(),
            contentType: MediaType(mime[0], mime[1]),
          );
        } else {
          var mime = lookupMimeType(profileImage.value.toString())!.split("/");
          final response =
              await http.get(Uri.parse(profileImage.value.toString()));

          final directory = await getApplicationDocumentsDirectory();

          final file = File(
              '${directory.path}/${profileImage.split('/').last.toString()}');
          await file.writeAsBytes(response.bodyBytes);
          multipartFile = http.MultipartFile.fromBytes(
              'user_img', // key
              response.bodyBytes, // value
              filename: profileImage.split('/').last.toString(), // filename
              contentType: MediaType(
                mime[0], mime[1], // content type
              ));
        }
        Map<String, String> headers = {
          'accept': 'application/json',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
          'content-type': 'application/json',
        };

        Map<String, String> body = {
          "user_id": box.read(AppConstants.USER_ID).toString(),
          "user_img": profileImage.value.toString(),
          "user_name": usernameController.text.toString()
        };

        await APIService.uploadDataImage(
          reqType: "POST",
          url: AppUrls.CUSTOMER_EDIT_PROFILE,
          multipartFile: multipartFile,
          headers: headers,
          body: body,
        ).then((response) async {
          var responseData = await jsonDecode(await response.body);

          if (responseData["message"] != AppStrings.invalid_token) {
            if (response != null) {
              customerEditProfileModel =
                  CustomerEditProfileModel.fromJson(responseData);

              saveDetail(customerEditProfileModel);
            } else {
              appSnackbar(content: "Get Profile Data Error", error: true);
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

    dashboaedController.loading.value = true;
    loading.value = false;
  }

  //get detail
  getDetail(CustomerProfileModel customerProfileModel) {
    box.write(AppConstants.IS_NETWORK_IMG, true);
    profileImage.value =
        "${AppUrls.BASE_API}${customerProfileModel.user!.userImg.toString()}";
    usernameController = TextEditingController(
        text: customerProfileModel.user!.userName.toString());
    emailController = TextEditingController(
        text: customerProfileModel.user!.userEmail.toString());
    phoneController = TextEditingController(
        text: customerProfileModel.user!.phoneNumber == 'null'
            ? ''
            : customerProfileModel.user!.phoneNumber);
    passwordController =
        TextEditingController(text: box.read(AppConstants.PASSWORD).toString());
  }

  //save Detail
  saveDetail(CustomerEditProfileModel customerEditProfileModel) {
    loading.value = true;
    box.write(AppConstants.PROFILE_IMG,
        customerEditProfileModel.user!.userImg.toString());
    box.write(AppConstants.USER_NAME,
        customerEditProfileModel.user!.userName.toString());
    box.write(AppConstants.EMAIL_ID, emailController.text);
    box.write(AppConstants.PHONE_NUMBER, phoneController.text);
    box.write(AppConstants.COUNTRY_FLAG, countryFlag.value);
    box.write(AppConstants.PASSWORD, passwordController.text);
    box.write(AppConstants.COUNTRY_NAME, countryName.value);

    loading.value = false;
    Get.back();
    Get.find<HomeController>().userName.value =
        customerEditProfileModel.user!.userName.toString();
    Get.find<HomeController>().profileImage.value =
        "${AppUrls.BASE_API}${customerEditProfileModel.user!.userImg.toString()}";
  }

  void setCountry(BuildContext context) async {
    var country = await getDefaultCountry(context);
    selectedCountry.value = "${country.countryCode} ${country.callingCode}";
    selectedCountryCode.value = country.callingCode;
  }

  //logout
  logoutCall() {
    dashboaedController.loading.value = true;
    Future.delayed(const Duration(seconds: 3), () async {
      await LoginService.signOut();
      dashboaedController.loading.value = false;
      Get.offAll(() => const ConsumerScreen());
    });
  }
}
