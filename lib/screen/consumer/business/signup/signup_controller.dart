// ignore_for_file: await_only_futures

import 'dart:convert';

import 'package:country_calling_code_picker/picker.dart';

import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../helper/phone_input_formattor/flutter_multi_formatter.dart';
import '../../../../main.dart';
import '../../../../models/business_model/register_model.dart';
import '../../../../models/customer_model/get_category_model.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/app_snackbar.dart';

import '../login/login_screen.dart';
import 'second_signup_screen.dart';

class SignupController extends GetxController {
  RxBool loading = false.obs;

  RxBool visiblePassword = true.obs;
  RxBool visibleLocationSheet = false.obs;

  RxString profileImage = ''.obs;
  RxString selectImage = ''.obs;
  List<RxString> businessImages =
      List<RxString>.generate(6, (int index) => ''.obs);

  var selectedCountry = "".obs;
  List<RxBool> check = List<RxBool>.generate(7, (int index) => false.obs);

  RxString countryFlag = "flags/usa.png".obs;
  RxString countryName = "us".obs;

  String selectlengthPhone = "";
  String lengthPhone = "";
  var countryCode = "".obs;
  var selectedCountryCode = "+1".obs;
  RxString phoneNumber = ''.obs;
  double lat = 0.0;
  double lng = 0.0;

  RxList<GetCategory> categories = <GetCategory>[].obs;
  RxList<Map<String, dynamic>> categoryNames = <Map<String, dynamic>>[].obs;

  List<Map<String, String>> openHours = [];

  Map<String, String> monday = {};
  Map<String, String> thusday = {};
  Map<String, String> wednesday = {};
  Map<String, String> thrusday = {};
  Map<String, String> friday = {};
  Map<String, String> satday = {};
  Map<String, String> sunday = {};
  Map<String, String> openDay = {};

  var mon = '';
  var tue = '';
  var wed = '';
  var thu = '';
  var fri = '';
  var sat = '';
  var sun = '';

  List<RxString> openTime = [
    '11:00'.obs,
    '11:00'.obs,
    '11:00'.obs,
    '11:00'.obs,
    '11:00'.obs,
    '11:00'.obs,
    '11:00'.obs,
  ];
  List<RxString> closeTime = [
    '8:00'.obs,
    '8:00'.obs,
    '8:00'.obs,
    '8:00'.obs,
    '8:00'.obs,
    '8:00'.obs,
    '8:00'.obs,
  ];

  late PhoneCountryData initialCountryData;
  late PhoneInputFormatter phoneInputFormatter;

  RxString businessCategory = "".obs;
  RxString businessCategoryName = "".obs;
  RxString businessCategoryID = "".obs;

  //editController
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController businessnameController = TextEditingController();
  TextEditingController businesslocationController = TextEditingController();
  TextEditingController ownernameController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  ScrollController chipsScrollController = ScrollController();

  RegisterModel registerModel = RegisterModel();

  @override
  void onInit() {
    super.onInit();

    getCategory();
  }

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

  //businessname validation
  String? businessNameValidation() {
    String business = businessnameController.text.trim();

    if (business.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Business Name',
      );
      return '';
    }

