import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';

class SignUpInterestModel {
  late String name;
  late String image;
  late Color txtColor;
  late Color color;
  late Color bgColor;
}

List<SignUpInterestModel> getList() {
  List<SignUpInterestModel> list = <SignUpInterestModel>[];
  SignUpInterestModel m = SignUpInterestModel();
  m.name = "Education";
  m.image = "assets/images/Education.png";
  m.txtColor = kBlack;
  m.color = kBrightYellow;
  m.bgColor = Colors.white;
  list.add(m);

  m = SignUpInterestModel();
  m.name = "Orphanage";
  m.image = "assets/images/orphanage.png";
  m.txtColor = kBlack;
  m.color = kBrightYellow;
  m.bgColor = Colors.white;
  list.add(m);

  m = SignUpInterestModel();
  m.name = "Medical";
  m.color = kBrightYellow;
  m.image = "assets/images/medical.png";
  m.txtColor = kBlack;
  m.bgColor = Colors.white;
  list.add(m);

  m = SignUpInterestModel();
  m.name = "Disaster";
  m.color = kBrightYellow;
  m.image = "assets/images/Disaster.png";
  m.txtColor = kBlack;
  m.bgColor = Colors.white;
  list.add(m);

  m = SignUpInterestModel();
  m.name = "Animals";
  m.color = kBrightYellow;
  m.image = "assets/images/animals.png";
  m.txtColor = kBlack;
  m.bgColor = Colors.white;
  list.add(m);

  m = SignUpInterestModel();
  m.name = "Infrastructure";
  m.color = kBrightYellow;
  m.image = "assets/images/Infrastructure.png";
  m.txtColor = kBlack;
  m.bgColor = Colors.white;
  list.add(m);

  m = SignUpInterestModel();
  m.name = "Environment";
  m.color = kBrightYellow;
  m.image = "assets/images/Environment.png";
  m.txtColor = kBlack;
  m.bgColor = Colors.white;
  list.add(m);

  m = SignUpInterestModel();
  m.name = "Art";
  m.color = kBrightYellow;
  m.image = "assets/images/art.png";
  m.txtColor = kBlack;
  m.bgColor = Colors.white;
  list.add(m);

  m = SignUpInterestModel();
  m.name = "Others";
  m.color = kBrightYellow;
  m.image = "assets/images/others.png";
  m.txtColor = kBlack;
  m.bgColor = Colors.white;
  list.add(m);

  return list;
}
