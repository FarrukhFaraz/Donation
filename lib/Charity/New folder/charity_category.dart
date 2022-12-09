import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Charity/Model/charity_model.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/colors.dart';
import '../../Utils/url.dart';
import '../Model/charity_category_model.dart';
import '../all_charity.dart';

class CharityCategoryScreen extends StatefulWidget {
  const CharityCategoryScreen({super.key});

  @override
  State<CharityCategoryScreen> createState() => _CharityCategoryScreenState();
}

class _CharityCategoryScreenState extends State<CharityCategoryScreen> {
  List<CharityCategoryModel> cateList = <CharityCategoryModel>[];
  List<CharityModel> itemList = <CharityModel>[];

  String charityId = "-1";

  bool loader = false;
  bool checkConnection = false;
  bool itemData = false;
  bool itemConnection = false;
  bool itemLoader = false;

  String index = "-1";

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      fetchCateData();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  fetchCateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loader = true;
    });
    var token = prefs.getString('token');

    try {
      http.Response response = await http.get(Uri.parse(charityCategoryURL),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          CharityCategoryModel pos = CharityCategoryModel();
          pos = CharityCategoryModel.fromJson(obj);
          pos.color = kBlack;
          pos.bgColor = kWhite;
          cateList.add(pos);
        }
        setState(() {
          loader = false;
        });
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, "Unable to load Category");
      }
    } catch (e) {
      print("Network Exception");
      showSnackMessage(context, "Network Failed");
      setState(() {
        loader = false;
        checkConnection = true;
      });
    }
  }

  fetchItemData() async {
    setState(() {
      itemList.clear();
      if (itemData) {
        itemLoader = true;
      } else {
        loader = true;
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    String url = "";
    setState(() {
      if (index == "-1") {
        url = allCharityURL;
      } else {
        url = charityCategoryByIdURL + index.toString();
      }
    });

    try {
      http.Response response = await http
          .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);
      print(jsonData);
      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          CharityModel pos = CharityModel();
          pos = CharityModel.fromJson(obj);
          itemList.add(pos);
        }
        setState(() {
          loader = false;
          itemLoader = false;
          itemData = false;
        });
      } else {
        showSnackMessage(context, "Something went wrong!");
        setState(() {
          loader = false;
          itemLoader = false;
          itemData = false;
        });
      }
    } catch (e) {
      print(e);
      showSnackMessage(context, "Something went wrong!");
      setState(() {
        loader = false;
        itemLoader = false;
        itemData = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return checkConnection
        ? OfflineUI(function: checkConnectivity)
        : SafeArea(
            child: Scaffold(
              backgroundColor: bgColor,
              body: loader
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: MediaQuery.of(context).size.width * 0.06,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("Categories",
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.8,
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: cateList.length,
                              itemBuilder: (context, index) {
                                return itemWidget(index, cateList[index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
  }

  Widget itemWidget(int ind, CharityCategoryModel model) {
    return InkWell(
      onTap: () async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('charityId' , model.id.toString());
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AllCharity()));
      },
      child: Container(
        margin:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.04),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: model.bgColor,
        ),
        alignment: Alignment.center,
        child: Text(model.name.toString(),
            style: GoogleFonts.montserrat(
              textStyle:
                  TextStyle(color: model.color, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
