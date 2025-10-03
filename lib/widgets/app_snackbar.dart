// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

import '../constant/app_colors.dart';

appSnackbar({
  required String content,
  bool error = false,
  String? title,
  SnackPosition? snackPosition,
}) {
  Get.snackbar(
    title ?? 'Message',
    content,
    backgroundColor: error ? AppColors.red : AppColors.green,
    colorText: AppColors.white,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(seconds: 2),
    snackPosition: snackPosition,
  );
}
