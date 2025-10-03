import 'dart:convert';

List<GetBanners> getBannersFromJson(String str) =>
    List<GetBanners>.from(json.decode(str).map((x) => GetBanners.fromJson(x)));

String getBannersToJson(List<GetBanners> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetBanners {
  String? banImg;
  String? banTitle;
  bool? status;
  String? banId;
  bool? locally;

  GetBanners({
    this.banImg,
    this.banTitle,
    this.status,
    this.banId,
    this.locally = false,
  });

  GetBanners.fromJson(Map<String, dynamic> json) {
    banImg = json['ban_img'];
    banTitle = json['ban_title'];
    status = json['status'];
    banId = json['ban_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ban_img'] = this.banImg;
    data['ban_title'] = this.banTitle;
    data['status'] = this.status;
    data['ban_id'] = this.banId;
    return data;
  }
}
