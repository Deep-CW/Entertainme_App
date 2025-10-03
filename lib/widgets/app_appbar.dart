import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_assets.dart';
import '../constant/app_colors.dart';
import 'app_text.dart';

PreferredSizeWidget appAppBar(
    {required String title,
    void Function()? onTap,
    List<Widget>? actions,
      Color? backgroundColor,
    String? leadingImg}) {
  return AppBar(
    backgroundColor:backgroundColor ?? AppColors.white,
    automaticallyImplyLeading: false,
    leadingWidth: 38.w,
    scrolledUnderElevation: 0.0,
    elevation: 0.0,
    leading: Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: InkWell(
        onTap: onTap,
        child: Image.asset(
          leadingImg ?? AppAssets.back_ic,
          width: 22.w,
          height: 22.h,
        ),
      ),
    ),
    centerTitle: true,
    title: appText(title,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.lightBlack),
    actions: actions,
  );
}
