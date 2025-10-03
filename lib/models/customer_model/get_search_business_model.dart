class GetSearchBusiness {
  String? businessName;
  String? businessLocation;
  String? businessCategory;
  String? businessDetail;
  List<String>? businessImages;
 // List<OpeningHours>? openingHours;
  BusinessOwner? businessOwner;
  dynamic averageRating;
  String? approvalStatus;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? businessSubscription;
  String? businessId;

  GetSearchBusiness(
      {this.businessName,
        this.businessLocation,
        this.businessCategory,
        this.businessDetail,
        this.businessImages,
       // this.openingHours,
        this.businessOwner,
        this.averageRating,
        this.approvalStatus,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.businessSubscription,
        this.businessId});

  GetSearchBusiness.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    businessLocation = json['business_location'];
    businessCategory = json['business_category'];
    businessDetail = json['business_detail'];
    businessImages = json['business_images'].cast<String>();
    // if (json['opening_hours'] != null) {
    //   openingHours = <OpeningHours>[];
    //   json['opening_hours'].forEach((v) {
    //     openingHours!.add(new OpeningHours.fromJson(v));
    //   });
    // }
    businessOwner = json['business_owner'] != null
        ? new BusinessOwner.fromJson(json['business_owner'])
        : null;
    averageRating = json['average_rating'];
    approvalStatus = json['approval_status'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    businessSubscription = json['business_subscription'];
    businessId = json['business_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_name'] = this.businessName;
    data['business_location'] = this.businessLocation;
    data['business_category'] = this.businessCategory;
    data['business_detail'] = this.businessDetail;
    data['business_images'] = this.businessImages;
    // if (this.openingHours != null) {
    //   data['opening_hours'] =
    //       this.openingHours!.map((v) => v.toJson()).toList();
    // }
    if (this.businessOwner != null) {
      data['business_owner'] = this.businessOwner!.toJson();
    }
    data['average_rating'] = this.averageRating;
    data['approval_status'] = this.approvalStatus;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['business_subscription'] = this.businessSubscription;
    data['business_id'] = this.businessId;
    return data;
  }
}

class OpeningHours {
  String? day;
  String? fromTime;
  String? toTime;
  bool? isClosed;

  OpeningHours({this.day, this.fromTime, this.toTime, this.isClosed});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    isClosed = json['is_closed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['is_closed'] = this.isClosed;
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
    data['user_type'] = this.userType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
