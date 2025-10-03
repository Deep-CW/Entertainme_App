import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../constant/app_constants.dart';
import '../../../../../constant/app_strings.dart';
import '../../../../../constant/app_urls.dart';
import '../../../../../main.dart';
import '../../../../../models/customer_model/get_all_business_model.dart';
import '../../../../../models/customer_model/get_all_business_offer_model.dart';
import '../../../../../services/api_service.dart';
import '../../../../../services/login_service.dart';
import '../../../../../widgets/app_snackbar.dart';
import '../../../consumer_screen.dart';
import '../../favourite/favourite_controller.dart';
import '../../notification/notification_controller.dart';
import '../category/category_controller.dart';
import '../home_controller.dart';

import 'package:http/http.dart' as http;

class NearToTouController extends GetxController {
  int page = 1;
  RxBool loadingMore = false.obs;
  RxBool canLoad = false.obs;
  RxBool loading = false.obs;
  CarouselController carouselController = CarouselController();
  RefreshController neartoyouRefreshController = RefreshController();
  RxBool scrollUp = false.obs;
  LatLng center = const LatLng(0.0, 0.0);
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;
  RxList<Marker> markers = <Marker>[].obs;
  Completer<GoogleMapController> mapControler = Completer();
  TabController? tabController;
  RxInt carouselIndex = 0.obs;
  RxBool showLongDes = false.obs;
  RxBool favorite = false.obs;
  RxBool rated = false.obs;
  var currentTab = 0.obs;
  RxString rating = "".obs;
  RxString ratingCount = ''.obs;

  // Business business = Business();
  // BusinessOwner businessOwner = BusinessOwner();
  RxString businessProfile = "".obs;
  RxString businessId = "".obs;
  RxString ownerId = "".obs;
  RxString businessName = "".obs;
  RxString businessDetail = "".obs;
  RxString businessLocation = "".obs;
  RxString countryCode = "".obs;
  RxString phoneNumber = "".obs;

  RxList<String> businessImages = <String>[].obs;
  //RxList<OpeningHours> openHour = <OpeningHours>[].obs;
  dynamic getRating = 0.0;

  RxList<GetAllBusinessOffer> getBusinessOffers = <GetAllBusinessOffer>[].obs;
  RxList<GetAllBusiness> allBusinesses = <GetAllBusiness>[].obs;

  Map<String, dynamic> monday = {};
  Map<String, dynamic> thusday = {};
  Map<String, dynamic> wednesday = {};
  Map<String, dynamic> thrusday = {};
  Map<String, dynamic> friday = {};
  Map<String, dynamic> satday = {};
  Map<String, dynamic> sunday = {};

  var mon = '';
  var tue = '';
  var wed = '';
  var thu = '';
  var fri = '';
  var sat = '';
  var sun = '';

  List<Map<String, dynamic>> openHours = [];
  List<Map<String, dynamic>> openDays = [];

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      businessId.value = Get.arguments["business_id"] ?? "";
      ownerId.value = Get.arguments["owner_id"] ?? "";
      businessName.value = Get.arguments["business_name"] ?? "";
      businessDetail.value = Get.arguments["business_Detail"] ?? "";
      businessLocation.value = Get.arguments["business_location"] ?? "";
      businessProfile.value = Get.arguments["business_profile"] ?? "";
      countryCode.value = Get.arguments["country_code"] ?? "";
      phoneNumber.value = Get.arguments["phone_number"] ?? "";
      businessImages.value = Get.arguments["business_images"] ?? [];
      favorite.value = Get.arguments["favorite"] ?? false;
      //openHour.value = Get.arguments["open_hour"] ?? [];
      getRating = Get.arguments["ratings"] != null
          ? double.parse(Get.arguments["ratings"].toString())
          : 0.0;
      ratingCount.value = Get.arguments["rating_count"] ?? "0";
      rated.value = Get.arguments["rated"];
      lat.value = Get.arguments["lat"];
      long.value = Get.arguments["lng"];
      mon = Get.arguments["opening_hours_1"] ?? "";
      tue = Get.arguments["opening_hours_2"] ?? "";
      wed = Get.arguments["opening_hours_3"] ?? "";
      thu = Get.arguments["opening_hours_4"] ?? "";
      fri = Get.arguments["opening_hours_5"] ?? "";
      sat = Get.arguments["opening_hours_6"] ?? "";
      sun = Get.arguments["opening_hours_7"] ?? "";

