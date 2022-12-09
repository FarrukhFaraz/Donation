import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/colors.dart';
import '../../Utils/drawer.dart';
import '../../Utils/url.dart';
import '../../Widgets/home/home_auction_item_widget.dart';
import '../../Widgets/home/home_item.dart';
import '../Model/all_campaign_model.dart';
import '../Model/all_donate_model.dart';
import '../Model/donate_category_model.dart';
import '../Screens/BookMark_Screen/bookmark_screen.dart';
import '../Screens/CharityScreen/all_charity_category.dart';
import '../Screens/CharityScreen/charity_detail.dart';
import '../Screens/CharityScreen/charity_screen.dart';
import '../Screens/Notification/notification_screen.dart';
import '../Screens/SearchScreen/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> key = GlobalKey();

  bool loader = false;
  bool checkConnection = false;

  bool nearNotFound = false;

  int catId = 0;
  int ind = 0;

  List<DonateCategoryModel> cateList = <DonateCategoryModel>[];
  List<AllDonateModel> donateList = <AllDonateModel>[];
  List<AllCampaignModel> auctionList = <AllCampaignModel>[];
  List<AllDonateModel> nearDonateList = <AllDonateModel>[];

  List<String> imgList = [];
  String text = "No donates found near you";

  loadNearestDonor(double lati , double longi) async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      http.Response response = await http.get(Uri.parse("$getNearestDonorURL$lati/$longi"),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          AllDonateModel pos = AllDonateModel();
          pos = AllDonateModel.fromJson(obj);
          nearDonateList.add(pos);
        }
        print('NearDonateList:  ${nearDonateList.length}');

        setState(() {
          loader = false;
          nearNotFound = false;
        });
      } else {
        setState(() {
          loader = false;
          nearNotFound = true;
        });
        print('not data found in your location');
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
        nearNotFound = true;
      });
      showSnackMessage(context, 'Something went wrong');
    }
  }
  String? currentAddress;
  Position? currentPosition;

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("LOCATION :  OFF");
      setState(() {
        text="Turn on location";
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    print("LOCATION :  ON");
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("LOCATION :  PERMISSION DENIED");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print("LOCATION :  PERMANENTLY DENIED");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print("LOCATION :  $position");
      loadNearestDonor(position.latitude , position.longitude);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  loadCourselList() async {
    setState(() {
      loader = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      http.Response response = await http.get(Uri.parse(courselImageURL),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          imgList.add(jsonData['data'][i]);
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

  loadCateList() async {
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
        setState(() {
          loader = false;
        });
        print("List : ${cateList.length}");
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

  loadDonateList() async {
    setState(() {
      loader = true;
      donateList.clear();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      http.Response response = await http.get(Uri.parse(allDonateURL),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          AllDonateModel pos = AllDonateModel();
          pos = AllDonateModel.fromJson(obj);
          donateList.add(pos);
        }
        setState(() {
          loader = false;
        });
        print("Charity List : ${donateList.length}");
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, "Something went wrong!");
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      print(e);
      showSnackMessage(context, "Network failed");
    }
  }

  loadCampaignList() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      http.Response response = await http.get(Uri.parse(allCampaignURL),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          AllCampaignModel pos = AllCampaignModel();
          pos = AllCampaignModel.fromJson(obj);
          auctionList.add(pos);

          setState(() {
            loader = false;
          });
        }
      } else {
        setState(() {
          loader = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
    }
  }

  checkConnectivity() async {
    setState(() {
      loader = true;
    });
    if (await connection()) {
      setState(() {
        checkConnection = false;
        loader = true;
      });

      loadCateList();
      loadCourselList();
      loadDonateList();
      loadCampaignList();
    } else {
      setState(() {
        checkConnection = true;
      });
      setState(() {
        loader = false;
      });
    }
  }

  addToBookMark(AllDonateModel model) async {
    if (await connection()) {
      setState(() {
        loader = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      Map body = {"donate_id": model.id.toString()};

      try {
        http.Response response = await http.post(Uri.parse(addDonateBookMark),
            headers: {"Authorization": "Bearer $token"}, body: body);
        print(body);
        Map jsonData = jsonDecode(response.body);
        print(jsonData);

        if (jsonData['statusCode'] == 200) {
          //loadDonateList();
          setState(() {
            donateList[0].favouriteStatus = '1';
            loader = false;
          });
          showSnackMessage(context, "Successfully added to BookMark");
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
    } else {
      showSnackMessage(context, "Network failed\nConnect to Network");
    }
  }

  removeBookMark(AllDonateModel model) async {
    if (await connection()) {
      setState(() {
        loader = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      Map body = {"donate_id": model.id.toString()};

      try {
        http.Response response = await http.post(Uri.parse(removeBookMarkURL),
            headers: {"Authorization": "Bearer $token"}, body: body);
        print(body);
        Map jsonData = jsonDecode(response.body);
        print(jsonData);

        if (jsonData['statusCode'] == 200) {
          setState(() {
            loader = false;
            donateList[0].favouriteStatus = '0';
          });
          //loadDonateList();
          showSnackMessage(context, "Successfully removed from BookMark");
        } else {
          setState(() {
            loader = false;
          });
          showSnackMessage(context, "Something went wrong!");
        }
      } catch (e) {
        setState(() {
          loader = false;
        });
        print(e);
        showSnackMessage(context, "Something went wrong!");
      }
    } else {
      showSnackMessage(context, "Network failed\nConnect to Network");
    }
  }

  /*requestLocationPermission() async {
    Location location = Location();
    PermissionStatus permissionStatus;

    permissionStatus = await location.requestPermission();

    if (permissionStatus == PermissionStatus.granted) {
      print("Location is granted");
      if(await hasService()){
        print('location is on');
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      }else{
        print('location is off');
        setState(() {
          text="Enable the Location";
        });
      }

    } else if (permissionStatus == PermissionStatus.denied) {
      requestLocationPermission();
      print("Permission is rationally denied");
    } else if (permissionStatus == PermissionStatus.deniedForever) {
      print("Permission is permanantly denied ");
      setState(() {
        text="You have permanently denied location permission";
      });
    }
  }*/

  @override
  void initState() {
    // TODO: implement initState
    checkConnectivity();
    getCurrentPosition();
    //  requestPermission();
    //requestLocationPermission();
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
            drawer: const DrawerScreen(),
            body: loader
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.025,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
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
                              const Expanded(child: Text("")),
                              InkWell(
                                  onTap: () {
                                    navigatePush(
                                        context, const BookmarkScreen());
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
                                        "assets/images/book_mark.png",
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                      ))),
                              const SizedBox(width: 8),
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
                                      //height: MediaQuery.of(context).size.height * 0.045,
                                      // width: MediaQuery.of(context).size.width * 0.09,
                                      padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.015,
                                      ),
                                      child: Image.asset(
                                        "assets/images/notification.png",
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                      ))),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  navigatePush(context, const SearchScreen());
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
                                    "assets/images/search.png",
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
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.035),

                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.26,
                              child: ListView(
                                shrinkWrap: true,
                                //physics: NeverScrollableScrollPhysics(),
                                children: [
                                  CarouselSlider(
                                    items: imgList
                                        .map((item) => Container(
                                      margin: const EdgeInsets.symmetric( horizontal:6.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: NetworkImage(item),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                    //Slider Container properties
                                    options: CarouselOptions(
                                      onPageChanged: (z, res) {
                                        setState(() {
                                          ind = z;
                                        });
                                      },
                                      height:
                                      MediaQuery.of(context).size.height * 0.25,
                                      enlargeCenterPage: true,
                                      autoPlay: true,
                                      aspectRatio: 16 / 9,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enableInfiniteScroll: true,
                                      autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                      viewportFraction: 0.8,
                                    ),
                                  ),
                                  //          SizedBox(height: 10,),
                                ],
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height*0.2,
                              child: Container(
                                alignment: Alignment.center,
                                height: 10,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: imgList.length,
                                  itemBuilder: (context, index) {
                                    return Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: index == ind
                                          ? kBrightYellow
                                          : Colors.black45,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                           height: MediaQuery.of(context).size.height * 0.025
                          ),
                        item(context, "Categoryss", "", 0),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.06),
                          height: 40,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                cateList.length > 6 ? 6 : cateList.length,
                            itemBuilder: (context, index) {
                              return itemWidget(
                                  index,
                                  cateList[index].id!,
                                  cateList[index].name.toString(),
                                  cateList[index].color,
                                  cateList[index].bgColor);
                            },
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.035),
                        item(context, "Nearby", "", 0),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        nearDonateList.isEmpty?
                            Container(
                              alignment: Alignment.center,
                              //margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*),
                              child: Text(text , style: GoogleFonts.montserrat(),),
                            )
                        :Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.06),
                          height: MediaQuery.of(context).size.height * 0.120,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: nearDonateList.length,
                            itemBuilder: (context, index) {
                              return itemListWidget(nearDonateList[index]);
                            },
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.035),
                        item(context, "Donate", "See More", 1),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        donateList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: donateList.length > 10
                                    ? 10
                                    : donateList.length,
                                itemBuilder: (context, index) {
                                  return homeDonateItemWidget(
                                      context, donateList[index]);
                                },
                              )
                            : const SizedBox(),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.0350),
                        item(context, "Auctions", "See More", 2),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        auctionList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: auctionList.length > 10
                                    ? 10
                                    : auctionList.length,
                                itemBuilder: (context, index) {
                                  return homeAuctionCampaignWidget(
                                      context, auctionList[index]);
                                },
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
          ));
  }

  Widget itemWidget(
      int index, int id, String name, Color? color, Color? bgColor) {
    return InkWell(
      onTap: () {
        for (int i = 0; i < cateList.length; i++) {
          setState(() {
            cateList[i].bgColor = kWhite;
            cateList[i].color = kBlack;
          });
        }
        setState(() {
          cateList[index].color = kWhite;
          cateList[index].bgColor = kBrightYellow;
          catId = cateList[index].id!;
        });
        if (index == 0) {
          navigatePush(
              context,
              AllCharityCategory(
                cateList: cateList,
              ));
        } else {
          navigatePush(context, CharityScreen(id: id, txt: name));
        }
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

  Widget homeDonateItemWidget(BuildContext context, AllDonateModel model) {
    var percent;
    String perc = model.percentage.toString();
    if (model.percentage != null) {
      var a = double.parse(perc);
      percent = a / 100;
    } else {
      percent = 0.0;
    }
    return InkWell(
      onTap: () {
        navigatePush(context, CharityDetail(donateType: "1", model: model));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: MediaQuery.of(context).size.width * 0.060,
        ),
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
                      image: NetworkImage(model.image!),
                      fit: BoxFit.cover,
                    ), /*Image.asset(
                    'assets/icons/check.png',
                    fit: BoxFit.cover,
                  ),*/
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (model.favouriteStatus == '1') {
                      removeBookMark(model);
                    } else {
                      addToBookMark(model);
                    }
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: donateList[0].favouriteStatus == "1"
                          ? kBrightYellow
                          : Colors.white,
                      child: Icon(
                        Icons.bookmark,
                        color: donateList[0].favouriteStatus == "1"
                            ? kWhite
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
              model.title!,
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
                  Text(
                    "Raised",
                    style: GoogleFonts.montserrat(),
                  ),
                  Text(
                    "${model.percentage}%",
                    style: GoogleFonts.montserrat(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            /*Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("assets/icons/check.png"),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "John William",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "San Diego, CA",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(color: kGrey, fontSize: 12)),
                  ),
                ],
              )
            ],
          )*/
          ],
        ),
      ),
    );
  }

  Widget itemListWidget(AllDonateModel model) {
    return InkWell(
      onTap: () {
        navigatePush(context, CharityDetail(donateType: "1", model: model));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.04),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:  Opacity(
                alwaysIncludeSemantics: true,
                opacity: 0.4,
                child: FadeInImage(
                  placeholder: const AssetImage("assets/images/placeholder.png"),
                  image: NetworkImage(
                      model.image!),
                  fit: BoxFit.cover,
                ),
                /*Image.asset(
                  "assets/icons/check.png",
                  fit: BoxFit.cover,
                ),*/
              ),
            ),
          ),
          Text(model.title!,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: kWhite),
              )),
        ],
      ),
    );
  }
}
