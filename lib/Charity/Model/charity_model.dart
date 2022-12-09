class CharityModel {
  int? id;
  String? categoryId;
  String? title;
  String? image;
  String? location;
  String? phone;
  String? email;
  String? website;
  String? facebook;
  String? instagram;
  String? cateDesc;
  String? about;
  String? founded;
  String? createdAt;
  String? updatedAt;

  CharityModel(
      {this.id,
        this.categoryId,
        this.title,
        this.image,
        this.location,
        this.phone,
        this.email,
        this.website,
        this.facebook,
        this.instagram,
        this.cateDesc,
        this.about,
        this.founded,
        this.createdAt,
        this.updatedAt});

  CharityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
    image = json['image'];
    location = json['location'];
    phone = json['phone'];
    email = json['email'];
    website = json['website'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    cateDesc = json['cate_desc'];
    about = json['about'];
    founded = json['founded'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['website'] = this.website;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['cate_desc'] = this.cateDesc;
    data['about'] = this.about;
    data['founded'] = this.founded;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}