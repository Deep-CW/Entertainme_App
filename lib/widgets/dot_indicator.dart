// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget DotIndicator({
   Color? activeColor,
   Color? inActivecolor,
  bool isActive = false,
  double? gap,
  Gradient? activeGradient,
  Gradient? inactiveGradient,
}) {
  return Padding(
    padding: EdgeInsets.only(right: gap ?? 5.w),
    child: Container(
      height: 12.h,
      width: 12.w,
      decoration: BoxDecoration(
      shape: BoxShape.circle,
        color: isActive ? activeColor : inActivecolor,
      ),
    ),
  );
}
