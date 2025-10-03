// class EditProfileModel {
//   BusinessOwner? businessOwner;
//   Business? business;
//
//   EditProfileModel({this.businessOwner, this.business});
//
//   EditProfileModel.fromJson(Map<String, dynamic> json) {
//     businessOwner = json['businessOwner'] != null
//         ? new BusinessOwner.fromJson(json['businessOwner'])
//         : null;
//     business = json['business'] != null
//         ? new Business.fromJson(json['business'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.businessOwner != null) {
//       data['businessOwner'] = this.businessOwner!.toJson();
//     }
//     if (this.business != null) {
//       data['business'] = this.business!.toJson();
//     }
//     return data;
//   }
// }
//
// class BusinessOwner {
//   String? ownerName;
//   String? ownerEmail;
//   String? ownerImg;
//   String? countryCode;
//   String? phoneNumber;
//   String? password;
//   String? deviceToken;
//   int? userType;
//   String? createdAt;
//   String? updatedAt;
//   String? ownerId;
//
//   BusinessOwner(
//       {this.ownerName,
//         this.ownerEmail,
//         this.ownerImg,
//         this.countryCode,
//         this.phoneNumber,
//         this.password,
//         this.deviceToken,
//         this.userType,
//         this.createdAt,
//         this.updatedAt,
//         this.ownerId});
//
//   BusinessOwner.fromJson(Map<String, dynamic> json) {
//     ownerName = json['owner_name'];
//     ownerEmail = json['owner_email'];
//     ownerImg = json['owner_img'];
//     countryCode = json['country_code'];
//     phoneNumber = json['phone_number'];
//     password = json['password'];
//     deviceToken = json['device_token'];
//     userType = json['user_type'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     ownerId = json['owner_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['owner_name'] = this.ownerName;
//     data['owner_email'] = this.ownerEmail;
//     data['owner_img'] = this.ownerImg;
//     data['country_code'] = this.countryCode;
//     data['phone_number'] = this.phoneNumber;
//     data['password'] = this.password;
//     data['device_token'] = this.deviceToken;
//     data['user_type'] = this.userType;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['owner_id'] = this.ownerId;
//     return data;
//   }
// }
//
// class Business {
//   BusinessLocation? businessLocation;
//   String? businessName;
//   String? businessCategory;
//   String? businessDetail;
//   List<String>? businessImages;
//   String? openingHours1;
//   String? openingHours2;
//   String? openingHours3;
//   String? openingHours4;
//   String? openingHours5;
//   String? openingHours6;
//   String? openingHours7;
//   String? businessOwner;
//   int? averageRating;
//   String? approvalStatus;
//   String? status;
//   String? businessLocationDetails;
//   String? city;
//   String? createdAt;
//   String? updatedAt;
//   String? businessId;
//
//   Business(
//       {this.businessLocation,
//         this.businessName,
//         this.businessCategory,
//         this.businessDetail,
//         this.businessImages,
//         this.openingHours1,
//         this.openingHours2,
//         this.openingHours3,
//         this.openingHours4,
//         this.openingHours5,
//         this.openingHours6,
//         this.openingHours7,
//         this.businessOwner,
//         this.averageRating,
//         this.approvalStatus,
//         this.status,
//         this.businessLocationDetails,
//         this.city,
//         this.createdAt,
//         this.updatedAt,
//         this.businessId});
//
//   Business.fromJson(Map<String, dynamic> json) {
//     businessLocation = json['business_location'] != null
//         ? new BusinessLocation.fromJson(json['business_location'])
//         : null;
//     businessName = json['business_name'];
//     businessCategory = json['business_category'];
//     businessDetail = json['business_detail'];
//     businessImages = json['business_images'].cast<String>();
//     openingHours1 = json['opening_hours_1'];
//     openingHours2 = json['opening_hours_2'];
//     openingHours3 = json['opening_hours_3'];
//     openingHours4 = json['opening_hours_4'];
//     openingHours5 = json['opening_hours_5'];
//     openingHours6 = json['opening_hours_6'];
//     openingHours7 = json['opening_hours_7'];
//     businessOwner = json['business_owner'];
//     averageRating = json['average_rating'];
//     approvalStatus = json['approval_status'];
//     status = json['status'];
//     businessLocationDetails = json['business_location_details'];
//     city = json['city'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     businessId = json['business_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.businessLocation != null) {
//       data['business_location'] = this.businessLocation!.toJson();
//     }
//     data['business_name'] = this.businessName;
//     data['business_category'] = this.businessCategory;
//     data['business_detail'] = this.businessDetail;
//     data['business_images'] = this.businessImages;
//     data['opening_hours_1'] = this.openingHours1;
//     data['opening_hours_2'] = this.openingHours2;
//     data['opening_hours_3'] = this.openingHours3;
//     data['opening_hours_4'] = this.openingHours4;
//     data['opening_hours_5'] = this.openingHours5;
//     data['opening_hours_6'] = this.openingHours6;
//     data['opening_hours_7'] = this.openingHours7;
//     data['business_owner'] = this.businessOwner;
//     data['average_rating'] = this.averageRating;
//     data['approval_status'] = this.approvalStatus;
//     data['status'] = this.status;
//     data['business_location_details'] = this.businessLocationDetails;
//     data['city'] = this.city;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['business_id'] = this.businessId;
//     return data;
//   }
// }
//
// class BusinessLocation {
//   String? type;
//   List? coordinates;
//
//   BusinessLocation({this.type, this.coordinates});
//
//   BusinessLocation.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     coordinates = json['coordinates'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['type'] = this.type;
//     data['coordinates'] = this.coordinates;
//     return data;
//   }
// }

