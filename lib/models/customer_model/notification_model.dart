//
//
// import 'dart:convert';
//
// NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));
//
// String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());
//
// class NotificationModel {
//   List<Datum> data;
//
//   NotificationModel({
//     required this.data,
//   });
//
//   factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
//     data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }
//
// class Datum {
//   String id;
//   String title;
//   String message;
//   String sender;
//   dynamic receiver;
//   bool read;
//   String refId;
//   String toUser;
//   String action;
//   String img;
//   String businessId;
//   String ownerId;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//   String timeAgo;
//   BusinessDetails businessDetails;
//
//   Datum({
//     required this.id,
//     required this.title,
//     required this.message,
//     required this.sender,
//     required this.receiver,
//     required this.read,
//     required this.refId,
//     required this.toUser,
//     required this.action,
//     required this.img,
//     required this.businessId,
//     required this.ownerId,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     required this.timeAgo,
//     required this.businessDetails,
//   });
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     id: json["_id"],
//     title: json["title"],
//     message: json["message"],
//     sender: json["sender"],
//     receiver: json["receiver"],
//     read: json["read"],
//     refId: json["ref_id"],
//     toUser: json["to_user"],
//     action: json["action"],
//     img: json["img"],
//     businessId: json["business_id"],
//     ownerId: json["owner_id"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//     timeAgo: json["timeAgo"],
//     businessDetails: BusinessDetails.fromJson(json["business_details"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "title": title,
//     "message": message,
//     "sender": sender,
//     "receiver": receiver,
//     "read": read,
//     "ref_id": refId,
//     "to_user": toUser,
//     "action": action,
//     "img": img,
//     "business_id": businessId,
//     "owner_id": ownerId,
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "__v": v,
//     "timeAgo": timeAgo,
//     "business_details": businessDetails.toJson(),
//   };
// }
//
// class BusinessDetails {
//   BusinessLocation businessLocation;
//   String id;
//   String businessName;
//   String businessCategory;
//   String businessDetail;
//   List<String> businessImages;
//   String openingHours1;
//   String openingHours2;
//   String openingHours3;
//   String openingHours4;
//   String openingHours5;
//   String openingHours6;
//   String openingHours7;
//   BusinessOwner businessOwner;
//   int averageRating;
//   String approvalStatus;
//   String status;
//   String businessLocationDetails;
//   String city;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//   int ratingCount;
//   bool isFavorite;
//
//   BusinessDetails({
//     required this.businessLocation,
//     required this.id,
//     required this.businessName,
//     required this.businessCategory,
//     required this.businessDetail,
//     required this.businessImages,
//     required this.openingHours1,
//     required this.openingHours2,
//     required this.openingHours3,
//     required this.openingHours4,
//     required this.openingHours5,
//     required this.openingHours6,
//     required this.openingHours7,
//     required this.businessOwner,
//     required this.averageRating,
//     required this.approvalStatus,
//     required this.status,
//     required this.businessLocationDetails,
//     required this.city,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     required this.ratingCount,
//     required this.isFavorite,
//   });
//
//   factory BusinessDetails.fromJson(Map<String, dynamic> json) => BusinessDetails(
//     businessLocation: BusinessLocation.fromJson(json["business_location"]),
//     id: json["_id"],
//     businessName: json["business_name"],
//     businessCategory: json["business_category"],
//     businessDetail: json["business_detail"],
//     businessImages: List<String>.from(json["business_images"].map((x) => x)),
//     openingHours1: json["opening_hours_1"],
//     openingHours2: json["opening_hours_2"],
//     openingHours3: json["opening_hours_3"],
//     openingHours4: json["opening_hours_4"],
//     openingHours5: json["opening_hours_5"],
//     openingHours6: json["opening_hours_6"],
//     openingHours7: json["opening_hours_7"],
//     businessOwner: BusinessOwner.fromJson(json["business_owner"]),
//     averageRating: json["average_rating"],
//     approvalStatus: json["approval_status"],
//     status: json["status"],
//     businessLocationDetails: json["business_location_details"],
//     city: json["city"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//     ratingCount: json["rating_count"],
//     isFavorite: json["isFavorite"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "business_location": businessLocation.toJson(),
//     "_id": id,
//     "business_name": businessName,
//     "business_category": businessCategory,
//     "business_detail": businessDetail,
//     "business_images": List<dynamic>.from(businessImages.map((x) => x)),
//     "opening_hours_1": openingHours1,
//     "opening_hours_2": openingHours2,
//     "opening_hours_3": openingHours3,
//     "opening_hours_4": openingHours4,
//     "opening_hours_5": openingHours5,
//     "opening_hours_6": openingHours6,
//     "opening_hours_7": openingHours7,
//     "business_owner": businessOwner.toJson(),
//     "average_rating": averageRating,
//     "approval_status": approvalStatus,
//     "status": status,
//     "business_location_details": businessLocationDetails,
//     "city": city,
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "__v": v,
//     "rating_count": ratingCount,
//     "isFavorite": isFavorite,
//   };
// }
//
// class BusinessLocation {
//   String type;
//   List<double> coordinates;
//
//   BusinessLocation({
//     required this.type,
//     required this.coordinates,
//   });
//
//   factory BusinessLocation.fromJson(Map<String, dynamic> json) => BusinessLocation(
//     type: json["type"],
//     coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "type": type,
//     "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
//   };
// }
//
// class BusinessOwner {
//   String ownerName;
//   String ownerEmail;
//   String ownerImg;
//   String countryCode;
//   String phoneNumber;
//   String password;
//   String deviceToken;
//   int userType;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String ownerId;
//
//   BusinessOwner({
//     required this.ownerName,
//     required this.ownerEmail,
//     required this.ownerImg,
//     required this.countryCode,
//     required this.phoneNumber,
//     required this.password,
//     required this.deviceToken,
//     required this.userType,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.ownerId,
//   });
//
//   factory BusinessOwner.fromJson(Map<String, dynamic> json) => BusinessOwner(
//     ownerName: json["owner_name"],
//     ownerEmail: json["owner_email"],
//     ownerImg: json["owner_img"],
//     countryCode: json["country_code"],
//     phoneNumber: json["phone_number"],
//     password: json["password"],
//     deviceToken: json["device_token"],
//     userType: json["user_type"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     ownerId: json["owner_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "owner_name": ownerName,
//     "owner_email": ownerEmail,
//     "owner_img": ownerImg,
//     "country_code": countryCode,
//     "phone_number": phoneNumber,
//     "password": password,
//     "device_token": deviceToken,
//     "user_type": userType,
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "owner_id": ownerId,
//   };
// }

// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  List<Datum> data;

  NotificationModel({
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String title;
  String message;
  String sender;
  dynamic receiver;
  bool read;
  String? refId;
  String? toUser;
  String? action;
  String? img;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String timeAgo;
  BusinessDetails? businessDetails;
  String? businessId;
  String? ownerId;

  Datum({
    required this.id,
    required this.title,
    required this.message,
    required this.sender,
    required this.receiver,
    required this.read,
    required this.refId,
    required this.toUser,
    required this.action,
    required this.img,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.timeAgo,
    required this.businessDetails,
    this.businessId,
    this.ownerId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        message: json["message"],
        sender: json["sender"],
        receiver: json["receiver"],
        read: json["read"],
        refId: json["ref_id"],
        toUser: json["to_user"],
        action: json["action"],
        img: json["img"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        timeAgo: json["timeAgo"],
        businessDetails: json["business_details"] == null
            ? null
            : BusinessDetails.fromJson(json["business_details"]),
        businessId: json["business_id"],
        ownerId: json["owner_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "message": message,
        "sender": sender,
        "receiver": receiver,
        "read": read,
        "ref_id": refId,
        "to_user": toUser,
        "action": action,
        "img": img,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "timeAgo": timeAgo,
        "business_details": businessDetails?.toJson(),
        "business_id": businessId,
        "owner_id": ownerId,
      };
}

class BusinessDetails {
  BusinessLocation businessLocation;
  String id;
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
  BusinessOwner businessOwner;
  dynamic averageRating;
  String approvalStatus;
  String status;
  String businessLocationDetails;
  String city;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int ratingCount;
  bool isFavorite;
  String? businessSubscription;
  bool? userHasRated;

  BusinessDetails({
    required this.businessLocation,
    required this.id,
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
    required this.v,
    required this.ratingCount,
    required this.isFavorite,
    this.businessSubscription,
    this.userHasRated,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) =>
      BusinessDetails(
        businessLocation: BusinessLocation.fromJson(json["business_location"]),
        id: json["_id"],
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
        businessOwner: BusinessOwner.fromJson(json["business_owner"]),
        averageRating: json["average_rating"],
        approvalStatus: json["approval_status"],
        status: json["status"],
        businessLocationDetails: json["business_location_details"],
        city: json["city"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        ratingCount: json["rating_count"],
        isFavorite: json["isFavorite"],
        businessSubscription: json["business_subscription"],
        userHasRated: json['user_has_rated'],
      );

  Map<String, dynamic> toJson() => {
        "business_location": businessLocation.toJson(),
        "_id": id,
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
        "business_owner": businessOwner.toJson(),
        "average_rating": averageRating,
        "approval_status": approvalStatus,
        "status": status,
        "business_location_details": businessLocationDetails,
        "city": city,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "rating_count": ratingCount,
        "isFavorite": isFavorite,
        "business_subscription": businessSubscription,
        'user_has_rated': userHasRated,
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
