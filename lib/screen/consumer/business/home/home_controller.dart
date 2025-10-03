import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../main.dart';
import '../../../../models/business_model/dashboard_model.dart';
import '../../../../models/business_model/get_offer_model.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/app_snackbar.dart';

class HomeController2 extends GetxController {
  RxBool loading = false.obs;
  RxBool activeValue = true.obs;
  RxBool purchased = false.obs;
  RxBool scrollUp = false.obs;

  final switchController = ValueNotifier<bool>(false);
  late RefreshController homeRefreshController;

  RxList<GetOffer> offers = <GetOffer>[].obs;
  RxList<GetOffer> products = <GetOffer>[].obs;

  RxString profileImage = "${box.read(AppConstants.PROFILE_IMG)}".obs;

  RxString ratingCount = ''.obs;
  RxString averageRating = ''.obs;
  RxString profileView = ''.obs;
  RxString expiresIn = ''.obs;

  DashboardModel dashboardModel = DashboardModel();

  @override
  void dispose() {
    super.dispose();

    homeRefreshController.dispose();
  }

  //get dashboard detail
  getDashboardDetail() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        await APIService.getRequest(
                url:
                    "${AppUrls.BUSINESS_DASHBOARD_DETAIL}${box.read(AppConstants.BUSINESS_OWNER_ID).toString()}",
                headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData["message"] == null) {
            if (response != null) {
              dashboardModel = DashboardModel.fromJson(jsonDecode(response));
              ratingCount.value = dashboardModel.ratingCount.toString();
              averageRating.value =
                  dashboardModel.averateRating!.toStringAsFixed(1);
              profileView.value = dashboardModel.profileViews.toString();
            }
          } else {
            appSnackbar(content: responseData["message"], error: true);
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
    await getOffers();
    await getPurchase();

    loading.value = false;
  }

  //rating ratio
  getRatingRatio() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'authorization': 'Bearer ${box.read(AppConstants.TOKEN).toString()}',
        };

        await APIService.getRequest(
                url: AppUrls.BUSINESS_RATING, headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);
          print(responseData.toString());
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

  getPurchase() async {
    try {
      if (APIService.internet) {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        await APIService.getRequest(
                url:
                    "${AppUrls.BUSINESS_VALIDITY_STATUS}${box.read(AppConstants.BUSINESS_OWNER_ID).toString()}",
                headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData['subscription_status']) {
            purchased.value = true;
            expiresIn.value = responseData['expires_in'];
          } else {
            purchased.value = false;
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

  //get Offers
  getOffers({bool loader = true}) async {
    loading.value = loader;

    try {
      if (APIService.internet) {
        offers.value = [];
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        await APIService.getRequest(
                url:
                    "${AppUrls.BUSINESS_OFFERS}/${box.read(AppConstants.BUSINESS_OWNER_ID).toString()}",
                headers: headers)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData is List) {
            if (response != '[]') {
              offers.addAll(List<GetOffer>.from(
                  json.decode(response).map((x) => GetOffer.fromJson(x))));

              getActiveOffer();
            }
          } else {
            appSnackbar(content: "Failed To Get Offer.", error: true);
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

  //get active offer
  getActiveOffer() {
    products.value = [];

    if (activeValue.value) {
      for (int i = 0; i < offers.length; i++) {
        if (offers[i].status == "active" &&
            offers[i].approvalStatus == "approved") {
          // Show only active products
          // products.value =
          //     offers.where((product) => product.status == "active").toList();
          products.add(offers[i]);
        }
      }
    } else {
      // Show all products
      // products.value = offers;
      for (int i = 0; i < offers.length; i++) {
        if (offers[i].status == "inactive" ||
            offers[i].approvalStatus == "pending" ||
            offers[i].approvalStatus == "rejected") {
          // Show only active products
          // products.value =
          //     offers.where((product) => product.status == "inactive").toList();
          products.add(offers[i]);
        }
      }
    }
  }

  //get offer days
  String getDays(String date) {
    String getDate = date;
    DateTime dateTime = DateTime.parse(getDate);
    DateTime now = DateTime.now();
    int differenceInDays = (dateTime.difference(now).inHours / 24).round();

    // DateTime targetDate = DateTime.parse(date);
    // DateTime today = DateTime.now();

    // Duration difference = targetDate.difference(today);

    return differenceInDays.toString();
  }

  String getDaysLeft(int days) {
    DateTime now = DateTime.now();
    DateTime futureDate = now.add(Duration(days: days));
    String formattedDate = DateFormat('d MMMM').format(futureDate);
    return formattedDate;
  }

  String activeTill(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat dateFormat = DateFormat('d MMMM');
    String formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }
}
