
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';

class CustomRadioWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;

  CustomRadioWidget(
      {required this.value,
      required this.groupValue,
      required this.onChanged,
      this.width = 32,
      this.height = 32});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(this.value);
      },
      child: Container(
        height: this.height,
        width: this.width,
        decoration:const ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: Center(
          child: Container(
            height: this.height - 2,
            width: this.width - 2,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              shape:const CircleBorder(),
              color: value == groupValue
                  ? AppColors.customerMain
                  : AppColors.white,
            ),
            child: Icon(
              Icons.done,
              color: AppColors.white,
              size: 10.h,
            ),
          ),
        ),
      ),
    );
  }
}
