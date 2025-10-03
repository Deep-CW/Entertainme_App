import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/app_colors.dart';
import '../../../../constant/app_strings.dart';
import '../../../../widgets/app_appbar.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: AppColors.white,
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        appBar: appAppBar(
          backgroundColor: AppColors.lightGrey,
          onTap: () {
            Get.back();
          },
          title: AppStrings.ratings,
        ),
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
