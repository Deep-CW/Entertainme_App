import 'package:carousel_slider/carousel_slider.dart';

import 'package:get/get.dart';

import '../../../../constant/app_assets.dart';
import '../../../../constant/app_strings.dart';
import '../../../../models/introslide_model.dart';

class CustomerIntroController extends GetxController {
  RxInt carouselIndex = 0.obs;
  CarouselController carouselController = CarouselController();

  //screens
  List<IntroSlideModel> introSlide = [
    IntroSlideModel(
      image: AppAssets.customer_intro1_img,
      title: AppStrings.find_best_offers,
      subTitle: AppStrings.discover_trending,
    ),
    IntroSlideModel(
      image: AppAssets.customer_intro2_img,
      title: AppStrings.explore_book,
      subTitle: AppStrings.browse_categories,
    ),
    IntroSlideModel(
      image: AppAssets.customer_intro3_img,
      title: AppStrings.never_miss,
      subTitle: AppStrings.get_notifications,
    ),
  ];
}
