import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Charity/Model/all_charity_model.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/CheckConnection.dart';
import '../Utils/messages.dart';
import '../Utils/navigator.dart';
import '../Utils/url.dart';
import 'charity.dart';
import 'empty_detail.dart';

class CharityProfile extends StatefulWidget {
  const CharityProfile({Key? key}) : super(key: key);

  @override
  State<CharityProfile> createState() => _CharityProfileState();
}

class _CharityProfileState extends State<CharityProfile> {
  String name = "";
  String tex = "";
  String mission = "";

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('charityName').toString();
      tex = prefs.getString('charityTex').toString();
      mission = prefs.getString('charityMission').toString();
    });
    print('name:$name \ntex:$tex\nmission:$mission');
  }

  bool checkConnection = false;
  bool loader = false;
  List<AllCharityModel> list = <AllCharityModel>[];

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });

      loadDetailData();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  loadDetailData() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var charityId = prefs.getString('charityId');
    var token = prefs.getString('token');
    print(token);
    print(charityId);
    try {
      http.Response response = await http.get(Uri.parse(allCharityURL),
          headers: {"Authorization": "Bearer $token"});
      Map jsonData = jsonDecode(response.body);
      print(jsonData);
      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          AllCharityModel pos = AllCharityModel();
          pos = AllCharityModel.fromJson(obj);
          if (pos.id.toString() == charityId.toString()) {
            list.add(pos);
          }
        }
        print(list.length);
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
      showSnackMessage(context, "Something went wrong!");
    }
  }

  @override
  void initState() {
    loadData();
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
            body: Center(
              child: loader
                  ? const CircularProgressIndicator()
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: MediaQuery.of(context).size.width * 0.06,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            //height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: kWhite),
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.06,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.04,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03),
                                Row(
                                  children: [
                                    Text(
                                      "Name:",
                                      style: GoogleFonts.montserrat(),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.07,
                                    ),
                                    Text(
                                      name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Tax EIN",
                                      style: GoogleFonts.montserrat(),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.07,
                                    ),
                                    Text(
                                      tex,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Mission",
                                      style: GoogleFonts.montserrat(),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.07,
                                    ),
                                    Text(
                                      mission,
                                      maxLines: 6,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                InkWell(
                                  onTap: () {
                                    if (list.isEmpty) {
                                      navigatePush(
                                          context, const CharityEmptyDetail());
                                    } else {
                                      navigatePush(
                                          context, Charity2(model: list[0]));
                                    }
                                  },
                                  child: Text(
                                    "View charity detail",
                                    style: GoogleFonts.montserrat(
                                        textStyle:
                                            TextStyle(color: kBrightYellow)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ));
  }
}
