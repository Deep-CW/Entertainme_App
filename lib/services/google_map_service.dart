import 'package:geolocator/geolocator.dart';

import '../constant/app_urls.dart';
import '../widgets/app_snackbar.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleMapService {
  //permission for image
  static checkLocationPermission() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    } else if (permission == LocationPermission.denied) {
      var per = await Geolocator.requestPermission();

      if (per == LocationPermission.denied ||
          per == LocationPermission.deniedForever) {
        if (per == LocationPermission.deniedForever) {
          appSnackbar(error: true, content: 'Please allow location permission');
          Geolocator.openAppSettings();
          return false;
        }
        return await checkLocationPermission();
      } else {
        return true;
      }
    } else if (permission == LocationPermission.deniedForever) {
      appSnackbar(error: true, content: 'Please allow  location permission');
      Geolocator.openAppSettings();
      return false;
    }
  }
}

class PlaceApi {
  static String _apiKey = AppUrls.kGoogleApiKey;
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  Future<dynamic> autocomplete(String input) async {
    final url = '$_baseUrl/autocomplete/json?input=$input&key=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<dynamic> getPlaceDetails(String placeId) async {
    final url = '$_baseUrl/details/json?placeid=$placeId&key=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load place details');
    }
  }
}
