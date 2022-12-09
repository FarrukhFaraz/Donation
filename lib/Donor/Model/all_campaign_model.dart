class AllCampaignModel {
  int? id;
  String? userId;
  String? categoryId;
  String? campaignTitle;
  String? location;
  String? campaignGoal;
  String? raised;
  String? auctionTitle;
  String? endDate;
  String? image;
  String? about;
  String? createdAt;
  String? updatedAt;

  AllCampaignModel(
      {this.id,
        this.userId,
        this.categoryId,
        this.campaignTitle,
        this.location,
        this.campaignGoal,
        this.raised,
        this.auctionTitle,
        this.endDate,
        this.image,
        this.about,
        this.createdAt,
        this.updatedAt});

  AllCampaignModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    campaignTitle = json['campaignTitle'];
    location = json['location'];
    campaignGoal = json['campaignGoal'];
    raised = json['raised'];
    auctionTitle = json['auctionTitle'];
    endDate = json['endDate'];
    image = json['image'];
    about = json['about'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['campaignTitle'] = this.campaignTitle;
    data['location'] = this.location;
    data['campaignGoal'] = this.campaignGoal;
    data['raised'] = this.raised;
    data['auctionTitle'] = this.auctionTitle;
    data['endDate'] = this.endDate;
    data['image'] = this.image;
    data['about'] = this.about;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}