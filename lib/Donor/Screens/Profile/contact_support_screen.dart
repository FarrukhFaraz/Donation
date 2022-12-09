import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/offline_ui.dart';
import '../../Model/contact_support_model.dart';

class ContactSupport extends StatefulWidget {
  const ContactSupport({Key? key}) : super(key: key);

  @override
  State<ContactSupport> createState() => _ContactSupportState();
}

class _ContactSupportState extends State<ContactSupport> {
  bool checkConnection = false;
  bool loader = false;
  List<ContactSupportModel> list = <ContactSupportModel>[];

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
      http.Response response = await http.get(Uri.parse(contactSupportURL),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);

      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          ContactSupportModel pos = ContactSupportModel();
          pos = ContactSupportModel.fromJson(obj);
          list.add(pos);
        }
        setState(() {
          loader = false;
        });
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, "Something went wrong\nTry again later");
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      showSnackMessage(context, "Something went wrong\nTry again later");
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
            backgroundColor: kWhite,
            body: loader
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              "assets/images/contact_support.png",
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.35,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              left: MediaQuery.of(context).size.width * 0.015,
                              top: MediaQuery.of(context).size.height * 0.01,
                              child: InkWell(
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
                            )
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.06),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Phone Number",
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      color: kColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              list.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        if (list[0]
                                            .number
                                            .toString()
                                            .isNotEmpty) {
                                          print(list[0].number.toString());
                                          // print(contact.phones.first.number);
                                          /*launchUrl(Uri.parse('tel: ${contact.phones}'));*/
                                          //  launchUrlString('tel: ${list[0].number.toString()}');
                                          launchUrl(Uri.parse(
                                              'tel: ${list[0].number.toString()}'));
                                        } else {
                                          print('empty number');
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              list[0].number.toString(),
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(
                                            Icons.call,
                                            color: Colors.blue,
                                          )
                                        ],
                                      ),
                                    )
                                  : const Text(""),
                              const Divider(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              Text(
                                "Email",
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      color: kColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              list.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        if (list[0].email.toString().isNotEmpty) {
                                          print(list[0].email.toString());
                                          String email = Uri.encodeComponent("${list[0].email}");
                                          String subject = Uri.encodeComponent("Donation App");
                                          print(subject); //output: Hello%20Flutter
                                          Uri mail = Uri.parse("mailto:$email?subject=$subject");
                                          launchUrl(mail);
                                        } else {
                                          print('empty number');
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              list[0].email.toString(),
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.mail_outline,
                                            color: Colors.blue,
                                          )
                                        ],
                                      ),
                                    )
                                  : const Text(""),
                              const Divider(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              Text(
                                "Message",
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      color: kColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              list.isNotEmpty
                                  ? Text(
                                      list[0].message.toString(),
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const Text(""),
                              const Divider(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ));
  }
}