// To parse this JSON data, do
//
//     final editProfileModel = editProfileModelFromJson(jsonString);

import 'dart:convert';

EditProfileModel editProfileModelFromJson(String str) =>
    EditProfileModel.fromJson(json.decode(str));

String editProfileModelToJson(EditProfileModel data) =>
    json.encode(data.toJson());

class EditProfileModel {
  BusinessOwner? businessOwner;
  Business? business;

  EditProfileModel({
    this.businessOwner,
    this.business,
  });

  factory EditProfileModel.fromJson(Map<String, dynamic> json) =>
      EditProfileModel(
        businessOwner: BusinessOwner.fromJson(json["businessOwner"]),
        business: Business.fromJson(json["business"]),
      );

  Map<String, dynamic> toJson() => {
        "businessOwner": businessOwner!.toJson(),
        "business": business!.toJson(),
      };
}

class Business {
  BusinessLocation businessLocation;
  String businessName;
  String businessCategory;
  String businessDetail;
  List<String> businessImages;
  String openingHours1;
  String openingHours2;
  String openingHours3;
  String openingHours4;
  String openingHours5;
  String openingHours6;
  String openingHours7;
  String businessOwner;
  double averageRating;
  String approvalStatus;
  String status;
  String businessLocationDetails;
  String city;
  DateTime createdAt;
  DateTime updatedAt;
  String businessId;

  Business({
    required this.businessLocation,
    required this.businessName,
    required this.businessCategory,
    required this.businessDetail,
    required this.businessImages,
    required this.openingHours1,
    required this.openingHours2,
    required this.openingHours3,
    required this.openingHours4,
    required this.openingHours5,
    required this.openingHours6,
    required this.openingHours7,
    required this.businessOwner,
    required this.averageRating,
    required this.approvalStatus,
    required this.status,
    required this.businessLocationDetails,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
    required this.businessId,
  });

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        businessLocation: BusinessLocation.fromJson(json["business_location"]),
        businessName: json["business_name"],
        businessCategory: json["business_category"],
        businessDetail: json["business_detail"],
        businessImages:
            List<String>.from(json["business_images"].map((x) => x)),
        openingHours1: json["opening_hours_1"],
        openingHours2: json["opening_hours_2"],
        openingHours3: json["opening_hours_3"],
        openingHours4: json["opening_hours_4"],
        openingHours5: json["opening_hours_5"],
        openingHours6: json["opening_hours_6"],
        openingHours7: json["opening_hours_7"],
        businessOwner: json["business_owner"],
        averageRating: json["average_rating"].toDouble(),
        approvalStatus: json["approval_status"],
        status: json["status"],
        businessLocationDetails: json["business_location_details"],
        city: json["city"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        businessId: json["business_id"],
      );

  Map<String, dynamic> toJson() => {
        "business_location": businessLocation.toJson(),
        "business_name": businessName,
        "business_category": businessCategory,
        "business_detail": businessDetail,
        "business_images": List<dynamic>.from(businessImages.map((x) => x)),
        "opening_hours_1": openingHours1,
        "opening_hours_2": openingHours2,
        "opening_hours_3": openingHours3,
        "opening_hours_4": openingHours4,
        "opening_hours_5": openingHours5,
        "opening_hours_6": openingHours6,
        "opening_hours_7": openingHours7,
        "business_owner": businessOwner,
        "average_rating": averageRating,
        "approval_status": approvalStatus,
        "status": status,
        "business_location_details": businessLocationDetails,
        "city": city,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "business_id": businessId,
      };
}

class BusinessLocation {
  String type;
  List<double> coordinates;

  BusinessLocation({
    required this.type,
    required this.coordinates,
  });

  factory BusinessLocation.fromJson(Map<String, dynamic> json) =>
      BusinessLocation(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class BusinessOwner {
  String ownerName;
  String ownerEmail;
  String ownerImg;
  String countryCode;
  String phoneNumber;
  String password;
  String? deviceToken;
  int userType;
  DateTime createdAt;
  DateTime updatedAt;
  String ownerId;

  BusinessOwner({
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerImg,
    required this.countryCode,
    required this.phoneNumber,
    required this.password,
    required this.deviceToken,
    required this.userType,
    required this.createdAt,
    required this.updatedAt,
    required this.ownerId,
  });

  factory BusinessOwner.fromJson(Map<String, dynamic> json) => BusinessOwner(
        ownerName: json["owner_name"],
        ownerEmail: json["owner_email"],
        ownerImg: json["owner_img"],
        countryCode: json["country_code"],
        phoneNumber: json["phone_number"],
        password: json["password"],
        deviceToken: json["device_token"],
        userType: json["user_type"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        ownerId: json["owner_id"],
      );

  Map<String, dynamic> toJson() => {
        "owner_name": ownerName,
        "owner_email": ownerEmail,
        "owner_img": ownerImg,
        "country_code": countryCode,
        "phone_number": phoneNumber,
        "password": password,
        "device_token": deviceToken,
        "user_type": userType,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "owner_id": ownerId,
      };
}
