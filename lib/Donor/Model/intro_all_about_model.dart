class IntroAllAboutModel {
  int? id;
  String? welcome;
  String? donation;
  String? fundraising;
  String? wallet;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? about;
  String? vision;
  String? mission;

  IntroAllAboutModel(
      {this.id,
      this.welcome,
      this.donation,
      this.fundraising,
      this.wallet,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.about,
      this.vision,
      this.mission});

  IntroAllAboutModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    welcome = json['welcome'];
    donation = json['donation'];
    fundraising = json['fundraising'];
    wallet = json['wallet'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    about = json['about'];
    vision = json['vision'];
    mission = json['mission'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['welcome'] = this.welcome;
    data['donation'] = this.donation;
    data['fundraising'] = this.fundraising;
    data['wallet'] = this.wallet;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    data['about'] = this.about;
    data['vision'] = this.vision;
    data['mission'] = this.mission;
    return data;
  }
}
