import 'dart:convert';

List<GetCategory> getCategoryFromJson(String str) => List<GetCategory>.from(
    json.decode(str).map((x) => GetCategory.fromJson(x)));

String getCategoryToJson(List<GetCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCategory {
  String? catName;
  String? catImg;
  bool? status;
  String? catId;
  bool? locally;

  GetCategory({
    this.catName,
    this.catImg,
    this.status,
    this.catId,
    this.locally = false,
  });

  GetCategory.fromJson(Map<String, dynamic> json) {
    catName = json['cat_name'];
    catImg = json['cat_img'];
    status = json['status'];
    catId = json['cat_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_name'] = this.catName;
    data['cat_img'] = this.catImg;
    data['status'] = this.status;
    data['cat_id'] = this.catId;
    return data;
  }
}
