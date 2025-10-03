// ignore_for_file: await_only_futures, depend_on_referenced_packages, avoid_function_literals_in_foreach_calls, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:country_calling_code_picker/picker.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../helper/phone_input_formattor/flutter_multi_formatter.dart';
import '../../../../main.dart';
import '../../../../models/business_model/edit_profile_model.dart';
import '../../../../models/business_model/profile_model.dart';
import '../../../../models/customer_model/get_category_model.dart';
import '../../../../services/api_service.dart';
import '../../../../services/login_service.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../consumer_screen.dart';
import '../home/home_controller.dart';

class ProfileController extends GetxController {
  RxBool loading = false.obs;
  RxString profileImage = ''.obs;

  RxString businessCategory = "".obs;
  RxString businessCategoryName = "".obs;

  RxString selectImage = ''.obs;
  late List<RxString> businessImages;
  late List<RxBool> businessNetworkImages;

  late List<RxString> openTime;
  late List<RxString> closeTime;
  List<RxString> closeFormatTime = [];

  RxList<GetCategory> categories = <GetCategory>[].obs;
  RxList<Map<String, dynamic>> categoryNames = <Map<String, dynamic>>[].obs;

  late List<RxBool> check;

  RxString countryFlag = "flags/usa.png".obs;
  RxString callingCode = "".obs;
  RxString countryName = "us".obs;

  var selectedCountry = "".obs;
  String selectlengthPhone = "";
  String lengthPhone = "";
  var selectedCountryCode = "+1".obs;
  RxString phoneNumber = ''.obs;
  late PhoneCountryData initialCountryData;
  late PhoneInputFormatter phoneInputFormatter;

  double lat = 0.0;
  double lng = 0.0;

  TextEditingController businessnameController =
      TextEditingController(text: box.read(AppConstants.BUSINESS_NAME));
  TextEditingController numberController =
      TextEditingController(text: box.read(AppConstants.PHONE_NUMBER));
  TextEditingController businesslocationController =
      TextEditingController(text: box.read(AppConstants.BUSINESS_LOCATION));
  TextEditingController ownernameController =
      TextEditingController(text: box.read(AppConstants.OWNER_NAME));
  TextEditingController businessdetailController =
      TextEditingController(text: box.read(AppConstants.BUSINESS_DETAIL));
  TextEditingController ownerEmailController =
      TextEditingController(text: box.read(AppConstants.EMAIL_ID));

  ScrollController chipsScrollController = ScrollController();

  ProfileModel profileModel = ProfileModel();
  EditProfileModel editProfileModel = EditProfileModel();

  var mon = '';
  var tue = '';
  var wed = '';
  var thu = '';
  var fri = '';
  var sat = '';
  var sun = '';
  Map<String, dynamic> monday = {};
  Map<String, dynamic> thusday = {};
  Map<String, dynamic> wednesday = {};
  Map<String, dynamic> thrusday = {};
  Map<String, dynamic> friday = {};
  Map<String, dynamic> satday = {};
  Map<String, dynamic> sunday = {};

  List<Map<String, dynamic>> openHours = [];

  @override
  void onInit() {
    super.onInit();

    profileImage.value =
        "${AppUrls.BASE_API}${box.read(AppConstants.PROFILE_IMG)}";
    countryFlag.value = box.read(AppConstants.COUNTRY_FLAG) ?? "flags/usa.png";
    businessImages = List<RxString>.generate(6, (int index) => ''.obs);

    check = List<RxBool>.generate(7, (int index) => false.obs);
    businessNetworkImages = List<RxBool>.generate(6, (index) => false.obs);
  }

  //check outlet images
  checkOutletImages() {
    businessImages.forEach((element) {
      if (element.contains("uploads/business/")) {
        businessNetworkImages = List<RxBool>.generate(6, (index) => true.obs);
      }
    });
  }

  //check category
  checkBusinessCategory() {
    categories.forEach((element) {
      if (element.catId ==
          box.read(AppConstants.BUSINESS_CATEGORY).toString()) {
        businessCategoryName.value = element.catName.toString();
        businessCategory.value = element.catId.toString();
      }
    });
  }

  //phone format
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

  //businessName validation
  String? businessNameValidation() {
    String businessName = businessnameController.text.trim();

    if (businessName.isEmpty || businessName == '') {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Business Name',
      );
      return '';
    }

