// ignore_for_file: unnecessary_null_comparison, prefer_conditional_assignment, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../constant/app_strings.dart';
import '../../../../../../constant/app_urls.dart';
import '../../../../../../services/api_service.dart';
import '../../../../../../services/google_map_service.dart';
import '../../../../../../widgets/app_snackbar.dart';

import 'package:http/http.dart' as http;

class CategoryLocationController extends GetxController {
  RxString placeName = ''.obs;
  var uuid = const Uuid();
  String sessionToken = "";
  RxList<dynamic> placeList = <dynamic>[].obs;

  int? choice;

  double lat = 0.0;
  double lng = 0.0;

  TextEditingController locationController = TextEditingController();

  //change id location
  onChangedLocation() {
    if (sessionToken == null) {
      sessionToken = uuid.v4();
    }

    getSuggestion(locationController.text);
  }

  //get suggestion of location
  void getSuggestion(String input) async {
    try {
      if (APIService.internet) {
        String placesApiKey = AppUrls.kGoogleApiKey;
        String types = 'establishment';
        String request =
            '${AppUrls.LOCATION_CITY_API}?input=$input&types=$types&key=$placesApiKey&sessiontoken=$sessionToken';
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

  getLatLng(String placeId) async {
    try {
      if (APIService.internet) {
        final placeDetails = await PlaceApi().getPlaceDetails(placeId);

        if (placeDetails != null) {
          final latLng = placeDetails['result']['geometry']['location'];

          lat = latLng['lat'];
          lng = latLng['lng'];
          Get.back(result: {
            "location": placeName.value.toString(),
            "lat": lat,
            "lng": lng
          });
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
}
