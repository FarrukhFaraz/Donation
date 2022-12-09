class CharityPaymentModel {
  int? id;
  String? userId;
  String? donatetype;
  String? donateId;
  Null? campaignId;
  String? amounttype;
  String? amount;
  String? createdAt;
  String? updatedAt;
  User? user;

  CharityPaymentModel(
      {this.id,
        this.userId,
        this.donatetype,
        this.donateId,
        this.campaignId,
        this.amounttype,
        this.amount,
        this.createdAt,
        this.updatedAt,
        this.user});

  CharityPaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    donatetype = json['donatetype'];
    donateId = json['donate_id'];
    campaignId = json['campaign_id'];
    amounttype = json['amounttype'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
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
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? image;
  String? email;
  String? phone;
  String? country;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.name,
        this.image,
        this.email,
        this.phone,
        this.country,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    phone = json['phone'];
    country = json['country'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['country'] = this.country;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}