import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/url.dart';
import '../../Model/intro_all_about_model.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool checkConnection = false;
  bool loader = false;
  List<IntroAllAboutModel> list = <IntroAllAboutModel>[];

  loadData() async {
    setState(() {
      loader = true;
    });

    try {
      http.Response response = await http.get(Uri.parse(introAllAboutURL));

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          IntroAllAboutModel pos = IntroAllAboutModel();
          pos = IntroAllAboutModel.fromJson(obj);
          list.add(pos);
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
      showSnackMessage(context, "Something went wrong!");
    }
  }

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
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: (){
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
                              child: Text("About",
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                            )),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: FadeInImage(
                              width: MediaQuery.of(context).size.width,
                              placeholder: AssetImage("assets/images/placeholder.png"),
                              image: NetworkImage(list[0].image!),
                              fit: BoxFit.cover,
                            ),
                            /*Image.asset(
                              "assets/icons/check.png",
                              fit: BoxFit.cover,
                            ),*/
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text("About",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(height: 4),
                        Text( list[0].about!,
                          // "It is our mission to help the most vulnerable in our community receive "
                          // "compassionate care when struggling during tough times. We offer support and "
                          // "guidance to families and individuals experiencing hardships.",
                          textAlign: TextAlign.justify,
                          maxLines: 10,
                          style: GoogleFonts.montserrat(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        Text("Mission",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(height: 4),
                        Text(
                           list[0].mission!,
                          style: GoogleFonts.montserrat(),
                          // "It is our mission to help the most vulnerable in our community receive compassionate "
                          // "care when struggling during tough times.",
                          textAlign: TextAlign.justify,
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        Text("Vision",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(height: 4),
                        Text(   list[0].vision!,
                          style: GoogleFonts.montserrat(),
                          // "It is our mission to help the most vulnerable in our community receive "
                          // "compassionate care when struggling during tough times. We offer support and "
                          // "guidance to families and individuals.",
                          textAlign: TextAlign.justify,
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
          ));
  }
}
