import 'package:colorful_safe_area/colorful_safe_area.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_strings.dart';
import '../../../services/google_map_service.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import 'dashboard/dashboard_controller.dart';
import 'dashboard/dashboard_screen.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: AppColors.white,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          leadingWidth: 38.w,
          scrolledUnderElevation: 0.0,
          elevation: 0.0,
          centerTitle: true,
          title: appText(AppStrings.location_permission,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.lightBlack),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appText(AppStrings.location_permission_text,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightBlack,
                  textAlign: TextAlign.center),
              SizedBox(
                height: 50.h,
              ),
              appButton(
                  onTap: () async {
                    await GoogleMapService.checkLocationPermission()
                        .then((value) {
                      Get.delete<DashBoardController>();
                      Get.put(DashBoardController());
                      Get.offAll(() => const DashBoardScreen());
                    });
                  },
                  height: 50.h,
                  width: double.maxFinite,
                  buttonText: "Allow Permission",
                  buttonColor: AppColors.customerMain)
            ],
          ),
        ),
      ),
    );
  }
}
