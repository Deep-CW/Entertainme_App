// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../constant/app_assets.dart';
import '../constant/app_colors.dart';
import '../widgets/app_text.dart';

import 'package:http/http.dart' as http;

class APIService {
  static bool internet = false;
  static List queue = [];

//Post API Request
  static postRequest({
    required String url,
    required Map<String, String> headers,
    var body,
  }) async {
    if (internet) {
      Uri uri = Uri.parse(url);

      var response = await http.post(
        uri,
        body: body,
        headers: headers,
      );
      return response;
    } else {
      queue.add(
        postRequest(
          url: url,
          headers: headers,
          body: body,
        ),
      );
    }
  }

//Get API Request
  static getRequest({
    required String url,
    required Map<String, String> headers,
    Map<String, String>? body,
  }) async {
    Uri uri = Uri.parse(url);
    var request = http.Request('GET', uri);
    request.headers.addAll(headers);

    if (body != null) {
      request.bodyFields = body;
    }
    http.StreamedResponse response = await request.send();
    return await response.stream.bytesToString();
  }

  //Delete API Request
  static delRequest({
    required String url,
  }) async {
    var request = http.Request('DELETE', Uri.parse(url));
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return await response.stream.bytesToString();
  }

  //Upload Image
  static uploadImage(String url, http.MultipartFile multipartFile) async {
    Uri uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
    var headers = {
      'accept': 'application/json',
      'content-type': 'multipart/form-data',
    };

    request.headers.addAll(headers);
    request.files.add(multipartFile);

    var response = await request.send();

    return await http.Response.fromStream(response);
  }

  static uploadDataImage({
    required String reqType,
    required String url,
    http.MultipartFile? multipartFile,
    Map<String, String>? headers,
    required var body,
    List<http.MultipartFile>? multipartFiles,
  }) async {
    var request = http.MultipartRequest(reqType, Uri.parse(url));
    if (multipartFile != null) {
      request.files.add(multipartFile);
    }
    if (multipartFiles != null) {
      request.files.addAll(multipartFiles);
    }
    if (headers != null) {
      request.headers.addAll(headers);
    }

    request.fields.addAll(body);

    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  static encodedImage(String url) async {
    String? encodedImage;

    try {
      final imageResponse = await http.get(Uri.parse(url));

      if (imageResponse.statusCode == 200) {
        encodedImage = base64Encode(imageResponse.bodyBytes);
      } else if (imageResponse.statusCode == 404) {
        ByteData placeholderBytes = await rootBundle.load(AppAssets.logo_img);
        Uint8List placeholderUint8List = placeholderBytes.buffer.asUint8List();
        encodedImage = base64Encode(placeholderUint8List);
      } else {
        ByteData placeholderBytes = await rootBundle.load(AppAssets.logo_img);
        Uint8List placeholderUint8List = placeholderBytes.buffer.asUint8List();
        encodedImage = base64Encode(placeholderUint8List);
      }
    } catch (error) {
      ByteData placeholderBytes = await rootBundle.load(AppAssets.logo_img);
      Uint8List placeholderUint8List = placeholderBytes.buffer.asUint8List();
      encodedImage = base64Encode(placeholderUint8List);
    }

    return encodedImage;
  }

  static storeDataLocally({
    required String fileName,
    required String data,
  }) async {
    Directory directory = await getApplicationDocumentsDirectory();
    if (!(await directory.exists())) {
      await directory.create();
    }
    String path = directory.path;
    File file = File('$path/$fileName.json');
    file.writeAsString(data);
  }

  static getDataLocally({
    required String fileName,
  }) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    File file = File('$path/$fileName.json');
    if (await file.exists()) {
      String data = await file.readAsString();

      return data;
    }
    return null;
  }

  static checkConnection(BuildContext context) {
    Connectivity().checkConnectivity().then((result) {
      if (result == ConnectivityResult.none) {
        internet = false;

        Get.showSnackbar(
          GetSnackBar(
            isDismissible: false,
            borderRadius: 5,
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            backgroundColor: AppColors.red,
            messageText: appText(
              'No internet connection',
              color: AppColors.white,
              textAlign: TextAlign.left,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            mainButton: IconButton(
              onPressed: () {
                Get.closeAllSnackbars();
              },
              icon: Icon(
                Icons.close,
                size: 18.sp,
                color: AppColors.white,
              ),
            ),
          ),
        );
      }
    });

    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        internet = false;

        Get.showSnackbar(
          GetSnackBar(
            isDismissible: false,
            borderRadius: 5,
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            backgroundColor: AppColors.red,
            messageText: appText(
              'No internet connection',
              color: AppColors.white,
              textAlign: TextAlign.left,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            mainButton: IconButton(
              onPressed: () {
                Get.closeAllSnackbars();
              },
              icon: Icon(
                Icons.close,
                size: 18.sp,
                color: AppColors.white,
              ),
            ),
          ),
        );
      } else {
        internet = true;
        Get.closeAllSnackbars();
        if (queue.isNotEmpty) {
          queue.forEach((element) async {
            await element;
          });
          print(queue.toString());
          queue.clear();
        }
      }
    });
  }
}
