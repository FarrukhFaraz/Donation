import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Charity/charity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/CheckConnection.dart';
import '../Utils/colors.dart';
import '../Utils/messages.dart';
import '../Utils/navigator.dart';
import '../Utils/offline_ui.dart';
import '../Utils/url.dart';
import 'Model/all_charity_model.dart';
import 'charity_drawer.dart';

class AllCharity extends StatefulWidget {
  const AllCharity({Key? key }) : super(key: key);

  @override
  State<AllCharity> createState() => _AllCharityState();
}

class _AllCharityState extends State<AllCharity> {
  GlobalKey<ScaffoldState> key = GlobalKey();

  bool loader = false;
  bool checkConnection = false;

  List<AllCharityModel> list = <AllCharityModel>[];

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
    var charityId = prefs.getString('charityId');
    try {
      http.Response response = await http.get(Uri.parse(charityCategoryByIdURL+charityId.toString()),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          AllCharityModel pos = AllCharityModel();
          pos = AllCharityModel.fromJson(obj);
          list.add(pos);
        }
        setState(() {
          loader = false;
        });
        showSnackMessage(context, "Data Found Successfully");
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

  @override
  Widget build(BuildContext context) {
    return checkConnection
        ? OfflineUI(function: checkConnectivity)
        : SafeArea(
            child: Scaffold(
            key: key,
            backgroundColor: bgColor,
            drawer: const CharityDrawer(),
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
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.018),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.06,
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    key.currentState!.openDrawer();
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: kWhite,
                                      ),
                                      padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.015,
                                      ),
                                      child: Image.asset(
                                        "assets/images/drawer.png",
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                        // fit: BoxFit.cover,
                                      ))),
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "All Charity",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(fontSize: 17)),
                                      ))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        list.isEmpty
                            ? Container(
                          alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.4),
                                child: Text(
                                  "No charity found",
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

  Widget itemListWidget(int index, AllCharityModel donateModel) {
    //var a = donateModel.;
    // double percent = 0.0;
    // if (a.toString().isEmpty || a == null) {
    //   percent = 0.0;
    // } else {
    //   double perc = double.parse(a.toString());
    //   percent = perc / 100;
    // }

    return InkWell(
      onTap: () {
        navigatePush(
            context,
            Charity2(
              model: donateModel,
            ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height * 0.59,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: kWhite,
        ),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.018),
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
                /*InkWell(
                  onTap: () {
                    if (donateModel.favouriteStatus == '1') {
                      removeBookMark(index ,donateModel.id);
                    } else {
                      addToBookMar( index,donateModel.id);
                    }
                  },
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: CircleAvatar(
                      backgroundColor: donateModel.favouriteStatus=='1'
                          ? kBrightYellow
                          : Colors.white,
                      radius: 15,
                      child: Icon(
                        Icons.bookmark,
                        color: donateModel.favouriteStatus=='1'
                            ? Colors.white
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),*/
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
            // LinearPercentIndicator(
            //   padding: EdgeInsets.only(
            //       right: MediaQuery.of(context).size.width * 0.03),
            //   width: MediaQuery.of(context).size.width * 0.8,
            //   animation: true,
            //   curve: Curves.bounceInOut,
            //   barRadius: const Radius.circular(2),
            //   lineHeight: 8,
            //   percent: percent,
            //   progressColor: kBrightYellow,
            // ),
            //Text(list[index].founded!,style: GoogleFonts.montserrat(),),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.01,
            // ),
            // // Container(
            // //   padding: EdgeInsets.only(
            // //     right: MediaQuery.of(context).size.width * 0.03,
            // //   ),
            // //   child: Row(
            // //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // //     children: [
            // //       Text("Raised", style: GoogleFonts.montserrat()),
            // //       Text("${donateModel.percentage}%",
            // //           style: GoogleFonts.montserrat()),
            // //     ],
            // //   ),
            // // ),
            //const SizedBox(height: 15),
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