      clickBusinessProfile(ownerId.value.toString());
      checkOpenHour();
    }
  }

  CameraPosition kGoogle = const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 12.05,
  );

  //set to favourites business
  setFavouriteBusiness() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };
        Map<String, dynamic> body = {
          "user_id": box.read(AppConstants.USER_ID).toString(),
          "business_owner_id": ownerId.value.toString(),
        };

        await APIService.postRequest(
          url: AppUrls.SET_FAVOURITES_BUSINESS,
          headers: headers,
          body: body,
        ).then((response) async {
          var responseData = await jsonDecode(response.body);

          if (responseData["message"] != AppStrings.invalid_token) {
            if (responseData["message"] !=
                AppStrings.business_remove_favourite) {
              favorite.value = true;
              appSnackbar(content: responseData["message"].toString());

              if (Get.arguments['from'] == 'category') {
                CategoryController categoryController =
                    Get.put(CategoryController());
                int index = categoryController.allBusinesses
                    .indexWhere((element) => element.sId == businessId.value);
                categoryController.allBusinesses[index].isFavorite = true;
              } else if (Get.arguments['from'] == 'home') {
                HomeController homeController = Get.put(HomeController());
                int index = homeController.allBusinesses
                    .indexWhere((element) => element.sId == businessId.value);
                homeController.allBusinesses[index].isFavorite = true;
              } else if (Get.arguments['from'] == 'near') {
                int index = allBusinesses
                    .indexWhere((element) => element.sId == businessId.value);
                allBusinesses[index].isFavorite = true;
              } else if (Get.arguments['from'] == 'favourite') {
                FavouriteController favouriteController =
                    Get.put(FavouriteController());
                favouriteController.getFavouriteBusiness();
              } else if (Get.arguments['from'] == 'notification') {
                NotificationController notificationController =
                    Get.put(NotificationController());
                int index = notificationController.notifications.indexWhere(
                    (element) =>
                        element.businessDetails?.id == businessId.value);
                notificationController
                    .notifications[index].businessDetails?.isFavorite = true;
              }
            } else {
              favorite.value = false;
              appSnackbar(
                  content: responseData["message"].toString(), error: true);

              if (Get.arguments['from'] == 'category') {
                CategoryController categoryController =
                    Get.put(CategoryController());
                int index = categoryController.allBusinesses
                    .indexWhere((element) => element.sId == businessId.value);
                categoryController.allBusinesses[index].isFavorite = false;
              } else if (Get.arguments['from'] == 'home') {
                HomeController homeController = Get.put(HomeController());
                int index = homeController.allBusinesses
                    .indexWhere((element) => element.sId == businessId.value);
                homeController.allBusinesses[index].isFavorite = false;
              } else if (Get.arguments['from'] == 'near') {
                int index = allBusinesses
                    .indexWhere((element) => element.sId == businessId.value);
                allBusinesses[index].isFavorite = false;
              } else if (Get.arguments['from'] == 'favourite') {
                FavouriteController favouriteController =
                    Get.put(FavouriteController());
                favouriteController.getFavouriteBusiness();
              } else if (Get.arguments['from'] == 'notification') {
                NotificationController notificationController =
                    Get.put(NotificationController());
                int index = notificationController.notifications.indexWhere(
                    (element) =>
                        element.businessDetails?.id == businessId.value);
                notificationController
                    .notifications[index].businessDetails?.isFavorite = false;
              }
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

  checkOpenHour() {
    monday = jsonDecode(mon);
    thusday = jsonDecode(tue);
    wednesday = jsonDecode(wed);
    thrusday = jsonDecode(thu);
    friday = jsonDecode(fri);
    satday = jsonDecode(sat);
    sunday = jsonDecode(sun);

    openHours.add(monday);
    openHours.add(thusday);
    openHours.add(wednesday);
    openHours.add(thrusday);
    openHours.add(friday);
    openHours.add(satday);
    openHours.add(sunday);

    openDays = openHours.where((entry) => entry['is_closed'] == false).toList();
  }

  //give rating
  giveRating() async {
    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };
        Map<String, dynamic> body = {
          "user_id": box.read(AppConstants.USER_ID).toString(),
          "business_owner_id": ownerId.value,
          "rating": rating.value,
        };

        await APIService.postRequest(
          url: AppUrls.GIVE_RATING,
          headers: headers,
          body: body,
        ).then((response) async {
          var responseData = await jsonDecode(response.body);

          if (responseData["message"] != AppStrings.invalid_token) {
            if (responseData["message"] != AppStrings.error_update_rating) {
              getRating = double.parse(rating.value);
              rated.value = true;
              appSnackbar(content: responseData["message"].toString());
              update(["update"]);

              if (Get.arguments['from'] == 'category') {
                CategoryController categoryController =
                    Get.put(CategoryController());
                int index = categoryController.allBusinesses
                    .indexWhere((element) => element.sId == businessId.value);
                categoryController.allBusinesses[index].userHasRated = true;
              } else if (Get.arguments['from'] == 'home') {
                HomeController homeController = Get.put(HomeController());
                int index = homeController.allBusinesses
                    .indexWhere((element) => element.sId == businessId.value);
                homeController.allBusinesses[index].userHasRated = true;
              } else if (Get.arguments['from'] == 'near') {
                int index = allBusinesses
                    .indexWhere((element) => element.sId == businessId.value);
                allBusinesses[index].userHasRated = true;
              } else if (Get.arguments['from'] == 'favourite') {
                FavouriteController favouriteController =
                    Get.put(FavouriteController());
                int index = favouriteController.favourite.indexWhere(
                    (element) => element.business?.sId == businessId.value);
                favouriteController.favourite[index].business?.userHasRated =
                    true;
              } else if (Get.arguments['from'] == 'notification') {
                NotificationController notificationController =
                    Get.put(NotificationController());
                int index = notificationController.notifications.indexWhere(
                    (element) =>
                        element.businessDetails?.id == businessId.value);
                notificationController
                    .notifications[index].businessDetails?.userHasRated = true;
              }
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
  }

  //GET ALL BUSINESS OFFER
  getBusinessOffer() async {
    try {
      if (APIService.internet) {
        getBusinessOffers.value = [];
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };

        await APIService.getRequest(
                url:
                    "${AppUrls.GET_ALL_BUSINESS_OFFER}${ownerId.value.toString()}",
                headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData is List) {
            if (response != '[]') {
              getBusinessOffers.addAll(List<GetAllBusinessOffer>.from(json
                  .decode(response)
                  .map((x) => GetAllBusinessOffer.fromJson(x))));
            } else {
              print("ERROR");
            }
          } else if (responseData["message"] == AppStrings.invalid_token) {
            logoutCall();
          }
        });
      }
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }
  }

  //get offer days
  String getDays(String date) {
    String getDate = date;
    DateTime dateTime = DateTime.parse(getDate);
    DateTime now = DateTime.now();
    int differenceInDays = (dateTime.difference(now).inHours / 24).round();

    getDaysLeft(differenceInDays);

    return differenceInDays.toString();
  }

  String getDaysLeft(int days) {
    DateTime now = DateTime.now();
    DateTime futureDate = now.add(Duration(days: days));
    String formattedDate = DateFormat('d MMMM').format(futureDate);
    return formattedDate;
  }

  //to get current location
  getCurrentLocation() async {
    lat.value = lat.value;
    long.value = long.value;

    markers.add(Marker(
      markerId: MarkerId(lat.toString()),
      position: LatLng(lat.value, long.value),
    ));

    kGoogle = CameraPosition(
      target: LatLng(lat.value, long.value),
      zoom: 12.05,
    );

    final GoogleMapController controller = await mapControler.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kGoogle));
  }

  //get all business
  getAllBusiness() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        page = 1;
        allBusinesses.value = [];
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };
        Map<String, dynamic> body = {
          "lat": box.read(AppConstants.CURRENT_LAT).toString(),
          "lng": box.read(AppConstants.CURRENT_LONG).toString(),
        };

        await APIService.postRequest(
                url: AppUrls.GET_ALL_BUSINESS + page.toString(),
                headers: headers,
                body: body)
            .then((response) async {
          var responseData = await jsonDecode(await response.body);

          if (response.statusCode == 200) {
            allBusinesses.value = List<GetAllBusiness>.from(
                responseData['data'].map((x) => GetAllBusiness.fromJson(x)));
            page++;

            if (allBusinesses.length % 20 == 0) {
              canLoad.value = true;
            } else {
              canLoad.value = false;
            }
          } else if (responseData["message"] == AppStrings.invalid_token) {
            logoutCall();
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

  //load more data
  moreData() async {
    try {
      if (APIService.internet) {
        if (canLoad.value) {
          if (allBusinesses.length % 20 == 0) {
            loadingMore.value = true;

            await Future.delayed(
              const Duration(seconds: 1),
              () async {
                Map<String, String> headers = {
                  'Content-Type': 'application/x-www-form-urlencoded',
                  'authorization':
                      'Bearer ${box.read(AppConstants.TOKEN).toString()}',
                };
                Map<String, dynamic> body = {
                  "lat": box.read(AppConstants.CURRENT_LAT).toString(),
                  "lng": box.read(AppConstants.CURRENT_LONG).toString(),
                };

                await APIService.postRequest(
                  url: AppUrls.GET_ALL_BUSINESS + page.toString(),
                  headers: headers,
                  body: body,
                ).then((response) async {
                  var responseData = await jsonDecode(await response.body);

                  if (response.statusCode == 200) {
                    if (responseData['data'].isNotEmpty) {
                      allBusinesses.addAll(List<GetAllBusiness>.from(
                          responseData['data']
                              .map((x) => GetAllBusiness.fromJson(x))));
                      page++;
                    } else {
                      canLoad.value = false;
                    }
                  } else if (responseData["message"] ==
                      AppStrings.invalid_token) {
                    logoutCall();
                  } else {
                    appSnackbar(
                      error: true,
                      content: responseData['error'],
                    );
                  }
                });
              },
            );

            loadingMore.value = false;
          }
        }
      }
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }
  }

  //offer profile business
  clickBusinessOffer(String offerId) async {
    loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };
        Map<String, dynamic> body = {
          "user_id": box.read(AppConstants.USER_ID).toString(),
          "business_owner_id": ownerId.value,
          "business_offer_id": offerId.toString(),
        };

        await APIService.postRequest(
          url: AppUrls.BUSINESS_PROFILE_OFFER,
          headers: headers,
          body: body,
        ).then((response) async {
          var responseData = await jsonDecode(response.body);
          if (responseData["message"] != AppStrings.invalid_token) {
            if (responseData["message"] ==
                AppStrings.business_offer_record_success) {
              print(responseData["message"]);
            }
          } else {
            logoutCall();
          }
        });
      }
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }

    loading.value = false;
  }

  //click profile business
  clickBusinessProfile(String ownerId) async {
    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };
        Map<String, dynamic> body = {
          "user_id": box.read(AppConstants.USER_ID).toString(),
          "business_owner_id": ownerId,
        };

        await APIService.postRequest(
          url: AppUrls.VIEW_BUSINESS_PROFILE,
          headers: headers,
          body: body,
        ).then((response) async {
          var responseData = await jsonDecode(response.body);
          if (responseData["message"] != AppStrings.invalid_token) {
            if (responseData["message"] ==
                AppStrings.business_profile_record_success) {
              // appSnackbar(content: responseData["message"].toString());
            }
          } else {
            logoutCall();
          }
        });
      }
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }
  }

  //open phone
  callPhone(String phoneNo) async {
    try {
      Uri phoneno = Uri.parse('tel:$phoneNo');
      launchUrl(phoneno);
    } catch (e) {
      appSnackbar(content: 'Not Open DialPad', error: true);
    }
  }

  //open google map
  openGoogleMap(double lat, double long) async {
    try {
      Uri mapUrl = Uri.parse('${AppUrls.androidMap}$lat,$long');
      launchUrl(mapUrl);
    } catch (e) {
      appSnackbar(content: 'Not get Location', error: true);
    }
  }

  String convertTo12HourFormat(String time24) {
    // Parse the 24-hour format time
    DateTime dateTime = DateFormat.Hm().parse(time24);

    // Format the time in 12-hour format
    String time12 = DateFormat.jm().format(dateTime);

    return time12;
  }

  //share detail
  shareDetail() async {
    if (APIService.internet) {
      final XFile? imageFile =
          await downloadImage("${AppUrls.BASE_API}${businessProfile.value}");

      try {
        String content =
            'Business Name: ${businessName.toString()}\nPhone Number: +${countryCode.value} ${phoneNumber.value}\nDirection: ${Uri.parse('${AppUrls.androidMap}$lat,$long')}';

        await Share.shareXFiles(
          [imageFile!],
          text: content,
        );

        deleteFile(imageFile.path);
      } catch (error) {
        appSnackbar(
          error: true,
          content: error.toString(),
        );
      }
    } else {
      appSnackbar(
        error: true,
        content: AppStrings.no_internet,
      );
    }
  }

  //download image
  Future<XFile?> downloadImage(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final fileName = url.split('/').last;
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        return XFile(file.path);
      } else {
        appSnackbar(
          error: true,
          content: 'Error while saving image',
        );
      }
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }

    return null;
  }

  //delete download file
  deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
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
}
