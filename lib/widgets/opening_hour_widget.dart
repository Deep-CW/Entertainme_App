import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constant/app_colors.dart';
import '../constant/app_list.dart';
import '../constant/app_strings.dart';
import 'app_text.dart';

Widget openingHourWidget(
    {required String days,
    required RxBool closeValue,
    required String openTimeText,
    required String closeTimeText,
    void Function(bool?)? onChanged,
    void Function(String?)? onChangedOpenTime,
    void Function(String?)? onChangedCloseTime}) {
  return Obx(
    () => Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appText(days,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.lightBlack),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                SizedBox(
                  height: 15.h,
                  width: 15.w,
                  child: Obx(
                    () => Checkbox(
                        value: closeValue.value,
                        activeColor: AppColors.darkRed,
                        side:
                            BorderSide(color: AppColors.lightBlack, width: 1.w),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.r),
                            side: const BorderSide(color: AppColors.darkGrey)),
                        onChanged: onChanged),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                appText(AppStrings.closed,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: closeValue.value
                        ? AppColors.darkRed
                        : AppColors.lightBlack),
              ],
            ),
          ],
        ),
        const Spacer(),
        closeValue.value
            ? const SizedBox()
            : Container(
                constraints: BoxConstraints(maxHeight: 40.h, maxWidth: 90.w),
                decoration: BoxDecoration(
                    color: AppColors.lightWhite,
                    borderRadius: BorderRadius.circular(5.r)),
                padding: EdgeInsets.zero,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    customButton: Padding(
                      padding:
                          EdgeInsets.only(top: 10.h, bottom: 10.h, left: 8.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          appText("$openTimeText ${AppStrings.AM}",
                              fontSize: 12.sp,
                              color: AppColors.lightBlack,
                              fontWeight: FontWeight.w600),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),
                    iconStyleData: const IconStyleData(
                        icon: SizedBox(),
                        iconDisabledColor: AppColors.lightBlack,
                        iconEnabledColor: AppColors.lightBlack),
                    hint: appText("$openTimeText ${AppStrings.AM}",
                        fontSize: 12.sp,
                        color: AppColors.lightBlack,
                        fontWeight: FontWeight.w600),
                    items: AppList.timeList
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: appText(item,
                                  fontSize: 12.sp,
                                  color: AppColors.lightBlack,
                                  fontWeight: FontWeight.w600),
                            ))
                        .toList(),
                    value: openTimeText,
                    onChanged: onChangedOpenTime,
                  ),
                ),
              ),
        SizedBox(
          width: 10.w,
        ),
        closeValue.value
            ? const SizedBox()
            : Container(
                constraints: BoxConstraints(maxHeight: 40.h, maxWidth: 90.w),
                decoration: BoxDecoration(
                    color: AppColors.lightWhite,
                    borderRadius: BorderRadius.circular(5.r)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                      isExpanded: true,
                      customButton: Padding(
                        padding:
                            EdgeInsets.only(top: 10.h, bottom: 10.h, left: 8.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            appText("$closeTimeText ${AppStrings.PM}",
                                fontSize: 12.sp,
                                color: AppColors.lightBlack,
                                fontWeight: FontWeight.w600),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 18.sp,
                            ),
                          ],
                        ),
                      ),
                      iconStyleData: const IconStyleData(
                          icon: SizedBox(),
                          iconDisabledColor: AppColors.lightBlack,
                          iconEnabledColor: AppColors.lightBlack),
                      hint: appText("$closeTimeText ${AppStrings.PM}",
                          fontSize: 12.sp,
                          color: AppColors.lightBlack,
                          fontWeight: FontWeight.w600),
                      items: AppList.timeList
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: appText(item,
                                    fontSize: 12.sp,
                                    color: AppColors.lightBlack,
                                    fontWeight: FontWeight.w600),
                              ))
                          .toList(),
                      value: closeTimeText,
                      onChanged: onChangedCloseTime),
                ),
              ),
      ],
    ),
  );
}
