class ContactSupportModel {
  int? id;
  String? email;
  String? number;
  String? message;
  String? createdAt;
  String? updatedAt;

  ContactSupportModel(
      {this.id,
      this.email,
      this.number,
      this.message,
      this.createdAt,
      this.updatedAt});

  ContactSupportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    number = json['number'];
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['number'] = this.number;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
