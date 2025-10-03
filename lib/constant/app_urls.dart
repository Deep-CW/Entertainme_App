// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names

class AppUrls {
  //base api
  static String BASE_API = 'https://www.entertainmett.com/';
//   static String BASE_API = 'https://findlocals.in/';

  //BUSINESS
  static String BUSINESS_SIGN_IN = BASE_API + 'api/business-owner/auth/login';
  static String BUSINESS_SIGN_UP =
      BASE_API + 'api/business-owner/auth/register';
  static String BUSINESS_PROFILE_DETAIL =
      BASE_API + 'api/business-owner/auth/user-detail';
  static String BUSINESS_CHANGE_PASSWORD =
      BASE_API + 'api/business-owner/auth/change-password';
  static String BUSINESS_OFFERS = BASE_API + 'api/business/offers';
  static String BUSINESS_ADD_OFFERS = BASE_API + 'api/business/offers';
  static String BUSINESS_EDIT_OFFERS = BASE_API + 'api/business/offers/';
  static String BUSINESS_UPDATE_PROFILE =
      BASE_API + "api/business-owner/auth/update-profile";
  static String BUSINESS_DASHBOARD_DETAIL =
      BASE_API + "api/businesses/dashboard/?ownerId=";
  static String BUSINESS_LOGOUT = BASE_API + "api/business-owner/auth/logout";
  static String BUSINESS_DELETE = BASE_API + "api/business-owner/auth/";
  static String BUSINESS_FORGOT_PASSWORD =
      BASE_API + "api/business-owner/auth/forgot-password-request";
  static String BUSINESS_VERIFY_OTP =
      BASE_API + "api/business-owner/auth/verify-otp";
  static String BUSINESS_RESET_PASSWORD =
      BASE_API + "api/business-owner/auth/reset-password";
  static String BUSINESS_ADD_PURCHASE =
      BASE_API + 'api/business-owner/auth/subscription-payment/success';
  static String BUSINESS_VALIDITY_STATUS =
      BASE_API + 'api/business-owner/auth/subscription-payment/status/';
  static String BUSINESS_RATING =
      BASE_API + 'api/businesses/business-rating/ratio';

//CUSTOMER
  static String CUSTOMER_SIGN_IN = BASE_API + 'api/user/auth/login';
  static String CUSTOMER_SIGN_UP = BASE_API + 'api/user/auth/register';
  static String CUSTOMER_CHANGE_PASSWORD =
      BASE_API + 'api/user/auth/change-password';
  static String CUSTOMER_PROFILE_DETAIL =
      BASE_API + 'api/user/auth/user-detail';
  static String GET_CATEGORIES = BASE_API + 'api/common/business/categories';
  static String GET_BANNERS = BASE_API + 'api/common/banners?status=true';
  static String GET_FAVOURITES_BUSINESS =
      BASE_API + 'api/business/favorites?user_id=';
  static String SET_FAVOURITES_BUSINESS =
      BASE_API + 'api/business/toggle-favorite';
  static String GIVE_RATING = BASE_API + 'api/business/give-rating';
  static String GET_ALL_BUSINESS_OFFER = BASE_API + 'api/business/all/offers/';
  static String SEARCH_BUSINESS = BASE_API + 'api/business/search?searchText=';
  static String SEARCH_CATEGORIES_BUSINESS =
      BASE_API + 'api/common/category/businessFilter?searchText=';
  static String SEARCH_FAVORITE_BUSINESS =
      BASE_API + 'api/business/search-favorite?user_id=';
  static String GET_ALL_BUSINESS = BASE_API + 'api/business/?page=';
  static String GET_CATEGORIES_BUSINESS =
      BASE_API + 'api/common/category/businessFilter?page=';
  static String BUSINESS_PROFILE_OFFER = BASE_API + 'api/business/offer/click/';
  static String VIEW_BUSINESS_PROFILE = BASE_API + 'api/business/view/profile/';
  static String CUSTOMER_EDIT_PROFILE = BASE_API + 'api/user/auth/edit-profile';
  static String GET_NOTIFICATION =
      BASE_API + 'api/common/get/notification/?user_id=';
  static String FILTER_BUSINESS = BASE_API + 'api/common/businessFilter?page=';
  static String USER_LOGOUT = BASE_API + "api/user/auth/logout";
  static String USER_DELETE = BASE_API + "api/user/auth/user-delete/";
  static String USER_FORGOT_PASSWORD =
      BASE_API + "api/user/auth/forgot-password-request";
  static String USER_VERIFY_OTP = BASE_API + "api/user/auth/verify-otp";
  static String USER_RESET_PASSWORD = BASE_API + "api/user/auth/reset-password";

  static String NOTIFICATION_UPDATE =
      BASE_API + 'api/common/notification-status-update';
  static String LOCATION_CITY_API =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static String GET_LAT_LONG_API =
      'https://maps.googleapis.com/maps/api/geocode/json?';

  static String androidMap = 'https://www.google.com/maps/search/?api=1&query=';
  static String iosMap = '';

  static String termAndCondition = 'https://www.google.com/';
  static String privacy = 'https://www.google.com/';
  static String aboutUS = 'https://www.google.com/';

  //google api key
  static String kGoogleApiKey = "AIzaSyBHETdPzwwwvPcM2Iyx9F60HlPaK3EL62w";
}
