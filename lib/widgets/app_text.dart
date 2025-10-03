// ignore_for_file: non_constant_identifier_names


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';


Widget appText(String text,
    {TextOverflow? overflow,
    TextAlign? textAlign,
    TextDecoration? decoration,
    int? maxLines,
    double? height,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
      Color? decorationColor,
    String? fontFamily}) {
  return Text(
    text,
    overflow: overflow,
    softWrap: true,
    maxLines: maxLines,
    textAlign: textAlign ?? TextAlign.center,
    style: TextStyle(
        decoration: decoration,
        decorationColor: decorationColor,
        height: height,
        fontSize: fontSize ?? 12.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.white,
        fontFamily: fontFamily ?? 'Urbanist'),
  );
}
