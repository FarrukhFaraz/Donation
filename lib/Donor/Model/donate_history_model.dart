class History {
  int? id;
  String? userId;
  String? donatetype;
  String? donateId;
  String? campaignId;
  String? amounttype;
  String? amount;
  String? createdAt;
  String? updatedAt;
  Donate? donate;
  Campaign? campaign;

  History(
      {this.id,
        this.userId,
        this.donatetype,
        this.donateId,
        this.campaignId,
        this.amounttype,
        this.amount,
        this.createdAt,
        this.updatedAt,
        this.donate,
        this.campaign});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    donatetype = json['donatetype'];
    donateId = json['donate_id'];
    campaignId = json['campaign_id'];
    amounttype = json['amounttype'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    donate =
    json['donate'] != null ? new Donate.fromJson(json['donate']) : null;
    campaign = json['campaign'] != null
        ? new Campaign.fromJson(json['campaign'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['donatetype'] = this.donatetype;
    data['donate_id'] = this.donateId;
    data['campaign_id'] = this.campaignId;
    data['amounttype'] = this.amounttype;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.donate != null) {
      data['donate'] = this.donate!.toJson();
    }
    if (this.campaign != null) {
      data['campaign'] = this.campaign!.toJson();
    }
    return data;
  }
}

class Donate {
  int? id;
  String? categoryId;
  String? title;
  String? image;
  String? percentage;
  String? target;
  String? raised;
  String? foundation;
  String? location;
  String? longitude;
  String? latitude;
  String? about;
  String? favouriteStatus;
  String? createdAt;
  String? updatedAt;

  Donate(
      {this.id,
        this.categoryId,
        this.title,
        this.image,
        this.percentage,
        this.target,
        this.raised,
        this.foundation,
        this.location,
        this.longitude,
        this.latitude,
        this.about,
        this.favouriteStatus,
        this.createdAt,
        this.updatedAt});

  Donate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
    image = json['image'];
    percentage = json['percentage'];
    target = json['target'];
    raised = json['raised'];
    foundation = json['foundation'];
    location = json['location'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    about = json['about'];
    favouriteStatus = json['favourite_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['percentage'] = this.percentage;
    data['target'] = this.target;
    data['raised'] = this.raised;
    data['foundation'] = this.foundation;
    data['location'] = this.location;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['about'] = this.about;
    data['favourite_status'] = this.favouriteStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Campaign {
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

  Campaign(
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

  Campaign.fromJson(Map<String, dynamic> json) {
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