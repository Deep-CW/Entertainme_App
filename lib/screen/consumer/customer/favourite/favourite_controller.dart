import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../main.dart';
import '../../../../models/customer_model/get_category_model.dart';
import '../../../../models/customer_model/get_favourite_business_model.dart';
import '../../../../services/api_service.dart';
import '../../../../services/image_service.dart';
import '../../../../services/login_service.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../consumer_screen.dart';
import '../dashboard/dashboard_controller.dart';

class FavouriteController extends GetxController {
  SpeechToText speechToText = SpeechToText();
  RxBool loading = false.obs;
  RxBool searchBusiness = false.obs;
  RxBool listening = false.obs;
  TextEditingController searchController = TextEditingController();
  RefreshController favouriteRefreshController = RefreshController();
  RxString categoryName = "".obs;

  RxList<GetFavouriteBusiness> favourite = <GetFavouriteBusiness>[].obs;
  RxList<GetCategory> categories = <GetCategory>[].obs;

  final dashboardController = Get.put(DashBoardController());
  String lat = box.read(AppConstants.CURRENT_LAT) == null
      ? "0.0"
      : box.read(AppConstants.CURRENT_LAT).toString();
  String lng = box.read(AppConstants.CURRENT_LONG) == null
      ? "0.0"
      : box.read(AppConstants.CURRENT_LONG).toString();

  @override
  void onInit() {
    super.onInit();

    getFavouriteBusiness();
    getCategory();
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
              getSearchBusiness(searchController.text);
            } else {
              searchBusiness.value = false;
              getFavouriteBusiness(loader: false);
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

//get favourite business
  getFavouriteBusiness({bool loader = true}) async {
    loading.value = loader;
    dashboardController.loading.value = loader;

    try {
      if (APIService.internet) {
        favourite.value = [];
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };

        await APIService.getRequest(
                url:
                    "${AppUrls.GET_FAVOURITES_BUSINESS}${box.read(AppConstants.USER_ID).toString()}",
                headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData is List) {
            if (response != '[]') {
              favourite.addAll(List<GetFavouriteBusiness>.from(json
                  .decode(response)
                  .map((x) => GetFavouriteBusiness.fromJson(x))));
            }
          } else if (responseData["message"] == AppStrings.invalid_token) {
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
    dashboardController.loading.value = false;
  }

  //search favourite business
  getSearchBusiness(String value) async {
    try {
      if (APIService.internet) {
        favourite.value = [];
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };

        await APIService.getRequest(
                url:
                    "${AppUrls.SEARCH_FAVORITE_BUSINESS}${box.read(AppConstants.USER_ID).toString()}&search=${value.toString()}",
                headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData is List) {
            if (response != '[]') {
              favourite.addAll(List<GetFavouriteBusiness>.from(json
                  .decode(response)
                  .map((x) => GetFavouriteBusiness.fromJson(x))));
            }
          } else if (responseData["message"] == AppStrings.invalid_token) {
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

  //get categories
  getCategory() async {
    loading.value = true;
    dashboardController.loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };
        await APIService.getRequest(
                url: AppUrls.GET_CATEGORIES, headers: headers)
            .then((response) async {
          if (response != '[]') {
            categories.addAll(List<GetCategory>.from(
                json.decode(response).map((x) => GetCategory.fromJson(x))));
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
    dashboardController.loading.value = false;
  }

  // category name
  String setCategoryName(String catId) {
    categories.forEach((element) {
      if (element.catId == catId) {
        categoryName.value = element.catName.toString();
      }
    });
    return categoryName.value;
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
