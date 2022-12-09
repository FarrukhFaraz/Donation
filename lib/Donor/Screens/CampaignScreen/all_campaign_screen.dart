import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Donor/Screens/Notification/notification_screen.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:give_alil_bit_new/Widgets/home/home_auction_item_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/url.dart';
import '../../Model/all_campaign_model.dart';


class AllCampaignScreen extends StatefulWidget {
  const AllCampaignScreen({Key? key}) : super(key: key);

  @override
  State<AllCampaignScreen> createState() => _AllCampaignScreenState();
}

class _AllCampaignScreenState extends State<AllCampaignScreen> {
  List<AllCampaignModel> campaignList = <AllCampaignModel>[];

  bool loader = false;
  bool checkConnection = false;

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      loadCampaignList();
    } else {
      setState(() {
        checkConnection = true;
      });
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
          campaignList.add(pos);

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
        checkConnection = false;
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
                                  child: Text("All Campaign",
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  navigatePush(context, const NotificationScreen());
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
                                    height:
                                        MediaQuery.of(context).size.height * 0.02,
                                    width:
                                        MediaQuery.of(context).size.width * 0.035,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.02,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: campaignList.length,
                          itemBuilder: (context , index){
                            return homeAuctionCampaignWidget(context, campaignList[index]);
                          },
                        )
                      ],
                    ),
                  ),
          ));
  }
}