    return null;
  }

  //businesslocation validation
  String? businessLocationValidation() {
    String businessLocation = businesslocationController.text.trim();

    if (businessLocation.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Business Location',
      );
      return '';
    }

    return null;
  }

  //ownername validation
  String? ownerNameValidation() {
    String name = ownernameController.text.trim();

    if (name.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Owner Name',
      );
      return '';
    }

    return null;
  }

  //detail validation
  String? detailValidation() {
    String detail = detailController.text.trim();

    if (detail.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Detail of Business',
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

  //businessDetail validation
  String? businessDetailValidation() {
    String businessDetail = detailController.text.trim();

    if (businessDetail.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Business Detail',
      );
      return '';
    }

    return null;
  }

  //businessCategory validation
  bool businessCategoryValidation() {
    if (businessCategory.value.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Select Business Category.',
      );
      return false;
    }

    return true;
  }

  //businessProfileImage validation
  String? businessProfileImageValidation() {
    if (profileImage.value.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Select Profile Image.',
      );
      return '';
    }

    return null;
  }

  //businessOutletImage validation
  bool businessOutletImageValidation() {
    for (var image in businessImages) {
      if (image.toString() == '' || image.isEmpty) {
        appSnackbar(
          error: true,
          content: 'Please Select Outlet Image.',
        );
        return false;
      }
    }
    return true;
  }

  //openHour validation
  bool openHourValidation() {
    if (check.every((element) => element.value == true)) {
      appSnackbar(
        error: true,
        content: 'Please Select Opening Hours.',
      );
      return false;
    }
    return true;
  }

  //get categories
  getCategory() async {
    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        await APIService.getRequest(
          url: AppUrls.GET_CATEGORIES,
          headers: headers,
        ).then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData is List) {
            if (response != '[]') {
              categories.addAll(List<GetCategory>.from(
                  json.decode(response).map((x) => GetCategory.fromJson(x))));

              categories.forEach((element) {
                categoryNames.add({
                  "name": element.catName.toString(),
                  "id": element.catId.toString()
                });
              });
            } else {
              appSnackbar(
                error: true,
                content: "No Category Found.",
              );
            }
          } else {
            appSnackbar(
              error: true,
              content: "Failed To Get Category.",
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

  //register
  signUp() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        var multipartFile;
        var multipart = <http.MultipartFile>[];
        var mime = lookupMimeType(profileImage.value.toString())!.split("/");
        multipartFile = await http.MultipartFile.fromPath(
          'owner_img',
          profileImage.value.toString(),
          contentType: MediaType(mime[0], mime[1]),
        );

        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };
        Map<String, String> body = {
          "owner_name": ownernameController.text.toString(),
          "owner_email": emailController.text.toString(),
          "country_code": countryCode.value.toString(),
          "phone_number": phoneController.text.toString(),
          "password": passwordController.text.toString(),
          "business_name": businessnameController.text.toString(),
          "business_location": businesslocationController.text.toString(),
          "business_category": businessCategory.value.toString(),
          "business_detail": detailController.text.toString(),
          "opening_hours_1": mon,
          "opening_hours_2": tue,
          "opening_hours_3": wed,
          "opening_hours_4": thu,
          "opening_hours_5": fri,
          "opening_hours_6": sat,
          "opening_hours_7": sun,
          "user_type": "1",
          "longitude": lng.toString(),
          "latitude": lat.toString(),
          "device_token": null.toString(),
        };

        for (var i = 0; i < businessImages.length; i++) {
          var mimeType =
              await lookupMimeType(businessImages[i].value)?.split("/");
          var multipartFile = await http.MultipartFile.fromPath(
            "business_images",
            businessImages[i].value,
            contentType: MediaType(mimeType![0], mimeType[1]),
          );
          multipart.add(multipartFile);
        }

        await APIService.uploadDataImage(
                reqType: "POST",
                url: AppUrls.BUSINESS_SIGN_UP,
                headers: headers,
                multipartFile: multipartFile,
                body: body,
                multipartFiles: multipart)
            .then((response) async {
          if (response.statusCode == 200) {
            registerModel = RegisterModel.fromJson(json.decode(response.body));

            saveDetail();
            appSnackbar(content: "SignUp SuccessFull");
          } else {
            appSnackbar(content: "SignUp Error", error: true);
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

  void addValueToMap<K, V>(Map<K, String> map, K key, V value) =>
      map.update(key, (existingValue) => '$existingValue,$value',
          ifAbsent: () => '$value');

  goToNext() {
    Get.to(() => const SecondSignupScreen());
  }

  //save Detail
  saveDetail() async {
    loading.value = true;

    box.write(AppConstants.PROFILE_IMG,
        "${AppUrls.BASE_API}${profileImage.value.toString()}");

    box.write(AppConstants.EMAIL_ID, emailController.text.toString());
    box.write(AppConstants.PHONE_NUMBER, phoneController.text.toString());
    box.write(AppConstants.COUNTRY_FLAG, countryFlag.value.toString());
    box.write(AppConstants.COUNTRY_CODE, countryCode.value.toString());
    box.write(AppConstants.PASSWORD, passwordController.text.toString());
    box.write(AppConstants.COUNTRY_NAME, countryName.value);
    box.write(AppConstants.BUSINESS_LOCATION,
        businesslocationController.text.toString());
    box.write(AppConstants.OWNER_NAME, ownernameController.text.toString());
    box.write(
        AppConstants.BUSINESS_NAME, businessnameController.text.toString());

    box.write(AppConstants.BUSINESS_DETAIL, detailController.text.toString());

    box.write(AppConstants.OPENING_HOURS_MON, mon);
    box.write(AppConstants.OPENING_HOURS_TUE, tue);
    box.write(AppConstants.OPENING_HOURS_WED, wed);
    box.write(AppConstants.OPENING_HOURS_THU, thu);
    box.write(AppConstants.OPENING_HOURS_FRI, fri);
    box.write(AppConstants.OPENING_HOURS_SAT, sat);
    box.write(AppConstants.OPENING_HOURS_SUN, sun);

    List<String> outletImages =
        businessImages.map((value) => value.value).toList();
    box.write(AppConstants.OUTLET_IMAGES, outletImages);

    box.write(
        AppConstants.BUSINESS_CATEGORY, businessCategory.value.toString());

    List<String> openingTime = openTime.map((value) => value.value).toList();
    box.write(AppConstants.OPEN_TIME, openingTime);

    List<String> closeingTime = closeTime.map((value) => value.value).toList();
    box.write(AppConstants.CLOSE_TIME, closeingTime);
    box.write(AppConstants.IS_USER, false);
    loading.value = false;
    Get.offAll(() => const LoginScreen());

    profileImage.value = '';
    usernameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    businessnameController.clear();
    businesslocationController.clear();
    ownernameController.clear();
    detailController.clear();
  }

  void setCountry(BuildContext context) async {
    var country = await getDefaultCountry(context);
    selectedCountry.value = "${country.countryCode} ${country.callingCode}";
    selectedCountryCode.value = country.callingCode;
  }
}
