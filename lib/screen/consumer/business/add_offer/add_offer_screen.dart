// ignore_for_file: sort_child_properties_last, must_be_immutable

import 'dart:io';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_colors.dart';
import '../../../../constant/app_strings.dart';
import '../../../../constant/app_urls.dart';
import '../../../../services/image_service.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_input_field.dart';
import '../../../../widgets/app_loader.dart';
import '../../../../widgets/app_network_image.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../../../widgets/app_text.dart';
import 'add_offer_controller.dart';

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({
    super.key,
  });

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  AddOfferController addOfferController = Get.put(AddOfferController());
  final GlobalKey<FormState> addOfferKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (Get.arguments != null) {
      addOfferController.offerTitleController.text = Get.arguments['title'];
      addOfferController.offerDescriptionController.text =
          Get.arguments['description'];
      addOfferController.offerEndDateController.text = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(Get.arguments['date']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          ColorfulSafeArea(
            color: AppColors.white,
            child: Scaffold(
              backgroundColor: AppColors.white,
              appBar: appAppBar(
                  title: Get.arguments != null
                      ? AppStrings.edit_offer
                      : AppStrings.add_offer,
                  onTap: () {
                    Get.back();
                  }),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Form(
                  key: addOfferKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (Get.arguments == null) {
                            var pickedImg = await ImageService.pickCropImage(
                                color: AppColors.businessMain);

                            if (pickedImg != null) {
                              addOfferController.offerImg.value = pickedImg;
                            }
                          }
                        },
                        child: Container(
                          height: 194.h,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.lightGrey,
                          ),
                          child: addOfferController.offerImg.value.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.file(
                                    File(addOfferController.offerImg.value),
                                    //  height: 194.h,
                                    width: double.maxFinite,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Get.arguments != null
                                  ? appNetworkImage(
                                      url:
                                          "${AppUrls.BASE_API}${Get.arguments['image']}",
                                      loaderColor: AppColors.businessMain,
                                      errorIconSize: 30.sp,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: double.maxFinite,
                                        height: 194.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: imageProvider),
                                        ),
                                      ),
                                    )
                                  : Image.asset(
                                      AppAssets.gallery_ic,
                                      width: 40.w,
                                      // height: 20.h,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      appText(AppStrings.offer_title,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightBlack,
                          textAlign: TextAlign.left),
                      SizedBox(
                        height: 6.h,
                      ),
                      appInputField(
                        height: 50.h,
                        hintText: AppStrings.title,
                        showSuffix: false,
                        showPrefix: false,
                        givePadding: false,
                        readOnly: Get.arguments != null,
                        controller: addOfferController.offerTitleController,
                        fillColor: AppColors.lightGrey,
                        validator: (value) {
                          return addOfferController.offerTitleValidation();
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      appText(AppStrings.offer_description,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightBlack,
                          textAlign: TextAlign.left),
                      SizedBox(
                        height: 6.h,
                      ),
                      appInputField(
                        height: 145.h,
                        hintText: AppStrings.offer_description,
                        showSuffix: false,
                        showPrefix: false,
                        givePadding: false,
                        readOnly: Get.arguments != null,
                        controller:
                            addOfferController.offerDescriptionController,
                        fillColor: AppColors.lightGrey,
                        maxLines: 300,
                        validator: (value) {
                          return addOfferController
                              .offerDescriptionValidation();
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      appText(AppStrings.offer_enddate,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightBlack,
                          textAlign: TextAlign.left),
                      SizedBox(
                        height: 6.h,
                      ),
                      appInputField(
                        height: 50.h,
                        hintText: AppStrings.offer_date_format,
                        readOnly: true,
                        showSuffix: false,
                        showPrefix: false,
                        givePadding: false,
                        controller: addOfferController.offerEndDateController,
                        fillColor: AppColors.lightGrey,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            addOfferController.offerEndDateController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                          setState(() {});
                        },
                        validator: (value) {
                          return addOfferController.endDateValidation();
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      appButton(
                          onTap: () {
                            if (Get.arguments != null) {
                              addOfferController.editOffer(
                                  offerId: Get.arguments['offerId']);
                            } else if (addOfferKey.currentState!.validate() &&
                                addOfferController.offerImg.isNotEmpty) {
                              addOfferController.addOffer();
                            } else {
                              appSnackbar(
                                  content: 'Select Offer Image.', error: true);
                            }
                          },
                          height: 61.h,
                          width: double.maxFinite,
                          buttonText: AppStrings.save,
                          buttonColor: AppColors.businessMain,
                          textColor: AppColors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: addOfferController.loading.value,
            child: appLoader(
              loaderColor: AppColors.white,
              onWillPop: false,
            ),
          ),
        ],
        alignment: Alignment.center,
      ),
    );
  }
}
