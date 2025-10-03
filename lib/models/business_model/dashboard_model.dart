class DashboardModel {
  int? ratingCount;
  double? averateRating;
  int? profileViews;

  DashboardModel({this.ratingCount, this.averateRating, this.profileViews});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    ratingCount = json['rating_count'];
    averateRating = json['averate_rating'].toDouble();
    profileViews = json['profile_views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating_count'] = this.ratingCount;
    data['averate_rating'] = this.averateRating;
    data['profile_views'] = this.profileViews;
    return data;
  }
}
