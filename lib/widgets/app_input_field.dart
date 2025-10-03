import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';

//add keyboard type
Widget appInputField(
    {required double height,
    required String hintText,
    String? prefixImg,
    String? suffixImg,
    Key? key,
    required bool showSuffix,
    required bool showPrefix,
    required TextEditingController? controller,
    String? Function(String?)? validator,
    void Function()? visibleTap,
    void Function()? onTap,
    TextInputType? keyboardType,
    bool givePadding = true,
    bool readOnly = false,
    Color? fillColor,
    Decoration? decoration,
    Color? prefixColor,
    int? maxLines,
    List<TextInputFormatter>? inputFormatters,
    void Function(String)? onChanged,
    bool? visiblePassword = false}) {
  return Padding(
    padding:
        givePadding ? EdgeInsets.symmetric(horizontal: 16.w) : EdgeInsets.zero,
    child: Container(
      height: height,
      width: double.maxFinite,
      decoration: decoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
          ),
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: TextFormField(
        key: key,
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines ?? 1,
        style: TextStyle(
          color: AppColors.lightBlack,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AppColors.lightBlack,
        keyboardType: keyboardType,
        obscureText: visiblePassword!,
        validator: validator,
        onTap: onTap,
        textAlign: TextAlign.start,
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: fillColor ?? AppColors.lightGrey,
          errorStyle: const TextStyle(height: 0),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGrey),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColors.red),
          ),
          prefixIcon: showPrefix == true
              ? Padding(
                  padding: EdgeInsets.all(15.r),
                  child: Image.asset(
                    prefixImg.toString(),
                    height: 16.h,
                    width: 14.w,
                    color: prefixColor ?? null,
                  ),
                )
              : null,
          suffixIcon: showSuffix == true
              ? suffixImg == null
                  ? InkWell(
                      onTap: visibleTap,
                      child: Padding(
                          padding: EdgeInsets.only(right: 20.r),
                          child: visiblePassword == false
                              ? Icon(
                                  Icons.visibility_rounded,
                                  color: AppColors.lightBlack.withOpacity(0.5),
                                )
                              : Icon(
                                  Icons.visibility_off_rounded,
                                  color: AppColors.lightBlack.withOpacity(0.5),
                                )),
                    )
                  : Padding(
                      padding: EdgeInsets.all(15.r),
                      child: InkWell(
                        onTap: visibleTap,
                        child: Image.asset(
                          suffixImg.toString(),
                          width: 15.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
              : null,
        ),
        inputFormatters: inputFormatters,
      ),
    ),
  );
}
