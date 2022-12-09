import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Donor/Model/donate_category_model.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/colors.dart';

class HomeCategoryItemWidget extends StatefulWidget {
  const HomeCategoryItemWidget({Key? key}) : super(key: key);

  @override
  State<HomeCategoryItemWidget> createState() => _HomeCategoryItemWidgetState();
}

class _HomeCategoryItemWidgetState extends State<HomeCategoryItemWidget> {
  List<DonateCategoryModel> list = <DonateCategoryModel>[];

  bool checkConnection = false;
  bool loader = false;

  loadData() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      http.Response response = await http.get(Uri.parse(allDonateCategoryURL),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);
      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          DonateCategoryModel pos = DonateCategoryModel();
          pos = DonateCategoryModel.fromJson(obj);
          if (i == 0) {
            pos.color = kWhite;
            pos.bgColor = kBrightYellow;
          } else {
            pos.color = kBlack;
            pos.bgColor = kWhite;
          }
          list.add(pos);
        }
        setState(() {
          loader = false;
        });
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, "Something went wrong!");
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      showSnackMessage(context, "Network failed");
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.06,
      ),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return itemWidget(index, list[index].name.toString(),
              list[index].color, list[index].bgColor);
        },
      ),
    );
  }

  Widget itemWidget(int index, String name, Color? color, Color? bgColor) {
    return InkWell(
      onTap: () {
        for (int i = 0; i < list.length; i++) {
          setState(() {
            list[i].bgColor = kWhite;
            list[i].color = kBlack;
          });
        }
        setState(() {
          list[index].color = kWhite;
          list[index].bgColor = kBrightYellow;
        });
      },
      child: Container(
        margin:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.04),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: bgColor,
        ),
        alignment: Alignment.center,
        child: Text(name,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
            )),
      ),
    );
  }
}
