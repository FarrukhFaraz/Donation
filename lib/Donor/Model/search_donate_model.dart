class SearchDonateModel {
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
  String? createdAt;
  String? updatedAt;

  SearchDonateModel(
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
        this.createdAt,
        this.updatedAt});

  SearchDonateModel.fromJson(Map<String, dynamic> json) {
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
