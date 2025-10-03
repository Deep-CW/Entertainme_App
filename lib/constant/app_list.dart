import 'app_assets.dart';
import 'app_strings.dart';

class AppList {
  static List favouriteList = [
    {
      'title': AppStrings.food_shop,
      'category': AppStrings.food,
      'image': AppAssets.food_shop_img
    },
    {
      'title': AppStrings.gym,
      'category': AppStrings.fitness,
      'image': AppAssets.gym_img
    },
    {
      'title': AppStrings.salon,
      'category': AppStrings.beauty,
      'image': AppAssets.salon_shop_img
    },
    {
      'title': AppStrings.cloth_shop,
      'category': AppStrings.fashion,
      'image': AppAssets.cloth_shop_img
    },
    {
      'title': AppStrings.food_shop,
      'category': AppStrings.food,
      'image': AppAssets.food_shop_img
    },
    {
      'title': AppStrings.gym,
      'category': AppStrings.fitness,
      'image': AppAssets.gym_img
    },
    {
      'title': AppStrings.salon,
      'category': AppStrings.beauty,
      'image': AppAssets.salon_shop_img
    },
    {
      'title': AppStrings.cloth_shop,
      'category': AppStrings.fashion,
      'image': AppAssets.cloth_shop_img
    },
  ];

  static List<String> daysList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static List<String> timeList = [
    '1:00',
    '2:00',
    '3:00',
    '4:00',
    '5:00',
    '6:00',
    '7:00',
    '8:00',
    '9:00',
    '10:00',
    '11:00',
    '12:00'
  ];

  static List<Map<String, dynamic>> openHour = [
    {
      "day": "Monday",
      "open_time": '01:00',
      "close_time": '01:00',
      "open": false
    }
  ];

  static List<String> selectedTag = [
    'Food',
    'Drinks',
    'Beauty',
    'Food1',
    'Drinks1',
    'Beauty1',
    'Food2',
    'Drink2',
    'Beauty2',
    'Food3',
    'Drinks3',
    'Beauty3',
  ];
  static List<Map<String, dynamic>> selectedTag1 = [
    {'id': '1', 'name': 'Nearest'},
    {'id': '2', 'name': 'Top Rated'},
    {'id': '3', 'name': 'New'},
  ];

  static List<String> tabList = [
    AppStrings.food_drink,
    AppStrings.beauty_spa,
    AppStrings.health_fitness,
    AppStrings.attraction,
    AppStrings.fashion_retail,
    AppStrings.services,
    AppStrings.pets_clinics,
    AppStrings.plants,
    AppStrings.hardware,
    AppStrings.toys,
  ];

  static List categoryList = [
    {
      'title': AppStrings.food_shop,
      'category': AppStrings.food,
      'image': AppAssets.food_shop_img
    },
    {
      'title': AppStrings.gym,
      'category': AppStrings.fitness,
      'image': AppAssets.gym_img
    },
    {
      'title': AppStrings.salon,
      'category': AppStrings.beauty,
      'image': AppAssets.salon_shop_img
    },
    {
      'title': AppStrings.cloth_shop,
      'category': AppStrings.fashion,
      'image': AppAssets.cloth_shop_img
    },
    {
      'title': AppStrings.food_shop,
      'category': AppStrings.food,
      'image': AppAssets.food_shop_img
    },
    {
      'title': AppStrings.gym,
      'category': AppStrings.fitness,
      'image': AppAssets.gym_img
    },
    {
      'title': AppStrings.salon,
      'category': AppStrings.beauty,
      'image': AppAssets.salon_shop_img
    },
    {
      'title': AppStrings.cloth_shop,
      'category': AppStrings.fashion,
      'image': AppAssets.cloth_shop_img
    },
  ];

  static List<String> shopImg = [
    AppAssets.shop_img,
    AppAssets.shop_img,
    AppAssets.shop_img,
    AppAssets.shop_img,
  ];

  static List latestOfferList = [
    AppAssets.first_offer_img,
    AppAssets.second_offer_img,
    AppAssets.first_offer_img,
    AppAssets.second_offer_img,
  ];
  static List categoriesList = [
    {'title': AppStrings.food_drink, 'image': AppAssets.food_img},
    {'title': AppStrings.beauty_spa, 'image': AppAssets.spa_img},
    {'title': AppStrings.health_fitness, 'image': AppAssets.health_img},
    {'title': AppStrings.attraction, 'image': AppAssets.attraction_img},
    {'title': AppStrings.fashion_retail, 'image': AppAssets.fashion_img},
    {'title': AppStrings.services, 'image': AppAssets.service_img},
    {'title': AppStrings.pets_clinics, 'image': AppAssets.pet_img},
    {'title': AppStrings.plants, 'image': AppAssets.plant_img},
    {'title': AppStrings.hardware, 'image': AppAssets.hardware_img},
    {'title': AppStrings.toys, 'image': AppAssets.toys_img},
  ];

  static List nearToYouList = [
    {
      'title': AppStrings.food_shop,
      'category': AppStrings.food,
      'image': AppAssets.food_shop_img
    },
    {
      'title': AppStrings.gym,
      'category': AppStrings.fitness,
      'image': AppAssets.gym_img
    },
    {
      'title': AppStrings.salon,
      'category': AppStrings.beauty,
      'image': AppAssets.salon_shop_img
    },
    {
      'title': AppStrings.cloth_shop,
      'category': AppStrings.fashion,
      'image': AppAssets.cloth_shop_img
    },
  ];

  static List countryList = [
    'Chaguanas',
    'San Fernando',
    'Port Of Spain',
    'Arima',
    'Couva',
    'San Juan',
    'Tunapuna',
    'Sangre Grande',
    'Penal'
  ];

  static List subscriptionList = [
    {
      'id': 'one_month',
      'duration': AppStrings.one_month,
      'days': '30',
      'amount': '150',
      'price': '150',
      'currency': '\$',
      'save': '',
      'image': AppAssets.month_img
    },
    {
      'id': 'six_month',
      'duration': AppStrings.six_month,
      'days': '180',
      'amount': '750',
      'price': '750',
      'currency': '\$',
      'save': '',
      'image': AppAssets.annually_img
    },
    {
      'id': 'year',
      'duration': AppStrings.one_year,
      'days': '360',
      'amount': '1200',
      'price': '1200',
      'currency': '\$',
      'save': '',
      'image': AppAssets.lifetime_img
    },
  ];
}
