import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/bottom_nav.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/CheckConnection.dart';
import '../../Model/notification_model.dart';

class FilledNotification extends StatefulWidget {
  FilledNotification({Key? key, required this.list}) : super(key: key);

  List<NotificationModel> list;

  @override
  State<FilledNotification> createState() => _FilledNotificationState();
}

class _FilledNotificationState extends State<FilledNotification> {
  bool isSwitched = false;
  bool clicked = true;
  bool checkConnection = false;
  bool loader = false;

  List<NotificationModel> uncheckList = <NotificationModel>[];

  getUncheckList() {
    for (int i = 0; i < widget.list.length; i++) {
      if (widget.list[i].status == "1") {
        uncheckList.add(widget.list[i]);
      }
    }
  }

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      loadNotification();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  loadNotification() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      http.Response response = await http.get(Uri.parse(getAllNotificationURL),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);

      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        widget.list.clear();

        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          NotificationModel pos = NotificationModel();
          pos = NotificationModel.fromJson(obj);
          widget.list.add(pos);
        }

        setState(() {
          loader = false;
        });
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

  @override
  void initState() {
    // TODO: implement initState
    getUncheckList();
    super.initState();
  }

  changeStatus(NotificationModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    http.Response response = await http.post(
        Uri.parse(notificationStatusURL + model.id.toString()),
        headers: {"Authorization": "Bearer $token"},
        body: {"status": "0"});
    Map jsonData = jsonDecode(response.body);

    if (jsonData['statusCode'] == 200) {
      setState(() {
        uncheckList.remove(model);
        checkConnectivity();
      });
    } else {
      showSnackMessage(context, "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkConnection
        ? OfflineUI(function: checkConnectivity)
        : SafeArea(
            child: Scaffold(
            backgroundColor: bgColor,
            bottomNavigationBar: bottomNav(context, 0),
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
                                "Notifications",
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                            Switch(
                                activeColor: kColor,
                                value: isSwitched,
                                onChanged: (bol) {
                                  setState(() {
                                    isSwitched = bol;
                                  });
                                })
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  clicked = true;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: clicked ? kColor : kWhite,
                                ),
                                child: Text(
                                  "All",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: clicked ? kWhite : kBlack)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  clicked = false;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: clicked ? kWhite : kColor,
                                ),
                                child: Text(
                                  "Unread",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: clicked ? kBlack : kWhite)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        clicked
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: ListView.builder(
                                  itemCount: widget.list.length,
                                  itemBuilder: (context, index) {
                                    return notificationItemWidget(
                                        widget.list[index]);
                                  },
                                ),
                              )
                            : SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: ListView.builder(
                                  itemCount: uncheckList.length,
                                  itemBuilder: (context, index) {
                                    return notificationItemWidget(
                                        uncheckList[index]);
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
          ));
  }

  Widget notificationItemWidget(NotificationModel model) {
    return InkWell(
      onTap: () {
        changeStatus(model);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.only(top: 15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.10,
        decoration: BoxDecoration(
            color: kWhite, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width * 0.17,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kLight,
              ),
              child: Icon(
                Icons.notifications_active_outlined,
                size: 30,
                color: kColor,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Text(
              model.title!,
              style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w600, height: 1.2)),
            )),
            const SizedBox(width: 6),
            model.status == '1'
                ? Icon(
                    Icons.circle,
                    color: kBrightYellow,
                    size: 10,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
