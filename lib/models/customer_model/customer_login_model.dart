class CustomerLoginModel {
  String? token;
  UserDetail? userDetail;

  CustomerLoginModel({this.token, this.userDetail});

  CustomerLoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userDetail = json['userDetail'] != null
        ? new UserDetail.fromJson(json['userDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.userDetail != null) {
      data['userDetail'] = this.userDetail!.toJson();
    }
    return data;
  }
}

class UserDetail {
  String? userImg;
  String? userName;
  String? userEmail;
  String? countryCode;
  String? phoneNumber;
  String? password;
  int? userType;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? userId;
  String? deviceToken;

  UserDetail({
    this.userImg,
    this.userName,
    this.userEmail,
    this.countryCode,
    this.phoneNumber,
    this.password,
    this.userType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.deviceToken,
  });

  UserDetail.fromJson(Map<String, dynamic> json) {
    userImg = json['user_img'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    password = json['password'];
    userType = json['user_type'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['user_id'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_img'] = this.userImg;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['country_code'] = this.countryCode;
    data['phone_number'] = this.phoneNumber;
    data['password'] = this.password;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['device_token'] = this.deviceToken;

    return data;
  }
}
