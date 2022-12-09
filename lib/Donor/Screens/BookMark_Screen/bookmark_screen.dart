import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/navigator.dart';
import '../../../Widgets/book_mark/empty_book_mark.dart';
import '../../Model/all_donate_model.dart';
import '../../Model/bookmarkDonateModel.dart';
import '../../Model/donate_category_model.dart';
import '../CharityScreen/charity_detail.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<BookmarkDonateModel> list = <BookmarkDonateModel>[];
  List<BookmarkDonateModel> bookmarkList = <BookmarkDonateModel>[];
  List<DonateCategoryModel> cateList = <DonateCategoryModel>[];

  String category = "-1";
  bool loader = false;
  bool checkConnection = false;

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      loadCateApi();
      loadBookmarkApi();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  loadBookmarkApi() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      http.Response response = await http.get(Uri.parse(getBookmarkDonateURL),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          BookmarkDonateModel pos = BookmarkDonateModel();
          pos = BookmarkDonateModel.fromJson(obj);
          list.add(pos);
        }
        if (category == "-1") {
          bookmarkList.addAll(list);
        }
        print(bookmarkList.length);
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

  loadCateApi() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      http.Response response = await http.get(Uri.parse(allDonateCategoryURL),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);
      print(jsonData);
      if (jsonData['statusCode'] == 200) {
        DonateCategoryModel p = DonateCategoryModel();
        p.name = "All";
        p.id = 0;
        p.color = kWhite;
        p.bgColor = kBrightYellow;
        cateList.add(p);

        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          DonateCategoryModel pos = DonateCategoryModel();
          pos = DonateCategoryModel.fromJson(obj);
          pos.color = kBlack;
          pos.bgColor = kWhite;
          cateList.add(pos);
        }
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, "Something went wrong");
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      showSnackMessage(context, "Something went wrong");
    }
  }

  loadCateBookMark() {
    if (category == '-1') {
      setState(() {
        bookmarkList.clear();
        bookmarkList.addAll(list);
      });
    } else {
      List<BookmarkDonateModel> ll = <BookmarkDonateModel>[];
      for (int i = 0; i < list.length; i++) {
        if (category == list[i].donate?.categoryId) {
          ll.add(list[i]);
        }
      }
      setState(() {
        bookmarkList.clear();
        bookmarkList.addAll(ll);
      });
    }
  }

  removeBookMark(BookmarkDonateModel model) async {
    if (await connection()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      Map body = {"donate_id": model.donate?.id.toString()};
      setState(() {
        loader = true;
      });
      try {
        http.Response response = await http.post(Uri.parse(removeBookMarkURL),
            headers: {"Authorization": "Bearer $token"}, body: body);
        print(body);
        Map jsonData = jsonDecode(response.body);
        print(jsonData);

        if (jsonData['statusCode'] == 200) {
          setState(() {
            list.remove(model);
            loadCateBookMark();
          });
          //loadDonateList();
          showSnackMessage(context, "Successfully removed from BookMark");
        } else {
          showSnackMessage(context, "Something went wrong!");
        }
      } catch (e) {
        print(e);
        showSnackMessage(context, "Something went wrong!");
      }
    } else {
      showSnackMessage(context, "Network failed\nConnect to Network");
    }
    setState(() {
      loader = false;
    });
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
                      horizontal: MediaQuery.of(context).size.width * 0.03,
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
                                  MediaQuery.of(context).size.width * 0.015,
                                ),
                                child: Image.asset(
                                  "assets/images/back.png",
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  width:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Bookmark",
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cateList.length,
                            itemBuilder: (context, index) {
                              return itemWidget(
                                  index,
                                  cateList[index].name.toString(),
                                  cateList[index].color,
                                  cateList[index].bgColor);
                            },
                          ),
                        ),
                        bookmarkList.isEmpty
                            ? emptyBookMarkWidget(context)
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: bookmarkList.length,
                                itemBuilder: (context, index) {
                                  return itemBookMarkWidget(
                                      index, bookmarkList);
                                }),
                      ],
                    ),
                  ),
          ));
  }

  Widget itemWidget(int index, String name, Color? color, Color? bgColor) {
    return InkWell(
      onTap: () {
        for (int i = 0; i < cateList.length; i++) {
          setState(() {
            cateList[i].color = kBlack;
            cateList[i].bgColor = kWhite;
          });
        }
        setState(() {
          cateList[index].color = kWhite;
          cateList[index].bgColor = kBrightYellow;
          if (index == 0) {
            category = '-1';
          } else {
            category = cateList[index].id.toString();
          }
        });
        loadCateBookMark();
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
        child: Text(
          name,
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget itemBookMarkWidget(int index, List<BookmarkDonateModel> thisList) {
    var a = thisList[index].donate!.percentage;
    double percent = 0.0;
    if (a == null || a.toString().isEmpty) {
      percent = 0.0;
    } else {
      double per = double.parse(a.toString());
      percent = per / 100;
    }
    return InkWell(
      onTap: () {
        Donate donate = thisList[index].donate!;
        AllDonateModel model = AllDonateModel();
        model.title = donate.title;
        model.id = donate.id;
        model.categoryId = donate.categoryId;
        model.image = donate.image;
        model.percentage = donate.percentage;
        model.target = donate.target;
        model.raised = donate.raised;
        model.foundation = donate.foundation;
        model.location = donate.location;
        model.longitude = donate.longitude;
        model.latitude = donate.latitude;
        model.about = donate.about;
        model.favouriteStatus = donate.favouriteStatus;
        model.createdAt = donate.createdAt;
        model.updatedAt = donate.updatedAt;
        /////////////////////////////////////

        navigatePush(context, CharityDetail(donateType: "1", model: model));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15),
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
                      image: NetworkImage("${thisList[index].donate?.image}"),
                    ),
                    /*Image.asset(
                                'assets/icons/check.png',
                                fit: BoxFit.cover,
                              ),*/
                  ),
                ),
                InkWell(
                  onTap: () {
                    removeBookMark(thisList[index]);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          thisList[index].donate!.favouriteStatus == "1"
                              ? kBrightYellow
                              : Colors.white,
                      child: Icon(
                        Icons.bookmark,
                        color: thisList[index].donate!.favouriteStatus == "1"
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
              "${thisList[index].donate!.title}",
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
                  Text("${thisList[index].donate!.percentage}%",
                      style: GoogleFonts.montserrat()),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
