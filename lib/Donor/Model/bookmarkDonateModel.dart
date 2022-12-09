class BookmarkDonateModel {
  int? id;
  String? userId;
  String? donateId;
  String? createdAt;
  String? updatedAt;
  Donate? donate;

  BookmarkDonateModel(
      {this.id,
        this.userId,
        this.donateId,
        this.createdAt,
        this.updatedAt,
        this.donate});

  BookmarkDonateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    donateId = json['donate_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    donate =
    json['donate'] != null ? new Donate.fromJson(json['donate']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['donate_id'] = this.donateId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.donate != null) {
      data['donate'] = this.donate!.toJson();
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