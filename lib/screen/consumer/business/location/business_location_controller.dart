// ignore_for_file: unnecessary_null_comparison, prefer_conditional_assignment, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../services/api_service.dart';
import '../../../../services/google_map_service.dart';
import '../../../../widgets/app_snackbar.dart';

class BusinessLocationController extends GetxController {
  RxString placeName = ''.obs;
  var uuid = const Uuid();
  String sessionToken = "";
  RxList<dynamic> placeList = <dynamic>[].obs;

  double lat = 0.0;
  double lng = 0.0;

  int? choice;

  TextEditingController locationController = TextEditingController();

  //change id location
  onChangedLocation() {
    if (APIService.internet) {
      if (sessionToken == null) {
        sessionToken = uuid.v4();
      }
      getSuggestion(locationController.text);
    } else {
      appSnackbar(
        error: true,
        content: AppStrings.no_internet,
      );
    }
  }

  //get suggestion of location
  void getSuggestion(String input) async {
    try {
      String placesApiKey = AppUrls.kGoogleApiKey;
      String types = 'establishment';
      String request =
          '${AppUrls.LOCATION_CITY_API}?input=$input&types=$types&key=$placesApiKey&sessiontoken=$sessionToken';
      var response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        placeList.value = json.decode(response.body)['predictions'];

        // PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
        //  final lat = detail.result.geometry.location.lat;
        //  final lng = detail.result.geometry.location.lng;
      } else {
        throw Exception('Failed to load predictions');
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
        // final placeId = placeList[0]['place_id'];

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
          //   _selectedPlace = placeDetails['result']['name'];
          // _latitude = latLng['lat'];
          //  _longitude = latLng['lng'];
          //   }
          // );
          // }
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
