import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:typewritertext/typewritertext.dart';

import '../../Donor/Model/intro_all_about_model.dart';
import '../Utils/CheckConnection.dart';
import '../Utils/messages.dart';
import '../Utils/url.dart';
import '../Widgets/button.dart';
import 'intro2.dart';

class Intro1 extends StatefulWidget {
  const Intro1({Key? key}) : super(key: key);

  @override
  State<Intro1> createState() => _Intro1State();
}

class _Intro1State extends State<Intro1> {
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
            backgroundColor: kWhite,
            body: Container(
              alignment: Alignment.center,
              child: loader
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: MediaQuery.of(context).size.width * 0.06),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          list.isNotEmpty
                              ? TypeWriterText(
                                  alignment: Alignment.center,
                                  duration: const Duration(milliseconds: 100),
                                  text: Text(
                                      list[0].welcome.toString(),
                                      // "GiveAlilbit is a crowdfunding and charity donation app that accepts crypto, NFT , "
                                      // "and credit donations. Join our global community of philanthropists to provide "
                                      // "transparent, blockchain solutions to charitable giving.  If you are new to using "
                                      // "crypto , you can lower capital gains taxes by donating crypto instead of cash so "
                                      // "more money is raised for your cause. If we all do a lil bit , we can help each other "
                                      // "thrive and  prosper ! Sign up to be a global ambassador to help your local"
                                      // " charitable organizations with awareness by sharing the GLB app.",
                                      maxLines: 20,
                                      softWrap: true,
                                      //strutStyle: StrutStyle(fontSize: 16,height: 1.5),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      //style: GoogleFonts.latoTextTheme().bodyLarge,
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                            fontSize: 16, height: 1.5),
                                      )
                                      //GoogleFonts.latoTextTheme("T"),
                                      // style: GoogleFonts.montserrat(
                                      //   textStyle: const TextStyle(fontSize: 16, height: 1.5),
                                      // ),
                                      ),
                                )
                              : const Text(""),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                          InkWell(
                            onTap: () {
                              navigatePush(
                                  context,
                                  Intro2(
                                    list: list,
                                  ));
                            },
                            child: button(context, "Next", false),
                          ),
                        ],
                      ),
                    ),
            ),
          ));
  }
}
