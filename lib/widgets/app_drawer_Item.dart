import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';
import 'app_text.dart';

Widget appDrawerItem(
    {required String title,
    required String image,
    double? fontSize,
    Color? textColor,
    Color? imageColor,
    void Function()? onTap,
    Widget? trailing}) {
  return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
      minLeadingWidth: 10.w,
      onTap: onTap,
      leading: Image.asset(
        image,
        color: imageColor ?? AppColors.lightBlack,
        width: 20.w,
        fit: BoxFit.cover,
      ),
      title: appText(title,
          fontSize: fontSize ?? 18.sp,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppColors.lightBlack,
          textAlign: TextAlign.left),
      trailing: trailing);
}
