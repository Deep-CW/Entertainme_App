// ignore_for_file: avoid_function_literals_in_foreach_calls, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import '../../../../constant/app_constants.dart';
import '../../../../constant/app_list.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../main.dart';
import '../../../../services/api_service.dart';
import '../../../../widgets/app_snackbar.dart';
import '../home/home_controller.dart';

class SubscriptionController extends GetxController {
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? subscription;
  RxBool loading = false.obs;
  RxInt selectSubscription = 1.obs;

  //get saving
  getSaving() async {
    for (var item in AppList.subscriptionList) {
      String save = '';
      int duration = int.parse(item['days']) ~/ 30;
      int totalCost =
          (int.parse(AppList.subscriptionList[0]['price']) * duration).toInt();
      int saving = (totalCost - int.parse(item['price'])).toInt();
      int percentage = ((saving / totalCost) * 100).toInt();
      save = percentage == 0 ? '' : percentage.toString();
      item['save'] = save;
    }
  }

  //get products
  getProducts() async {
    loading.value = true;

    if (APIService.internet) {
      Set<String> identifiers = {};

      for (var item in AppList.subscriptionList) {
        identifiers.add(item['id']);
      }

      ProductDetailsResponse response =
          await inAppPurchase.queryProductDetails(identifiers);
      var productDetails = response.productDetails;

      if (productDetails.isNotEmpty) {
        for (var item in AppList.subscriptionList) {
          var cc = productDetails.where((element) {
            if (element.id == item['id']) {
              item['price'] = element.price;
            }
            return element.id == item['id'];
          });
          print(cc.toString());
        }
      } else {
        appSnackbar(
          error: true,
          content: 'Package not found',
        );
      }
    } else {
      appSnackbar(
        error: true,
        content: AppStrings.no_internet,
      );
    }

    loading.value = false;
  }

  //add purchase to firestore
  addPurchase() async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      var body = {
        'business_owner_id':
            box.read(AppConstants.BUSINESS_OWNER_ID).toString(),
        'amount': AppList.subscriptionList[selectSubscription.value]['amount'],
        'days': AppList.subscriptionList[selectSubscription.value]['days'],
      };

      await APIService.postRequest(
        url: AppUrls.BUSINESS_ADD_PURCHASE,
        headers: headers,
        body: body,
      ).then((response) async {
        var responseData = await jsonDecode(await response.body);

        await Get.put(HomeController2()).getPurchase();
        Get.back();

        if (responseData['message'] !=
            'Subscription payment saved successfully.') {
          appSnackbar(
            error: true,
            content: 'Error while saving purchase data',
          );
        }
      });
    } catch (error) {
      appSnackbar(
        error: true,
        content: error.toString(),
      );
    }
  }

  //purchase package
  purchasePackage() async {
    loading.value = true;

    if (APIService.internet) {
      bool available = await inAppPurchase.isAvailable();

      if (available) {
        if (Platform.isIOS) {
          var paymentWrapper = SKPaymentQueueWrapper();
          var transactions = await paymentWrapper.transactions();
          transactions.forEach((transaction) async {
            await paymentWrapper
                .finishTransaction(transaction)
                .catchError((onError) {});
          });
        }

        final ProductDetailsResponse response = await inAppPurchase
            .queryProductDetails(
                {AppList.subscriptionList[selectSubscription.value]['id']});

        final PurchaseParam purchaseParam =
            PurchaseParam(productDetails: response.productDetails.first);

        await inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } else {
      appSnackbar(
        error: true,
        content: AppStrings.no_internet,
      );
    }
  }

  //add purchase listner
  purchaseUpdate() async {
    final purchaseStream = inAppPurchase.purchaseStream;
    subscription = purchaseStream.listen((purchaseDetailsList) async {
      await listenToPurchaseUpdate(purchaseDetailsList);
    });
  }

  //listner of purchase update
  listenToPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    purchaseDetailsList.forEach((purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.error) {
        loading.value = false;
        appSnackbar(
          error: true,
          content: purchaseDetails.error!.message.toString(),
        );
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        loading.value = false;
        appSnackbar(
          error: true,
          content: 'Purchase cancelled',
        );
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        await inAppPurchase.completePurchase(purchaseDetails);
        if (loading.value) {
          await addPurchase();
        }
        loading.value = false;
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        loading.value = true;
        appSnackbar(content: "Purchase restored");
      }
    });
  }
}
