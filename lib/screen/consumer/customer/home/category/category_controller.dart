// ignore_for_file: unrelated_type_equality_checks, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../../constant/app_constants.dart';
import '../../../../../constant/app_strings.dart';
import '../../../../../constant/app_urls.dart';
import '../../../../../main.dart';
import '../../../../../models/customer_model/get_all_business_model.dart';
import '../../../../../models/customer_model/get_category_model.dart';
import '../../../../../services/api_service.dart';
import '../../../../../services/image_service.dart';
import '../../../../../services/login_service.dart';
import '../../../../../widgets/app_snackbar.dart';
import '../../../consumer_screen.dart';

class CategoryController extends GetxController {
  SpeechToText speechToText = SpeechToText();
  RxBool loading = false.obs;
  RxBool searchBusiness = false.obs;
  RxBool filterBusiness = false.obs;
  RxBool listening = false.obs;
  TextEditingController searchController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  RefreshController showCategoryRefreshController = RefreshController();
  RefreshController categoryRefreshController = RefreshController();
  var currentTab = 0.obs;
  RxInt selectedTab = 0.obs;
  RxDouble sliderValue = 0.0.obs;
  int page = 1;
  RxBool loadingMore = false.obs;
  RxBool canLoad = false.obs;
  RxString categoryName = ''.obs;
  RxString categoryId = ''.obs;
  RxString sortBy = ''.obs;
  RxString sortByName = ''.obs;

  RxString businessCategoryName = ''.obs;

  RxList<String> sortedCategory = <String>[].obs;
  RxList<String> selectedCategory = <String>[].obs;
  RxList<GetAllBusiness> allBusinesses = <GetAllBusiness>[].obs;
  RxList<GetCategory> categories = <GetCategory>[].obs;
  RxList<Map<String, dynamic>> categoryNames = <Map<String, dynamic>>[].obs;

  double lat = 0.0;
  double lng = 0.0;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      categories = Get.arguments["categories"];
      categoryName.value = Get.arguments["category_name"];
      currentTab.value = Get.arguments["current_index"];
      categoryId.value = Get.arguments["category_id"];

      categories.forEach((element) {
        categoryNames.add({
          "name": element.catName.toString(),
          "id": element.catId.toString()
        });
      });

