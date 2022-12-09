import 'dart:ui';

import 'package:give_alil_bit_new/Utils/colors.dart';

class CategoryModel {
  late String name;
  late Color color;
  late Color bgColor;
}

List<CategoryModel> getList() {
  List<CategoryModel> list = <CategoryModel>[];

  CategoryModel m = CategoryModel();
  m.name = "All";
  m.color = kBlack;
  m.bgColor = kWhite;
  list.add(m);

  m = CategoryModel();
  m.name = "Education";
  m.color = kBlack;
  m.bgColor = kWhite;
  list.add(m);

  m = CategoryModel();
  m.name = "Orphanage";
  m.color = kBlack;
  m.bgColor = kWhite;
  list.add(m);

  m = CategoryModel();
  m.name = "Medical";
  m.color = kBlack;
  m.bgColor = kWhite;
  list.add(m);

  m = CategoryModel();
  m.name = "Disaster";
  m.color = kBlack;
  m.bgColor = kWhite;
  list.add(m);

  m = CategoryModel();
  m.name = "Animals";
  m.color = kBlack;
  m.bgColor = kWhite;
  list.add(m);

  m = CategoryModel();
  m.name = "Art";
  m.color = kBlack;
  m.bgColor = kWhite;
  list.add(m);

  m = CategoryModel();
  m.name = "Environment";
  m.color = kBlack;
  m.bgColor = kWhite;
  list.add(m);

  return list;
}
