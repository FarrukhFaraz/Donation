import 'dart:ui';

class DonateCategoryModel {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  Color? color;
  Color? bgColor;

  DonateCategoryModel({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.color,
    this.bgColor,
  });

  DonateCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}