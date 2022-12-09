import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Donor/Screens/Notification/notification_screen.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/CheckConnection.dart';
import '../../../Utils/messages.dart';
import '../../../Utils/navigator.dart';
import '../../../Utils/url.dart';
import '../../Model/all_donate_model.dart';
import '../../Model/donates_by_category.dart';
import 'charity_detail.dart';

class CharityScreen extends StatefulWidget {
  const CharityScreen({Key? key, required this.id, required this.txt})
      : super(key: key);

  final int id;
  final String txt;

  @override
  State<CharityScreen> createState() => _CharityScreenState();
}

class _CharityScreenState extends State<CharityScreen> {
  bool loader = false;
  bool checkConnection = false;

  List<Donates> list = <Donates>[];

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      loadData();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  loadData() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      http.Response response = await http.get(Uri.parse(donatesByCategoryUrl),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          DonateByCategoryModel pos = DonateByCategoryModel();
          pos = DonateByCategoryModel.fromJson(obj);
          if (widget.id == -1) {
            list.addAll(pos.donates!);
          } else {
            if (pos.id == widget.id) {
              list.addAll(pos.donates!);
            }
          }
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
    checkConnectivity();
    super.initState();
  }

  addToBookMar(int index, var id) async {
    if (await connection()) {
      submitData(index, id);
    } else {
      showSnackMessage(context, "Network failed\nConnect to Network");
    }
  }

  removeBookMark(int index, var id) async {
    if (await connection()) {
      setState(() {
        loader = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      Map body = {"donate_id": id.toString()};
      print(id);
      try {
        http.Response response = await http.post(Uri.parse(removeBookMarkURL),
            headers: {"Authorization": "Bearer $token"}, body: body);
        print(body);
        Map jsonData = jsonDecode(response.body);
        print(jsonData);

        if (jsonData['statusCode'] == 200) {
          setState(() {
            list[index].favouriteStatus = '0';
          });
          showSnackMessage(context, "Successfully removed from BookMark");
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
        showSnackMessage(context, "Something went wrong!");
      }
    } else {
      showSnackMessage(context, "Network failed\nConnect to Network");
    }
  }

  submitData(int index, var id) async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    Map body = {"donate_id": id.toString()};
    print(id);
    try {
      http.Response response = await http.post(Uri.parse(addDonateBookMark),
          headers: {"Authorization": "Bearer $token"}, body: body);
      print(body);
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        setState(() {
          list[index].favouriteStatus = '1';
        });
        showSnackMessage(context, "Successfully added to BookMark");
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
      showSnackMessage(context, "Something went wrong!");
    }
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.06,
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: kWhite,
                                  ),
                                  // height: MediaQuery.of(context).size.height * 0.045,
                                  //  width: MediaQuery.of(context).size.width * 0.09,
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.015,
                                  ),
                                  child: Image.asset(
                                    "assets/images/back.png",
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                    width: MediaQuery.of(context).size.width *
                                        0.035,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(widget.txt,
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  navigatePush(
                                      context, const NotificationScreen());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: kWhite,
                                  ),
                                  // height: MediaQuery.of(context).size.height * 0.045,
                                  //  width: MediaQuery.of(context).size.width * 0.09,
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.015,
                                  ),
                                  child: Image.asset(
                                    "assets/images/notification.png",
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                    width: MediaQuery.of(context).size.width *
                                        0.035,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        list.isEmpty
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.4),
                                child: Text(
                                  "No charity found in this category",
                                  style: GoogleFonts.montserrat(),
                                ))
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.06,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return itemListWidget(index, list[index]);
                                },
                              )
                      ],
                    ),
                  ),
          ));
  }

  Widget itemListWidget(int index, Donates donateModel) {
    var a = donateModel.percentage;
    double percent = 0.0;
    if (a.toString().isEmpty || a == null) {
      percent = 0.0;
    } else {
      double perc = double.parse(a.toString());
      percent = perc / 100;
    }

    return InkWell(
      onTap: () {
        AllDonateModel model = AllDonateModel(
            about: donateModel.about,
            categoryId: donateModel.categoryId,
            createdAt: donateModel.createdAt,
            foundation: donateModel.foundation,
            id: donateModel.id,
            image: donateModel.image,
            latitude: donateModel.latitude,
            location: donateModel.location,
            longitude: donateModel.longitude,
            percentage: donateModel.percentage,
            raised: donateModel.raised,
            target: donateModel.target,
            title: donateModel.title,
            updatedAt: donateModel.updatedAt);
        navigatePush(context, CharityDetail(donateType:"1" ,model: model));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height * 0.59,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: kWhite,
        ),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.036),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage(
                      placeholder:
                          const AssetImage("assets/images/placeholder.png"),
                      image: NetworkImage(donateModel.image!),
                      fit: BoxFit.cover,
                    ),
                    // Image.asset(
                    //   'assets/icons/check.png',
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (donateModel.favouriteStatus == '1') {
                      removeBookMark(index, donateModel.id);
                    } else {
                      addToBookMar(index, donateModel.id);
                    }
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: CircleAvatar(
                      backgroundColor: donateModel.favouriteStatus == '1'
                          ? kBrightYellow
                          : Colors.white,
                      radius: 15,
                      child: Icon(
                        Icons.bookmark,
                        color: donateModel.favouriteStatus == '1'
                            ? Colors.white
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Text(
              donateModel.title!,
              style: GoogleFonts.montserrat(
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            LinearPercentIndicator(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.03),
              width: MediaQuery.of(context).size.width * 0.8,
              animation: true,
              curve: Curves.bounceInOut,
              barRadius: const Radius.circular(2),
              lineHeight: 8,
              percent: percent,
              progressColor: kBrightYellow,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Raised", style: GoogleFonts.montserrat()),
                  Text("${donateModel.percentage}%",
                      style: GoogleFonts.montserrat()),
                ],
              ),
            ),
            const SizedBox(height: 15),
            /* Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const CircleAvatar(
                                            radius: 25,
                                            backgroundImage: AssetImage(
                                                "assets/icons/check.png"),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "John William",
                                                style: GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                        color: kBlack,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14)),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "San Diego, CA",
                                                style: GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                        color: kGrey,
                                                        fontSize: 12)),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),*/
          ],
        ),
      ),
    );
  }
}
