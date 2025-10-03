import 'package:carousel_slider/carousel_slider.dart';

import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_strings.dart';
import '../../../../models/introslide_model.dart';

class BusinessIntroController extends GetxController {
  RxInt carouselIndex = 0.obs;
  CarouselController carouselController = CarouselController();

  //screens
  List<IntroSlideModel> introSlide = [
    IntroSlideModel(
      image: AppAssets.business_intro_1_img,
      title: AppStrings.boost_business,
      subTitle: AppStrings.list_business,
    ),
    IntroSlideModel(
      image: AppAssets.business_intro_2_img,
      title: AppStrings.manage_offers,
      subTitle: AppStrings.create_deals,
    ),
    IntroSlideModel(
      image: AppAssets.business_intro_3_img,
      title: AppStrings.track_performance,
      subTitle: AppStrings.monitor_bookings,
    ),
  ];
}
