import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget appChips(
    {required List<String> value,
    required Function(List<String>) onChanged,
    required List<String> chipList,
    double? fontSize,
    FontWeight? fontWeight,
    Color? selectColor,
    Color? unselecteColor,
    Color? unselecteFillColor,
    Color? selectFillColor,
    Axis? direction,
    double? height,
    Decoration? decoration,
    ScrollController? scrollController}) {
  return Container(
    decoration: decoration,
    constraints: BoxConstraints(maxHeight: height ?? 70.h),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ChipsChoice<String>.multiple(
        value: value,
        onChanged: onChanged,
        direction: Axis.vertical,
        choiceItems: C2Choice.listFrom<String, String>(
          source: chipList,
          value: (i, v) => i.toString(),
          label: (i, v) => v,
          tooltip: (i, v) => v,
        ),
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        wrapCrossAlignment: WrapCrossAlignment.start,
        choiceCheckmark: false,
        padding: EdgeInsets.zero,
        choiceStyle: C2ChipStyle.filled(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
          backgroundOpacity: 1.0,
          color: unselecteFillColor,
          borderRadius: BorderRadius.circular(50.r),
          borderStyle: BorderStyle.solid,
          foregroundStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: unselecteColor,
              fontFamily: 'Urbanist'),
          selectedStyle: C2ChipStyle.filled(
            color: selectFillColor,
            backgroundOpacity: 1.0,
            borderRadius: BorderRadius.circular(50.r),
            foregroundStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: selectColor,
                fontFamily: 'Urbanist'),
          ),
        ),
        wrapped: true,
      ),
    ),
  );
}

Widget appChip({
  required String value,
  required Function(String) onChanged,
  required List<Map<String, dynamic>> chipList,
  double? fontSize,
  FontWeight? fontWeight,
  Color? selectColor,
  Color? unselecteColor,
  Color? unselecteFillColor,
  Color? selectFillColor,
  Axis? direction,
  double? height,
  Decoration? decoration,
  ScrollController? scrollController,
}) {
  return Container(
    decoration: decoration,
    constraints: BoxConstraints(maxHeight: height ?? 70.h),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ChipsChoice<String>.single(
        value: value,
        onChanged: onChanged,
        direction: direction ?? Axis.vertical,
        choiceItems: C2Choice.listFrom<String, dynamic>(
          source: chipList,
          value: (i, v) => v["id"],
          label: (i, v) => v["name"],
          tooltip: (i, v) => v["name"],
        ),
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        wrapCrossAlignment: WrapCrossAlignment.start,
        choiceCheckmark: false,
        padding: EdgeInsets.zero,
        choiceStyle: C2ChipStyle.filled(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
          backgroundOpacity: 1.0,
          color: unselecteFillColor,
          borderRadius: BorderRadius.circular(50.r),
          borderStyle: BorderStyle.solid,
          foregroundStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: unselecteColor,
              fontFamily: 'Urbanist'),
          selectedStyle: C2ChipStyle.filled(
            color: selectFillColor,
            backgroundOpacity: 1.0,
            borderRadius: BorderRadius.circular(50.r),
            foregroundStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: selectColor,
                fontFamily: 'Urbanist'),
          ),
        ),
        wrapped: true,
      ),
    ),
  );
}

Widget appChip9({
  required String value,
  required Function(String) onChanged,
  required List<Map<String, dynamic>> chipList,
  double? fontSize,
  FontWeight? fontWeight,
  Color? selectColor,
  Color? unselecteColor,
  Color? unselecteFillColor,
  Color? selectFillColor,
  Axis? direction,
  double? height,
  Decoration? decoration,
  ScrollController? scrollController,
}) {
  return Container(
    decoration: decoration,
    constraints: BoxConstraints(maxHeight: height ?? 70.h),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ChipsChoice<String>.single(
        value: value,
        onChanged: onChanged,
        direction: Axis.vertical,
        choiceItems: C2Choice.listFrom<String, dynamic>(
          source: chipList,
          value: (i, v) => v["id"],
          label: (i, v) => v["name"],
          tooltip: (i, v) => v["name"],
        ),
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        wrapCrossAlignment: WrapCrossAlignment.start,
        choiceCheckmark: false,
        padding: EdgeInsets.zero,
        choiceStyle: C2ChipStyle.filled(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
          backgroundOpacity: 1.0,
          color: unselecteFillColor,
          borderRadius: BorderRadius.circular(50.r),
          borderStyle: BorderStyle.solid,
          foregroundStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: unselecteColor,
              fontFamily: 'Urbanist'),
          selectedStyle: C2ChipStyle.filled(
            color: selectFillColor,
            backgroundOpacity: 1.0,
            borderRadius: BorderRadius.circular(50.r),
            foregroundStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: selectColor,
                fontFamily: 'Urbanist'),
          ),
        ),
        wrapped: true,
      ),
    ),
  );
}
