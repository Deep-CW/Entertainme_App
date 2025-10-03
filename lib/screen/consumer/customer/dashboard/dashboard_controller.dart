import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../favourite/favourite_screen.dart';
import '../home/home_screen.dart';
import '../notification/notification_screen.dart';
import '../profile/profile_screen.dart';

class DashBoardController extends GetxController {
  RxBool loading = false.obs;
  TabController? tabController;
  var currentTab = 0.obs;

  List<Widget> screens = [
    const HomeScreen(),
    const FavouriteScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];
}
