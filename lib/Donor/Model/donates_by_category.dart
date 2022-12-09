class DonateByCategoryModel {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  List<Donates>? donates;

  DonateByCategoryModel(
      {this.id, this.name, this.createdAt, this.updatedAt, this.donates});

  DonateByCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['donates'] != null) {
      donates = <Donates>[];
      json['donates'].forEach((v) {
        donates!.add(new Donates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.donates != null) {
      data['donates'] = this.donates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Donates {
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

  Donates(
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

  Donates.fromJson(Map<String, dynamic> json) {
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
