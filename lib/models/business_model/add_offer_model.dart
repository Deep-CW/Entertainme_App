class AddOffer {
  String? message;
  Data? data;

  AddOffer({this.message, this.data});

  AddOffer.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? businessOwner;
  String? business;
  String? offerImg;
  String? offerTitle;
  String? offerDesc;
  String? offerEndDate;
  String? approvalStatus;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? offerId;

  Data(
      {this.businessOwner,
        this.business,
        this.offerImg,
        this.offerTitle,
        this.offerDesc,
        this.offerEndDate,
        this.approvalStatus,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.offerId});

  Data.fromJson(Map<String, dynamic> json) {
    businessOwner = json['business_owner'];
    business = json['business'];
    offerImg = json['offer_img'];
    offerTitle = json['offer_title'];
    offerDesc = json['offer_desc'];
    offerEndDate = json['offer_end_date'];
    approvalStatus = json['approval_status'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    offerId = json['offer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_owner'] = this.businessOwner;
    data['business'] = this.business;
    data['offer_img'] = this.offerImg;
    data['offer_title'] = this.offerTitle;
    data['offer_desc'] = this.offerDesc;
    data['offer_end_date'] = this.offerEndDate;
    data['approval_status'] = this.approvalStatus;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['offer_id'] = this.offerId;
    return data;
  }
}
