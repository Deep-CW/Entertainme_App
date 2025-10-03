class CustomerProfileModel {
  User? user;

  CustomerProfileModel({this.user});

  CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
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

  User(
      {this.userImg,
        this.userName,
        this.userEmail,
        this.countryCode,
        this.phoneNumber,
        this.password,
        this.userType,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.userId});

  User.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