      print("CATEGORYID:::::: ${categoryId}");
    }
  }

  //speech to text
  startListening() async {
    listening.value = true;

    try {
      bool isGranted = await ImageService.micPermission();

      if (isGranted) {
        if (!speechToText.isAvailable) {
          await speechToText.initialize();
        }
        await speechToText.listen(
          onResult: (result) {
            searchController.text = result.recognizedWords;
            listening.value = false;
            if (searchController.text.isNotEmpty) {
              searchBusiness.value = true;
              filterBusiness.value = false;
              getSearchBusiness(searchController.text);
            } else {
              searchBusiness.value = false;
              filterBusiness.value = false;
              getAllBusiness(loader: false);
            }
          },
          pauseFor: const Duration(seconds: 15),
          listenFor: const Duration(seconds: 15),
        );
      } else {
        listening.value = false;
      }
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }
  }

  //businesslocation validation
  String? yourLocationValidation() {
    String yourLocation = locationController.text.trim();

    if (yourLocation.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Valid Location',
      );
      return '';
    }

    return null;
  }

  //sortBy validation
  bool sortByValidation() {
    if (sortBy.value.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Select Sort By.',
      );
      return false;
    }

    return true;
  }

  //category validation
  bool categoryValidation() {
    if (categoryId.value.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Select Category.',
      );
      return false;
    }

    return true;
  }

  //get categories
  getCategory() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        await APIService.getRequest(
                url: AppUrls.GET_CATEGORIES, headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData is List) {
            if (response != '[]') {
              categories.value = List<GetCategory>.from(
                  json.decode(response).map((x) => GetCategory.fromJson(x)));
            }
          } else {
            appSnackbar(
              error: true,
              content: "Failed To Get Category.",
            );
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

  //get all business
  getAllBusiness({bool loader = true}) async {
    loading.value = loader;

    try {
      if (APIService.internet) {
        searchBusiness.value = false;
        filterBusiness.value = false;
        locationController.clear();
        sortByName.value = '';
        sortBy.value = '';
        sliderValue.value = 0.0;
        lat = 0.0;
        lng = 0.0;
        page = 1;
        allBusinesses.value = [];
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };
        Map<String, dynamic> body = {
          "lat": box.read(AppConstants.CURRENT_LAT).toString(),
          "lng": box.read(AppConstants.CURRENT_LONG).toString(),
          "category_id": categoryId.value.toString(),
        };

        await APIService.postRequest(
                url: AppUrls.GET_CATEGORIES_BUSINESS + page.toString(),
                body: body,
                headers: headers)
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

  //search business
  getSearchBusiness(String value) async {
    try {
      if (APIService.internet) {
        locationController.clear();
        sortByName.value = '';
        sortBy.value = '';
        sliderValue.value = 0.0;
        lat = 0.0;
        lng = 0.0;
        page = 1;
        allBusinesses.value = [];
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };
        Map<String, dynamic> body = {
          "lat": box.read(AppConstants.CURRENT_LAT).toString(),
          "lng": box.read(AppConstants.CURRENT_LONG).toString(),
          "category_id": categoryId.value.toString(),
        };

        await APIService.postRequest(
          url: '${AppUrls.SEARCH_CATEGORIES_BUSINESS}$value&page=$page',
          headers: headers,
          body: body,
        ).then((response) async {
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

  //filter Business
  getFilterBusiness() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        filterBusiness.value = true;
        searchBusiness.value = false;
        searchController.clear();
        page = 1;
        allBusinesses.value = [];
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };
        Map<String, dynamic> body = {
          "lat": lat == 0.0
              ? box.read(AppConstants.CURRENT_LAT).toString()
              : lat.toString(),
          "lng": lng == 0.0
              ? box.read(AppConstants.CURRENT_LONG).toString()
              : lng.toString(),
          "category_id": categoryId.value.toString(),
          "distance": sliderValue.value.toString(),
          "sort_by": sortByName.value.toString(),
        };

        await APIService.postRequest(
                url: AppUrls.FILTER_BUSINESS + page.toString(),
                body: body,
                headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response.body);

          if (response.statusCode == 200) {
            allBusinesses.value = List<GetAllBusiness>.from(
                responseData['data'].map((x) => GetAllBusiness.fromJson(x)));
            page++;
            for (var i = 0; i < categories.length; i++) {
              if (categories[i].catId == categoryId) {
                categoryName.value = categories[i].catName.toString();
                currentTab.value = i;
              }
            }

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
                if (filterBusiness.value) {
                  Map<String, String> headers = {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'authorization':
                        'Bearer ${box.read(AppConstants.TOKEN).toString()}',
                  };
                  Map<String, dynamic> body = {
                    "lat": lat == 0.0
                        ? box.read(AppConstants.CURRENT_LAT).toString()
                        : lat.toString(),
                    "lng": lng == 0.0
                        ? box.read(AppConstants.CURRENT_LONG).toString()
                        : lng.toString(),
                    "category_id": categoryId.value.toString(),
                    "distance": sliderValue.value.toString(),
                    "sort_by": sortByName.value.toString(),
                  };

                  await APIService.postRequest(
                          url: AppUrls.FILTER_BUSINESS + page.toString(),
                          body: body,
                          headers: headers)
                      .then((response) async {
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
                } else if (searchBusiness.value) {
                  Map<String, String> headers = {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'authorization':
                        'Bearer ${box.read(AppConstants.TOKEN).toString()}',
                  };
                  Map<String, dynamic> body = {
                    "lat": box.read(AppConstants.CURRENT_LAT).toString(),
                    "lng": box.read(AppConstants.CURRENT_LONG).toString(),
                    "category_id": categoryId.value.toString(),
                  };

                  await APIService.postRequest(
                    url:
                        '${AppUrls.SEARCH_CATEGORIES_BUSINESS}${searchController.text}&page=$page',
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
                } else {
                  Map<String, String> headers = {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'authorization':
                        'Bearer ${box.read(AppConstants.TOKEN).toString()}',
                  };
                  Map<String, dynamic> body = {
                    "lat": box.read(AppConstants.CURRENT_LAT).toString(),
                    "lng": box.read(AppConstants.CURRENT_LONG).toString(),
                    "category_id": categoryId.value.toString(),
                  };

                  await APIService.postRequest(
                          url:
                              AppUrls.GET_CATEGORIES_BUSINESS + page.toString(),
                          body: body,
                          headers: headers)
                      .then((response) async {
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

  // category name
  String setCategoryName(String catId) {
    for (var element in categories) {
      if (element.catId == catId) {
        businessCategoryName.value = element.catName.toString();
      }
    }
    return businessCategoryName.value;
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
