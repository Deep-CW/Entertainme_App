// ignore_for_file: prefer_conditional_assignment, unnecessary_null_comparison, non_constant_identifier_names, depend_on_referenced_packages

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uuid/uuid.dart';

import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../main.dart';
import '../../../../models/customer_model/get_all_business_model.dart';
import '../../../../models/customer_model/get_banner_model.dart';
import '../../../../models/customer_model/get_category_model.dart';
import '../../../../services/api_service.dart';
import '../../../../services/google_map_service.dart';
import '../../../../services/login_service.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../consumer_screen.dart';
import '../dashboard/dashboard_controller.dart';

import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  RxBool loading = false.obs;
  RxBool searchBusiness = false.obs;
  RxInt carouselIndex = 0.obs;
  RxString placeName = ''.obs;
  int page = 1;
  RxBool loadingMore = false.obs;
  RxBool canLoad = false.obs;
  String sessionToken = "";
  RxString profileImage = "".obs;
  RxString userName = box.read(AppConstants.USER_NAME).toString().obs;

  int? choice;

  RxList<dynamic> placeList = <dynamic>[].obs;
  RxList<GetCategory> categories = <GetCategory>[].obs;
  RxList<GetBanners> banners = <GetBanners>[].obs;
  RxList<GetAllBusiness> allBusinesses = <GetAllBusiness>[].obs;
  RxList<GetAllBusiness> businesses = <GetAllBusiness>[].obs;

  var uuid = const Uuid();
  CarouselController carouselController = CarouselController();
  late RefreshController homeRefreshController;

  TextEditingController searchController = TextEditingController();
  TextEditingController locationSearchController = TextEditingController();

  final dashboardController = Get.put(DashBoardController());

  RxList<GetAllBusiness> loadMoreBusinesses = <GetAllBusiness>[].obs;

  @override
  void onInit() {
    super.onInit();

    print("USER ID:${box.read(AppConstants.USER_ID).toString()}");
    print("TOKEN:${box.read(AppConstants.TOKEN).toString()}");
    homeRefreshController = RefreshController(initialRefresh: false);
    profileImage =
        "${AppUrls.BASE_API}${box.read(AppConstants.PROFILE_IMG)}".obs;

    getCurrentLocation();
    getCategory();
    getBanners();
  }

  @override
  void dispose() {
    super.dispose();

    homeRefreshController.dispose();
  }

  //to get current location
  getCurrentLocation() async {
    try {
      if (APIService.internet) {
        var permission = await GoogleMapService.checkLocationPermission();

        if (permission) {
          Position? position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          if (position != null) {
            box.write(AppConstants.CURRENT_LAT, position.latitude);
            box.write(AppConstants.CURRENT_LONG, position.longitude);
          }
        }
      }
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }
    setPlaceName();
  }

  setPlaceName() async {
    try {
      if (APIService.internet) {
        if (box.read(AppConstants.CURRENT_LAT) != null) {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            box.read(AppConstants.CURRENT_LAT),
            box.read(AppConstants.CURRENT_LONG),
          );
          placeName.value =
              "${placemarks.first.street.toString()}, ${placemarks.first.subLocality.toString()}, ${placemarks.first.locality.toString()}, ${placemarks.first.administrativeArea.toString()}, ${placemarks.first.country.toString()}";
          box.write(AppConstants.SELECTED_LOCATION, placeName.value);
        }
      } else {
        placeName.value = box.read(AppConstants.SELECTED_LOCATION);
      }
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }
    getAllBusiness();
  }

  //get location suggestion
  getSuggestion() async {
    try {
      if (APIService.internet) {
        if (sessionToken == null) {
          sessionToken = uuid.v4();
        }
        String PLACES_API_KEY = AppUrls.kGoogleApiKey;
        String input = locationSearchController.text;
        String types = 'establishment';
        String request =
            '${AppUrls.LOCATION_CITY_API}?input=$input&types=$types&key=$PLACES_API_KEY&sessiontoken=$sessionToken';
        // String request =
        //     '${AppUrls.LOCATION_CITY_API}?input=$input&key=$PLACES_API_KEY&sessiontoken=$sessionToken';

        var response = await http.get(Uri.parse(request));

        if (response.statusCode == 200) {
          placeList.value = json.decode(response.body)['predictions'];
        } else {
          appSnackbar(
            error: true,
            content: 'Failed to load predictions',
          );
        }
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

  //get lat-long from place
  getLatLong({
    required String input,
  }) async {
    try {
      if (APIService.internet) {
        String PLACES_API_KEY = AppUrls.kGoogleApiKey;
        String request =
            '${AppUrls.GET_LAT_LONG_API}address=$input&key=$PLACES_API_KEY';

        var response = await http.get(Uri.parse(request));

        if (response.statusCode == 200) {
          var res = await json.decode(response.body);
          double lat =
              res['results'][0]['navigation_points'][0]['location']['latitude'];
          double long = res['results'][0]['navigation_points'][0]['location']
              ['longitude'];
          box.write(AppConstants.CURRENT_LAT, lat);
          box.write(AppConstants.CURRENT_LONG, long);
          setPlaceName();
        } else {
          appSnackbar(
            error: true,
            content: 'Failed to load predictions',
          );
        }
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

  //get categories
  getCategory() async {
    loading.value = true;
    dashboardController.loading.value = true;

    try {
      categories.clear();
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      if (APIService.internet) {
        await APIService.getRequest(
                url: AppUrls.GET_CATEGORIES, headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData is List) {
            if (response != '[]') {
              categories.value = List<GetCategory>.from(
                  json.decode(response).map((x) => GetCategory.fromJson(x)));
              List<GetCategory> data = List<GetCategory>.from(
                  json.decode(response).map((x) => GetCategory.fromJson(x)));

              for (GetCategory element in data) {
                String encodedImage = await APIService.encodedImage(
                    AppUrls.BASE_API + element.catImg!);

                element.catImg = encodedImage;
              }
              String encodedData = getCategoryToJson(data);
              APIService.storeDataLocally(
                  fileName: AppConstants.CATEGORIES, data: encodedData);
            }
          } else {
            String? data = await APIService.getDataLocally(
                fileName: AppConstants.CATEGORIES);
            if (data != null) {
              categories.value = getCategoryFromJson(data);
              for (var element in categories) {
                element.locally = true;
              }
            }
            appSnackbar(
              error: true,
              content: "Failed To Get Category.",
            );
          }
        });
      } else {
        String? data =
            await APIService.getDataLocally(fileName: AppConstants.CATEGORIES);
        if (data != null) {
          categories.value = getCategoryFromJson(data);
          for (var element in categories) {
            element.locally = true;
          }
        }
      }
    } catch (error) {
      String? data =
          await APIService.getDataLocally(fileName: AppConstants.CATEGORIES);
      if (data != null) {
        categories.value = getCategoryFromJson(data);
        for (var element in categories) {
          element.locally = true;
        }
      }
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }

    loading.value = false;
    dashboardController.loading.value = false;
  }

  // category name
  String setCategoryName(String catId) {
    String categoryName = '';

    for (var element in categories) {
      if (element.catId == catId) {
        categoryName = element.catName.toString();
      }
    }
    return categoryName;
  }

  //get banners
  getBanners() async {
    loading.value = true;

    try {
      banners.clear();
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      if (APIService.internet) {
        await APIService.getRequest(url: AppUrls.GET_BANNERS, headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData is List) {
            if (response != '[]') {
              banners.value = List<GetBanners>.from(
                  json.decode(response).map((x) => GetBanners.fromJson(x)));
              List<GetBanners> data = List<GetBanners>.from(
                  json.decode(response).map((x) => GetBanners.fromJson(x)));

              for (GetBanners element in data) {
                String encodedImage = await APIService.encodedImage(
                    AppUrls.BASE_API + element.banImg!);

                element.banImg = encodedImage;
              }
              String encodedData = getBannersToJson(data);
              APIService.storeDataLocally(
                  fileName: AppConstants.BANNERS, data: encodedData);
            }
          } else {
            String? data =
                await APIService.getDataLocally(fileName: AppConstants.BANNERS);
            if (data != null) {
              banners.value = getBannersFromJson(data);
              for (var element in banners) {
                element.locally = true;
              }
            }
            appSnackbar(
              error: true,
              content: "Failed To Get Banner.",
            );
          }
        });
      } else {
        String? data =
            await APIService.getDataLocally(fileName: AppConstants.BANNERS);
        if (data != null) {
          banners.value = getBannersFromJson(data);
          for (var element in banners) {
            element.locally = true;
          }
        }
      }
    } catch (error) {
      String? data =
          await APIService.getDataLocally(fileName: AppConstants.BANNERS);
      if (data != null) {
        banners.value = getBannersFromJson(data);
        for (var element in banners) {
          element.locally = true;
        }
      }
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }

    loading.value = false;
  }

  //get all business
  getAllBusiness({bool loader = true}) async {
    loading.value = loader;

    try {
      page = 1;
      allBusinesses.value = [];
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
      };
      Map<String, dynamic> body = {
        "lat": box.read(AppConstants.CURRENT_LAT).toString(),
        "lng": box.read(AppConstants.CURRENT_LONG).toString(),
        // "lat": null.toString(),
        // "lng": null.toString(),
      };

      if (APIService.internet) {
        await APIService.postRequest(
                url: AppUrls.GET_ALL_BUSINESS + page.toString(),
                headers: headers,
                body: body)
            .then((response) async {
          var responseData = await jsonDecode(await response.body);

          if (response.statusCode == 200) {
            allBusinesses.value = List<GetAllBusiness>.from(
                responseData['data'].map((x) => GetAllBusiness.fromJson(x)));
            loading.value = false;
            List<GetAllBusiness> data = List<GetAllBusiness>.from(
                responseData['data'].map((x) => GetAllBusiness.fromJson(x)));

            for (GetAllBusiness element in data) {
              List<String> encodedImages = [];
              for (String url in element.businessImages!) {
                encodedImages
                    .add(await APIService.encodedImage(AppUrls.BASE_API + url));
              }
              element.businessImages = encodedImages;
            }
            String encodedData = getAllBusinessToJson(data);
            APIService.storeDataLocally(
                fileName: AppConstants.BUSINESSES, data: encodedData);
            page++;

            if (allBusinesses.length % 20 == 0) {
              canLoad.value = true;
            } else {
              canLoad.value = false;
            }
          } else if (responseData["message"] == AppStrings.invalid_token) {
            logoutCall();
          } else {
            String? data = await APIService.getDataLocally(
                fileName: AppConstants.BUSINESSES);
            if (data != null) {
              businesses.value = getAllBusinessFromJson(data);
              allBusinesses.value = getAllBusinessFromJson(data);
              for (var element in allBusinesses) {
                element.locally = true;
              }
            }
            appSnackbar(
              error: true,
              content: responseData['error'],
            );
          }
        });
      } else {
        String? data =
            await APIService.getDataLocally(fileName: AppConstants.BUSINESSES);
        if (data != null) {
          businesses.value = getAllBusinessFromJson(data);
          allBusinesses.value = getAllBusinessFromJson(data);
          for (var element in allBusinesses) {
            element.locally = true;
          }
        }
      }
    } catch (error) {
      String? data =
          await APIService.getDataLocally(fileName: AppConstants.BUSINESSES);
      if (data != null) {
        businesses.value = getAllBusinessFromJson(data);
        allBusinesses.value = getAllBusinessFromJson(data);
        for (var element in allBusinesses) {
          element.locally = true;
        }
      }
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }

    loading.value = false;
  }

  //search business
  getSearchBusiness(String value) async {
    try {
      page = 1;
      allBusinesses.clear();
      String lat = box.read(AppConstants.CURRENT_LAT).toString();
      String lng = box.read(AppConstants.CURRENT_LONG).toString();
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
      };
      String url = AppUrls.SEARCH_BUSINESS + value;
      String para =
          lat == 'null' ? '&page=$page' : '&lat=$lat&lng=$lng&page=$page';

      if (APIService.internet) {
        await APIService.getRequest(url: url + para, headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData['error'] == null) {
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
            allBusinesses.value = businesses
                .where((element) => element.businessName!
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList();
            for (var element in allBusinesses) {
              element.locally = true;
            }
            appSnackbar(
              error: true,
              content: responseData['error'],
            );
          }
        });
      } else {
        allBusinesses.value = businesses
            .where((element) => element.businessName!
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList();
        for (var element in allBusinesses) {
          element.locally = true;
        }
      }
    } catch (error) {
      allBusinesses.value = businesses
          .where((element) =>
              element.businessName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      for (var element in allBusinesses) {
        element.locally = true;
      }
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }
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
                if (searchBusiness.value) {
                  String lat = box.read(AppConstants.CURRENT_LAT).toString();
                  String lng = box.read(AppConstants.CURRENT_LONG).toString();
                  Map<String, String> headers = {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'authorization':
                        'Bearer ${box.read(AppConstants.TOKEN).toString()}',
                  };
                  String url = AppUrls.SEARCH_BUSINESS + searchController.text;
                  String para = lat == 'null'
                      ? '&page=$page'
                      : '&lat=$lat&lng=$lng&page=$page';

                  await APIService.getRequest(url: url + para, headers: headers)
                      .then((response) async {
                    var responseData = await jsonDecode(await response);

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
                } else {
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
                }
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
