// ignore_for_file: avoid_init_to_null, depend_on_referenced_packages, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../constant/app_constants.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../main.dart';
import '../../../../models/business_model/add_offer_model.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/app_snackbar.dart';
import '../home/home_controller.dart';

class AddOfferController extends GetxController {
  RxBool loading = false.obs;

  RxString offerImg = ''.obs;

  TextEditingController offerTitleController = TextEditingController();
  TextEditingController offerDescriptionController = TextEditingController();
  TextEditingController offerEndDateController = TextEditingController();

  AddOffer addOfferModel = AddOffer();

  //offerTitle validation
  String? offerTitleValidation() {
    String offerTitle = offerTitleController.text.trim();

    if (offerTitle.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Offer Title',
      );
      return '';
    }

    return null;
  }

  //description validation
  String? offerDescriptionValidation() {
    String description = offerDescriptionController.text.trim();

    if (description.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Offer Description',
      );
      return '';
    }

    return null;
  }

  //enddate validation
  String? endDateValidation() {
    String endDate = offerEndDateController.text.trim();
    if (endDate.isEmpty) {
      appSnackbar(
        error: true,
        content: 'Please Enter Offer End Date',
      );
      return '';
    }
    // final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    // if (!dateRegex.hasMatch(endDate)) {
    //   appSnackbar(
    //     error: true,
    //     content: 'Please enter a date in the format yyyy-mm-dd',
    //   );
    //   return '';
    // }
    // final dateParts = endDate.split('-');
    // final day = int.parse(dateParts[2]);
    // final month = int.parse(dateParts[1]);
    // final year = int.parse(dateParts[0]);
    // final date = DateTime(year, month, day);
    // if (date.year != year || date.month != month || date.day != day) {
    //   appSnackbar(
    //     error: true,
    //     content: 'Please Enter Valid Offer End Date',
    //   );
    //   return '';
    // }
    return null;
  }

  addOffer() async {
    loading.value = true;

    try {
      if (APIService.internet) {
        HomeController2 homeController = Get.put(HomeController2());
        await homeController.getPurchase();

        if (homeController.purchased.value) {
          var multipartFile;
          var mime = lookupMimeType(offerImg.value.toString())!.split("/");
          multipartFile = await http.MultipartFile.fromPath(
            'offer_img',
            offerImg.value.toString(),
            contentType: MediaType(mime[0], mime[1]),
          );

          Map<String, String> body = {
            "owner_id": box.read(AppConstants.BUSINESS_OWNER_ID).toString(),
            "offer_title": offerTitleController.text.trim(),
            "offer_desc": offerDescriptionController.text.trim(),
            "offer_end_date": offerEndDateController.text.trim(),
          };

          await APIService.uploadDataImage(
            reqType: "POST",
            url: AppUrls.BUSINESS_ADD_OFFERS,
            multipartFile: multipartFile,
            body: body,
          ).then((response) async {
            if (response.statusCode == 200) {
              var responseData = json.decode(response.body);
              addOfferModel = AddOffer.fromJson(responseData);
              await homeController.getOffers();
              saveDetail();
              appSnackbar(content: responseData["message"]);
            } else {
              var responseData = json.decode(response.body);
              appSnackbar(content: responseData["message"], error: true);
            }
          });
        } else {
          appSnackbar(
            error: true,
            content: 'Please purchase plan',
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

    loading.value = false;
  }

  editOffer({required String offerId}) async {
    loading.value = true;

    try {
      if (APIService.internet) {
        HomeController2 homeController = Get.put(HomeController2());
        await homeController.getPurchase();

        if (homeController.purchased.value) {
          Map<String, String> body = {
            "owner_id": box.read(AppConstants.BUSINESS_OWNER_ID).toString(),
            "offer_end_date": offerEndDateController.text.trim(),
          };

          await APIService.uploadDataImage(
            reqType: "PUT",
            url: AppUrls.BUSINESS_EDIT_OFFERS + offerId,
            body: body,
          ).then((response) async {
            if (response.statusCode == 200) {
              var responseData = json.decode(response.body);
              addOfferModel = AddOffer.fromJson(responseData);
              await homeController.getOffers();
              saveDetail();
              Get.back();
              Get.back();
              appSnackbar(content: responseData["message"]);
            } else {
              var responseData = json.decode(response.body);
              appSnackbar(content: responseData["message"], error: true);
            }
          });
        } else {
          appSnackbar(
            error: true,
            content: 'Please purchase plan',
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

    loading.value = false;
  }

  //save offer detail
  saveDetail() {
    Get.back();

    offerTitleController.clear();
    offerDescriptionController.clear();
    offerEndDateController.clear();
    offerImg.value = '';
  }
}
