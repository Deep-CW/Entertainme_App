import 'dart:convert';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../main.dart';
import '../../../../models/customer_model/notification_model.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/app_snackbar.dart';
import '../dashboard/dashboard_controller.dart';
import '../home/category/category_controller.dart';

import '../home/category/category_seeall_screen.dart';
import '../home/neartoyou/neartoyou_controller.dart';
import '../home/neartoyou/show_neartoyou_screen.dart';

class NotificationController extends GetxController {
  RxBool loading = false.obs;
  RefreshController notificationRefreshController = RefreshController();
  final dashboardController = Get.put(DashBoardController());

  RxList<Datum> notifications = <Datum>[].obs;

  @override
  void onInit() {
    super.onInit();

    getNotification();
  }

  // get notifications
  getNotification() async {
    loading.value = true;
    dashboardController.loading.value = true;

    try {
      if (APIService.internet) {
        notifications.clear();
        Map<String, String> header = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };
        await APIService.getRequest(
                url:
                    "${AppUrls.GET_NOTIFICATION}${box.read(AppConstants.USER_ID.toString())}",
                headers: header)
            .then((response) async {
          var responseData = await jsonDecode(await response);

          if (responseData["message"] == null) {
            if (response != '[]') {
              Map<String, dynamic> parsedJson = jsonDecode(response);
              List<dynamic> data = parsedJson['data'];

              notifications.value =
                  List<Datum>.from(data.map((item) => Datum.fromJson(item)));
            } else {
              appSnackbar(content: "No Notification Found.", error: true);
            }
          } else {
            appSnackbar(content: "Failed To Get Notification.", error: true);
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

  // open notification
  openNotification(String notificationType,
      {BusinessDetails? businessDetails, String? ownerId}) {
    if (APIService.internet) {
      //if notification type category
      if (notificationType == "new_category") {
        Get.put(CategoryController()).categories.value = [];
        Get.put(CategoryController()).getCategory();
        Get.put(CategoryController()).getAllBusiness();

        Get.to(() => const CategorySeeAllScreen(), arguments: {
          "current_index": 0,
          "category_name": "",
          "category_id": ""
        });
      }
      // if notification type business
      else if (notificationType == "new_business") {
        getBusinessDetail(businessDetails!, ownerId.toString());
      }
      //if notification type offer
      else if (notificationType == "new_offer") {
        getBusinessDetail(businessDetails!, ownerId.toString());
        Get.put(NearToTouController()).currentTab.value = 1;
        Get.put(NearToTouController()).getBusinessOffer();
      }
    } else {
      appSnackbar(
        error: true,
        content: AppStrings.no_internet,
      );
    }
  }

  getBusinessDetail(BusinessDetails businessDetails, String ownerId) {
    Get.to(() => const ShowNearToYouScreen(), arguments: {
      "from": "notification",
      "business_id": businessDetails.id.toString(),
      "owner_id": businessDetails.businessOwner.ownerId.toString(),
      "business_name": businessDetails.businessName.toString(),
      "business_Detail": businessDetails.businessDetail.toString(),
      "business_location": businessDetails.city.toString(),
      "country_code": businessDetails.businessOwner.countryCode.toString(),
      "phone_number": businessDetails.businessOwner.phoneNumber.toString(),
      "business_images": businessDetails.businessImages,
      "business_profile": businessDetails.businessOwner.ownerImg.toString(),
      "ratings": businessDetails.averageRating!,
      "rating_count": businessDetails.ratingCount.toString(),
      "rated": businessDetails.userHasRated,
      "favorite": businessDetails.isFavorite,
      "lat": businessDetails.businessLocation.coordinates[1],
      "lng": businessDetails.businessLocation.coordinates[0],
      "opening_hours_1": businessDetails.openingHours1,
      "opening_hours_2": businessDetails.openingHours2,
      "opening_hours_3": businessDetails.openingHours3,
      "opening_hours_4": businessDetails.openingHours4,
      "opening_hours_5": businessDetails.openingHours5,
      "opening_hours_6": businessDetails.openingHours6,
      "opening_hours_7": businessDetails.openingHours7,
    });
  }
}
