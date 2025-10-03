class LoginModel {
  String? token;
  OwnerDetail? ownerDetail;

  LoginModel({this.token, this.ownerDetail});

  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    ownerDetail = json['ownerDetail'] != null
        ? new OwnerDetail.fromJson(json['ownerDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.ownerDetail != null) {
      data['ownerDetail'] = this.ownerDetail!.toJson();
    }
    return data;
  }
}

class OwnerDetail {
  String? ownerName;
  String? ownerEmail;
  String? ownerImg;
  String? countryCode;
  String? phoneNumber;
  String? password;
  int? userType;
  String? createdAt;
  String? updatedAt;
  String? ownerId;
  String? deviceToken;

  OwnerDetail({
    this.ownerName,
    this.ownerEmail,
    this.ownerImg,
    this.countryCode,
    this.phoneNumber,
    this.password,
    this.userType,
    this.createdAt,
    this.updatedAt,
    this.ownerId,
    this.deviceToken,
  });

  OwnerDetail.fromJson(Map<String, dynamic> json) {
    ownerName = json['owner_name'];
    ownerEmail = json['owner_email'];
    ownerImg = json['owner_img'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    password = json['password'];
    userType = json['user_type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    ownerId = json['owner_id'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner_name'] = this.ownerName;
    data['owner_email'] = this.ownerEmail;
    data['owner_img'] = this.ownerImg;
    data['country_code'] = this.countryCode;
    data['phone_number'] = this.phoneNumber;
    data['password'] = this.password;
    data['user_type'] = this.userType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['owner_id'] = this.ownerId;
    data['device_token'] = this.deviceToken;

    return data;
  }
}
