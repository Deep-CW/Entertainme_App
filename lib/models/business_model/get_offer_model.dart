class GetOffer {
  String? sId;
  String? offerImg;
  String? offerTitle;
  String? offerDesc;
  String? offerEndDate;
  String? approvalStatus;
  String? status;
  int? clickCount;

  GetOffer(
      {this.sId,
        this.offerImg,
        this.offerTitle,
        this.offerDesc,
        this.offerEndDate,
        this.approvalStatus,
        this.status,
        this.clickCount});

  GetOffer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    offerImg = json['offer_img'];
    offerTitle = json['offer_title'];
    offerDesc = json['offer_desc'];
    offerEndDate = json['offer_end_date'];
    approvalStatus = json['approval_status'];
    status = json['status'];
    clickCount = json['click_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['offer_img'] = this.offerImg;
    data['offer_title'] = this.offerTitle;
    data['offer_desc'] = this.offerDesc;
    data['offer_end_date'] = this.offerEndDate;
    data['approval_status'] = this.approvalStatus;
    data['status'] = this.status;
    data['click_count'] = this.clickCount;
    return data;
  }
}