    return null;
  }

  //number validation
  bool numberValidation() {
    String number = numberController.text.trim();

    if (number.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Number',
      );
      return false;
    }

    return true;
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

  //ownerName validation
  String? ownerNameValidation() {
    String ownerName = ownernameController.text.trim();

    if (ownerName.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Owner Name',
      );
      return '';
    }

    return null;
  }

  //businessDetail validation
  String? businessDetailValidation() {
    String businessDetail = businessdetailController.text.trim();

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
  bool businessProfileImageValidation() {
    if (profileImage.value.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Select Profile Image.',
      );
      return false;
    }

    return true;
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

  //get falg from code
  getCountryFlagFromCode(BuildContext context, String callingCode) async {
    try {
      var country = await getCountryByCallingCode(context, "+$callingCode");

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

  //get categories
  getCategory() async {
    loading.value = true;

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      await APIService.getRequest(url: AppUrls.GET_CATEGORIES, headers: headers)
          .then((response) async {
        var responseData = await jsonDecode(await response);

        if (responseData is List) {
          if (response != '[]') {
            categories.value = List<GetCategory>.from(
                json.decode(response).map((x) => GetCategory.fromJson(x)));
            categoryNames.clear();
            categories.forEach((element) {
              categoryNames.add({
                "name": element.catName.toString(),
                "id": element.catId.toString()
              });
            });
            checkBusinessCategory();
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
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }

    loading.value = false;
  }

  //get profile detail
  getProfileDetail() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'accept': 'application/json',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
          'content-type': 'application/json',
        };

        await APIService.getRequest(
                url: AppUrls.BUSINESS_PROFILE_DETAIL, headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData["message"] != AppStrings.invalid_token) {
            if (response != null) {
              profileModel = ProfileModel.fromJson(responseData);
              await getDetail(profileModel);
              await getCategory();
              await getCountryFlagFromCode(
                  Get.context!, box.read(AppConstants.COUNTRY_CODE).toString());
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

    loading.value = false;
  }

  //get detail
  getDetail(ProfileModel profileModel) {
    businessImages = profileModel.business!.businessImages!
        .map((img) => RxString(img.toString()))
        .toList();
    profileImage.value =
        "${AppUrls.BASE_API}${profileModel.user!.ownerImg.toString()}";
    numberController =
        TextEditingController(text: profileModel.user!.phoneNumber.toString());
    ownernameController =
        TextEditingController(text: profileModel.user!.ownerName.toString());
    callingCode.value = profileModel.user!.countryCode.toString();
    businesslocationController = TextEditingController(
        text: profileModel.business!.businessLocationDetails.toString());
    businessdetailController = TextEditingController(
        text: profileModel.business!.businessDetail.toString());

    ownerEmailController =
        TextEditingController(text: profileModel.user!.ownerEmail.toString());
    businessCategory.value = profileModel.business!.businessCategory.toString();

    lat = profileModel.business!.businessLocation!.coordinates![1];
    lng = profileModel.business!.businessLocation!.coordinates![0];

    monday = jsonDecode(profileModel.business!.openingHours1.toString());
    thusday = jsonDecode(profileModel.business!.openingHours2.toString());
    wednesday = jsonDecode(profileModel.business!.openingHours3.toString());
    thrusday = jsonDecode(profileModel.business!.openingHours4.toString());
    friday = jsonDecode(profileModel.business!.openingHours5.toString());
    satday = jsonDecode(profileModel.business!.openingHours6.toString());
    sunday = jsonDecode(profileModel.business!.openingHours7.toString());

    openHours.add(monday);
    openHours.add(thusday);
    openHours.add(wednesday);
    openHours.add(thrusday);
    openHours.add(friday);
    openHours.add(satday);
    openHours.add(sunday);
    for (int i = 0; i < openHours.length; i++) {
      final format = DateFormat('h:mm'); // custom pattern: hour:minute
      final dateTime = DateFormat('HH:mm').parse(openHours[i]["to_time"]);
      final formattedTime = format.format(dateTime);

      closeFormatTime.add(formattedTime.obs);
    }

    check = openHours.map((close) => RxBool(close["is_closed"])).toList();
    openTime = openHours.map((open) => RxString(open["from_time"])).toList();
    closeTime = closeFormatTime;
    box.write(AppConstants.IS_NETWORK_IMG, true);
    box.write(AppConstants.PROFILE_IMG, profileImage.value.toString());
    box.write(AppConstants.COUNTRY_CODE, callingCode.value.toString());
    box.write(AppConstants.BUSINESS_CATEGORY,
        profileModel.business!.businessCategory.toString());

    Get.find<HomeController2>().profileImage.value =
        "${AppUrls.BASE_API}${profileModel.user!.ownerImg.toString()}";
    checkOutletImages();
  }

  //edit profile
  editProfileDetail() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        var multipartFile;
        var multipart = <http.MultipartFile>[];

        if (!profileImage.contains(AppUrls.BASE_API)) {
          var mime = lookupMimeType(profileImage.value.toString())!.split("/");
          multipartFile = await http.MultipartFile.fromPath(
            'owner_img',
            profileImage.value.toString(),
            contentType: MediaType(mime[0], mime[1]),
          );
        } else {
          String image = "${box.read(AppConstants.PROFILE_IMG)}";

          var mime = lookupMimeType(profileImage.value.toString())!.split("/");

          final response = await http.get(Uri.parse(image.toString()));

          final directory = await getApplicationDocumentsDirectory();

          final file = File(
              '${directory.path}/${profileImage.split('/').last.toString()}');
          await file.writeAsBytes(response.bodyBytes);
          multipartFile = http.MultipartFile.fromBytes(
              'owner_img', // key
              response.bodyBytes, // value
              filename: profileImage.split('/').last.toString(), // filename
              contentType: MediaType(
                mime[0], mime[1], // content type
              ));
        }

        for (var i = 0; i < businessImages.length; i++) {
          if (!businessImages[i].contains("uploads/business/")) {
            var mimeType =
                await lookupMimeType(businessImages[i].value)?.split("/");
            var multipartFile = await http.MultipartFile.fromPath(
              "business_images",
              businessImages[i].value,
              contentType: MediaType(mimeType![0], mimeType[1]),
            );
            multipart.add(multipartFile);
          } else {
            String image =
                "${AppUrls.BASE_API}${businessImages[i].value.toString()}";
            final response = await http.get(Uri.parse(image));
            var tempDir = await getTemporaryDirectory();
            File file = await File('${tempDir.path}/${i.toString()}.jpg')
                .writeAsString(businessImages[i].value);
            var mimeType = await lookupMimeType(file.path)?.split("/");
            var multipartFile = await http.MultipartFile.fromBytes(
              "business_images",
              response.bodyBytes,
              filename: businessImages[i].split('/').last.toString(),
              contentType: MediaType(mimeType![0], mimeType[1]),
            );
            multipart.add(multipartFile);
          }
        }

        Map<String, String> body = {
          "owner_name": ownernameController.text.toString(),
          "owner_email": ownerEmailController.text.toString(),
          "country_code": callingCode.value.toString(),
          "phone_number": numberController.text.toString(),
          "business_name": ownernameController.text.toString(),
          "business_category": businessCategory.value.toString(),
          "business_detail": businessdetailController.text.toString(),
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
          "device_token": box.read(AppConstants.FCM_TOKEN).toString()
        };
        Map<String, String> headers = {
          'accept': 'application/json',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
          'content-type': 'application/json',
        };

        await APIService.uploadDataImage(
                reqType: "POST",
                url: AppUrls.BUSINESS_UPDATE_PROFILE,
                multipartFile: multipartFile,
                body: body,
                multipartFiles: multipart,
                headers: headers)
            .then((response) async {
          if (response.statusCode == 200) {
            editProfileModel =
                EditProfileModel.fromJson(json.decode(response.body));
            await saveProfileData();
            appSnackbar(content: "Profile Edited SuccessFully");
          } else {
            var responseData = json.decode(response.body);
            appSnackbar(
              error: true,
              content: "${responseData['error']}",
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

  //logout
  logoutCall() {
    loading.value = true;
    Future.delayed(const Duration(seconds: 3), () async {
      await LoginService.signOut();
      loading.value = false;
      Get.offAll(() => const ConsumerScreen());
    });
  }

  //save data
  saveProfileData() async {
    loading.value = true;
    box.write(AppConstants.BUSINESS_NAME, businessnameController.text);
    box.write(AppConstants.BUSINESS_LOCATION, businesslocationController.text);
    box.write(AppConstants.PHONE_NUMBER, numberController.text);
    box.write(AppConstants.OWNER_NAME, ownernameController.text);
    box.write(AppConstants.BUSINESS_DETAIL, businessdetailController.text);
    box.write(AppConstants.COUNTRY_FLAG, countryFlag.value.toString());
    box.write(AppConstants.COUNTRY_NAME, countryName.value);
    box.write(AppConstants.PROFILE_IMG, profileImage.value.toString());

    List<String> outletImages =
        businessImages.map((value) => value.value).toList();
    box.write(AppConstants.OUTLET_IMAGES, outletImages);

    box.write(
        AppConstants.BUSINESS_CATEGORY, businessCategory.value.toString());

    List<String> openingTime = openTime.map((value) => value.value).toList();
    box.write(AppConstants.OPEN_TIME, openingTime);

    List<String> closeingTime = closeTime.map((value) => value.value).toList();
    box.write(AppConstants.CLOSE_TIME, closeingTime);

    Get.back();
    openHours = [];
    businessImages = [];
    closeFormatTime = [];
    openTime = [];
    closeTime = [];
    businessNetworkImages = List<RxBool>.generate(6, (index) => false.obs);

    await getProfileDetail();
  }

  void setCountry(BuildContext context) async {
    var country = await getDefaultCountry(context);
    selectedCountry.value = "${country.countryCode} ${country.callingCode}";
    selectedCountryCode.value = country.callingCode;
  }
}
