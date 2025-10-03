class RegisterModel {
  String? token;
  BusinessOwner? businessOwner;
  Business? business;
  BusinessSubscription? businessSubscription;

  RegisterModel(
      {this.token,
        this.businessOwner,
        this.business,
        this.businessSubscription});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    businessOwner = json['businessOwner'] != null
        ? new BusinessOwner.fromJson(json['businessOwner'])
        : null;
    business = json['business'] != null
        ? new Business.fromJson(json['business'])
        : null;
    businessSubscription = json['businessSubscription'] != null
        ? new BusinessSubscription.fromJson(json['businessSubscription'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.businessOwner != null) {
      data['businessOwner'] = this.businessOwner!.toJson();
    }
    if (this.business != null) {
      data['business'] = this.business!.toJson();
    }
    if (this.businessSubscription != null) {
      data['businessSubscription'] = this.businessSubscription!.toJson();
    }
    return data;
  }
}

class BusinessOwner {
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
  String? ownerId;

  BusinessOwner(
      {this.ownerName,
        this.ownerEmail,
        this.ownerImg,
        this.countryCode,
        this.phoneNumber,
        this.password,
        this.deviceToken,
        this.userType,
        this.createdAt,
        this.updatedAt,
        this.ownerId});

  BusinessOwner.fromJson(Map<String, dynamic> json) {
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
    ownerId = json['owner_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['owner_id'] = this.ownerId;
    return data;
  }
}

class Business {
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
  String? businessOwner;
  BusinessLocation? businessLocation;
  int? averageRating;
  String? approvalStatus;
  String? status;
  String? businessLocationDetails;
  String? city;
  String? createdAt;
  String? updatedAt;
  String? businessId;

  Business(
      {this.businessName,
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
        this.businessLocation,
        this.averageRating,
        this.approvalStatus,
        this.status,
        this.businessLocationDetails,
        this.city,
        this.createdAt,
        this.updatedAt,
        this.businessId});

  Business.fromJson(Map<String, dynamic> json) {
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
    businessOwner = json['business_owner'];
    businessLocation = json['business_location'] != null
        ? new BusinessLocation.fromJson(json['business_location'])
        : null;
    averageRating = json['average_rating'];
    approvalStatus = json['approval_status'];
    status = json['status'];
    businessLocationDetails = json['business_location_details'];
    city = json['city'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    businessId = json['business_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['business_owner'] = this.businessOwner;
    if (this.businessLocation != null) {
      data['business_location'] = this.businessLocation!.toJson();
    }
    data['average_rating'] = this.averageRating;
    data['approval_status'] = this.approvalStatus;
    data['status'] = this.status;
    data['business_location_details'] = this.businessLocationDetails;
    data['city'] = this.city;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['business_id'] = this.businessId;
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

class BusinessSubscription {
  String? business;
  String? subscriptionPlan;
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  int? subscriptionDurationDays;
  String? subscriptionStatus;
  String? createdAt;
  String? updatedAt;
  String? id;

  BusinessSubscription(
      {this.business,
        this.subscriptionPlan,
        this.subscriptionStartDate,
        this.subscriptionEndDate,
        this.subscriptionDurationDays,
        this.subscriptionStatus,
        this.createdAt,
        this.updatedAt,
        this.id});

  BusinessSubscription.fromJson(Map<String, dynamic> json) {
    business = json['business'];
    subscriptionPlan = json['subscription_plan'];
    subscriptionStartDate = json['subscription_start_date'];
    subscriptionEndDate = json['subscription_end_date'];
    subscriptionDurationDays = json['subscription_duration_days'];
    subscriptionStatus = json['subscription_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business'] = this.business;
    data['subscription_plan'] = this.subscriptionPlan;
    data['subscription_start_date'] = this.subscriptionStartDate;
    data['subscription_end_date'] = this.subscriptionEndDate;
    data['subscription_duration_days'] = this.subscriptionDurationDays;
    data['subscription_status'] = this.subscriptionStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}
