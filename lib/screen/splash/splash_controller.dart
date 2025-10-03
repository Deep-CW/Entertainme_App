import 'package:get/get.dart';

import '../../constant/app_constants.dart';
import '../../main.dart';
import '../consumer/business/home/home_screen.dart';
import '../consumer/consumer_screen.dart';
import '../consumer/customer/dashboard/dashboard_screen.dart';

class SplashController extends GetxController {
  move() async {
    bool isLogin = box.read(AppConstants.IS_LOGIN) ?? false;
    bool isUser = box.read(AppConstants.IS_USER) ?? false;

    Future.delayed(const Duration(seconds: 3), () {
      if (isLogin) {
        if (isUser) {
          Get.off(() => const DashBoardScreen());
        } else {
          Get.off(() => const HomeScreen());
        }
      } else {
        Get.off(() => const ConsumerScreen());
      }
    });
  }
}
