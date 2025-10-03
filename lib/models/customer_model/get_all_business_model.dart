import 'dart:convert';

List<GetAllBusiness> getAllBusinessFromJson(String str) =>
    List<GetAllBusiness>.from(
        json.decode(str).map((x) => GetAllBusiness.fromJson(x)));

String getAllBusinessToJson(List<GetAllBusiness> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllBusiness {
  BusinessLocation? businessLocation;
  String? sId;
  String? businessName;
  String? businessCategory;
  String? businessDetail;
  List<String>? businessImages;
  String? openingHours1;
  String? openingHours2;
  String? openingHours3;
  String? openingHours4;
  String? openingHours5;
  String? openingHours6;
  String? openingHours7;
  BusinessOwner? businessOwner;
  dynamic averageRating;
  String? approvalStatus;
  String? status;
  String? businessLocationDetails;
  String? city;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isFavorite;
  double? distance;
  int? ratingCount;
  bool? userHasRated;
  bool? locally;

  GetAllBusiness({
    this.businessLocation,
    this.sId,
    this.businessName,
    this.businessCategory,
    this.businessDetail,
    this.businessImages,
    this.openingHours1,
    this.openingHours2,
    this.openingHours3,
    this.openingHours4,
    this.openingHours5,
    this.openingHours6,
    this.openingHours7,
    this.businessOwner,
    this.averageRating,
    this.approvalStatus,
    this.status,
    this.businessLocationDetails,
    this.city,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.isFavorite,
    this.distance,
    this.ratingCount,
    this.userHasRated,
    this.locally = false,
  });

  GetAllBusiness.fromJson(Map<String, dynamic> json) {
    businessLocation = json['business_location'] != null
        ? new BusinessLocation.fromJson(json['business_location'])
        : null;
    sId = json['_id'];
    businessName = json['business_name'];
    businessCategory = json['business_category'];
    businessDetail = json['business_detail'];
    businessImages = json['business_images'].cast<String>();
    openingHours1 = json['opening_hours_1'];
    openingHours2 = json['opening_hours_2'];
    openingHours3 = json['opening_hours_3'];
    openingHours4 = json['opening_hours_4'];
    openingHours5 = json['opening_hours_5'];
    openingHours6 = json['opening_hours_6'];
    openingHours7 = json['opening_hours_7'];
    businessOwner = json['business_owner'] != null
        ? new BusinessOwner.fromJson(json['business_owner'])
        : null;
    averageRating = json['average_rating'];
    approvalStatus = json['approval_status'];
    status = json['status'];
    businessLocationDetails = json['business_location_details'];
    city = json['city'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isFavorite = json['is_favorite'];
    distance = json['distance'].toDouble();
    ratingCount = json['rating_count'];
    userHasRated = json['user_has_rated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.businessLocation != null) {
      data['business_location'] = this.businessLocation!.toJson();
    }
    data['_id'] = this.sId;
    data['business_name'] = this.businessName;
    data['business_category'] = this.businessCategory;
    data['business_detail'] = this.businessDetail;
    data['business_images'] = this.businessImages;
    data['opening_hours_1'] = this.openingHours1;
    data['opening_hours_2'] = this.openingHours2;
    data['opening_hours_3'] = this.openingHours3;
    data['opening_hours_4'] = this.openingHours4;
    data['opening_hours_5'] = this.openingHours5;
    data['opening_hours_6'] = this.openingHours6;
    data['opening_hours_7'] = this.openingHours7;
    if (this.businessOwner != null) {
      data['business_owner'] = this.businessOwner!.toJson();
    }
    data['average_rating'] = this.averageRating;
    data['approval_status'] = this.approvalStatus;
    data['status'] = this.status;
    data['business_location_details'] = this.businessLocationDetails;
    data['city'] = this.city;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['is_favorite'] = this.isFavorite;
    data['distance'] = this.distance;
    data['rating_count'] = this.ratingCount;
    data['user_has_rated'] = this.userHasRated;
    return data;
  }
}

class BusinessLocation {
  String? type;
  List<double>? coordinates;

  BusinessLocation({this.type, this.coordinates});

  BusinessLocation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class BusinessOwner {
  String? sId;
  String? ownerName;
  String? ownerEmail;
  String? ownerImg;
  String? countryCode;
  String? phoneNumber;
  String? password;
  String? deviceToken;
  int? userType;
  String? createdAt;
  String? updatedAt;
  int? iV;

  BusinessOwner(
      {this.sId,
      this.ownerName,
      this.ownerEmail,
      this.ownerImg,
      this.countryCode,
      this.phoneNumber,
      this.password,
      this.deviceToken,
      this.userType,
      this.createdAt,
      this.updatedAt,
      this.iV});

  BusinessOwner.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    ownerName = json['owner_name'];
    ownerEmail = json['owner_email'];
    ownerImg = json['owner_img'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    password = json['password'];
    deviceToken = json['device_token'];
    userType = json['user_type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['owner_name'] = this.ownerName;
    data['owner_email'] = this.ownerEmail;
    data['owner_img'] = this.ownerImg;
    data['country_code'] = this.countryCode;
    data['phone_number'] = this.phoneNumber;
    data['password'] = this.password;
    data['device_token'] = this.deviceToken;
    data['user_type'] = this.userType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
