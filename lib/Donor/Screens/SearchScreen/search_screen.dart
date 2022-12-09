import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/colors.dart';
import '../../Model/all_donate_model.dart';
import '../CharityScreen/charity_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  List<AllDonateModel> list = <AllDonateModel>[];

  // List<CategoryModel> catList = <CategoryModel>[];
  bool loader = false;
  bool checkConnection = false;

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      loadApi();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  loadApi() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map body = {"title": searchController.text};

    try {
      http.Response response = await http.post(Uri.parse(searchDonateURL),
          headers: {"Authorization": "Bearer $token"}, body: body);

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          AllDonateModel pos = AllDonateModel();
          pos = AllDonateModel.fromJson(obj);
          list.add(pos);
        }

        setState(() {
          loader = false;
        });
      } else {
        setState(() {
          loader = false;
        });
      }
    } catch (e) {
      print(e);
      showSnackMessage(context, "Something went worng!");
    }
  }

  addToBookMark(var id) async {
    if (await connection()) {
      submitData(id);
    } else {
      showSnackMessage(context, "Network failed\nConnect to Network");
    }
  }

  submitData(var id) async {
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
  void initState() {
    // TODO: implement initState
    //checkConnectivity();
    // catList = getList();
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
            horizontal: MediaQuery
                .of(context)
                .size
                .width * 0.06,
          ),
          child: Column(
            children: [
              Row(
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
                        MediaQuery
                            .of(context)
                            .size
                            .width * 0.015,
                      ),
                      child: Image.asset(
                        "assets/images/back.png",
                        height:
                        MediaQuery
                            .of(context)
                            .size
                            .height * 0.02,
                        width:
                        MediaQuery
                            .of(context)
                            .size
                            .width * 0.035,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text("Search",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      )),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                // height: 50,
                padding: EdgeInsets.symmetric(
                  vertical:
                  MediaQuery
                      .of(context)
                      .size
                      .height * 0.02,
                ),
                child: TextFormField(
                  cursorColor: kBrightYellow,
                  controller: searchController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Children",
                    hintStyle: GoogleFonts.montserrat(),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: introIconColorLight, width: 2),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: kGrey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: introIconColorLight, width: 2.0),
                    ),
                  ),
                  onFieldSubmitted: (va) {
                    checkConnectivity();
                  },
                ),
              ),
              const SizedBox(height: 20),
              /*SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: catList.length,
                              itemBuilder: (context, index) {
                                return itemWidget(
                                    index,
                                    catList[index].name,
                                    catList[index].color,
                                    catList[index].bgColor);
                              },
                            ),
                          ),*/
              const SizedBox(height: 20),
              list.isEmpty ?
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.3
                ),
                child: Text("No charity found" , style:GoogleFonts.montserrat()),
              ) :
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var a = list[index].percentage!;
                  double per = double.parse(a.toString());
                  double percent = per / 100;
                  return InkWell(
                    onTap: () {
                      navigatePush(
                          context,
                          CharityDetail(
                            donateType: "1",
                            model: list[index],
                          ));
                    },
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      //height: MediaQuery.of(context).size.height * 0.59,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kWhite,
                      ),
                      padding: EdgeInsets.all(
                          MediaQuery
                              .of(context)
                              .size
                              .width *
                              0.036),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height *
                                    0.25,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  child: FadeInImage(
                                    placeholder: const AssetImage(
                                        "assets/images/placeholder.png"),
                                    image: NetworkImage(
                                        list[index].image!),
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
                                  addToBookMark(list[index].id);
                                },
                                child: Container(
                                  margin:
                                  const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 8),
                                  child: const CircleAvatar(
                                    radius: 15,
                                    backgroundImage: AssetImage(
                                        "assets/images/Icon.png"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:
                            MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.025,
                          ),
                          Text(
                            list[index].title!,
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height:
                            MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.03,
                          ),
                          LinearPercentIndicator(
                            padding: EdgeInsets.only(
                                right: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.03),
                            width:
                            MediaQuery
                                .of(context)
                                .size
                                .width *
                                0.8,
                            animation: true,
                            curve: Curves.bounceInOut,
                            barRadius: const Radius.circular(2),
                            lineHeight: 8,
                            percent: percent,
                            progressColor: kBrightYellow,
                          ),
                          SizedBox(
                            height:
                            MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.01,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              right: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.03,
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Raised",
                                    style:
                                    GoogleFonts.montserrat()),
                                Text("${list[index].percentage}%",
                                    style:
                                    GoogleFonts.montserrat()),
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

/*Widget itemWidget(int index, String name, Color color, Color bgColor) {
    return InkWell(
      onTap: () {
        setState(() {
          catList = getList();
          catList[index].color = kWhite;
          catList[index].bgColor = kBrightYellow;
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
  }*/
}
