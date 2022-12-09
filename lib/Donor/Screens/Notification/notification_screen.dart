import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Donor/Screens/Notification/filled_notification.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/notification_model.dart';
import 'empty_notification_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> list = <NotificationModel>[];

  bool loader = false;
  bool checkConnection = false;

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

        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          NotificationModel pos = NotificationModel();
          pos = NotificationModel.fromJson(obj);
          list.add(pos);
        }

        setState(() {
          loader=false;
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
    checkConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return checkConnection
        ? OfflineUI(function: checkConnectivity)
        : loader
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SafeArea(
                child: list.isEmpty
                    ? const EmptyNotification()
                    :  FilledNotification(list: list),
              );
  }
}
