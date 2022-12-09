import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:give_alil_bit_new/Widgets/form_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/colors.dart';
import '../Widgets/button.dart';
import 'New folder/charity_category.dart';

class NonProfitSignupScreen extends StatefulWidget {
  const NonProfitSignupScreen({super.key});

  @override
  State<NonProfitSignupScreen> createState() => _NonProfitSignupScreenState();
}

class _NonProfitSignupScreenState extends State<NonProfitSignupScreen> {
  //////////////////////

  TextEditingController nameController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController missionController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  bool requireCharity = false;
  bool requireTax = false;
  bool requireMission = false;
  bool requireContact = false;

  bool checkConnection = false;
  bool loader = false;

  formValidate() {
    setState(() {
      requireCharity = false;
      requireTax = false;
      requireMission = false;
      requireContact = false;
    });
    if (nameController.text.trim().isEmpty) {
      setState(() {
        requireCharity = true;
      });
    } else if (taxController.text.trim().isEmpty) {
      setState(() {
        requireTax = true;
      });
    } else if (missionController.text.trim().isEmpty) {
      setState(() {
        requireMission = true;
      });
    } else if (contactController.text.trim().isEmpty) {
      setState(() {
        requireContact = true;
      });
    } else {
      connectivityCheck();
    }
  }

  connectivityCheck() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      submitData();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  submitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loader = true;
    });
    Map body = {
      "CharityName": nameController.text.trim(),
      "TaxEIN": taxController.text.trim(),
      "Mission": missionController.text.trim(),
      "Contact": contactController.text.trim()
    };
    try {
      http.Response response =
          await http.post(Uri.parse(charitySignInURL), body: body);

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        setState(() {
          loader = false;
        });
        var id = jsonData['data']['user']['id'];
        var token = jsonData['data']['token'];

        prefs.setString("id", id.toString());
        prefs.setString('token', token);
        prefs.setString('user', "charity");
        print("id:$id\ntoken:$token\nuserType: charity");
        showSnackMessage(context, "Registered Successfully");
        navigatePush(context, const CharityCategoryScreen());
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, jsonData['data']);
      }
    } catch (e) {
      print("Network Exception");
      showSnackMessage(context, "Network Failed");
      setState(() {
        loader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkConnection
        ? OfflineUI(function: connectivityCheck)
        : SafeArea(
            child: Scaffold(
              backgroundColor: bgColor,
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: MediaQuery.of(context).size.width * 0.06,
                ),
                child: Column(
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
                              height: MediaQuery.of(context).size.height * 0.02,
                              width: MediaQuery.of(context).size.width * 0.035,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Non-Profit Sign Up",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: kWhite,
                      ),
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.04),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Charity Name",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          formFields(
                            nameController,
                            "Type",
                          ),
                          requireCharity
                              ? const Text(
                                  "  Charity name is required",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                )
                              : const Text(""),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Text(
                            "Tax EIN",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          formFields(
                            taxController,
                            "Type",
                          ),
                          requireTax
                              ? const Text(
                                  "  Tax EIN is required",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                )
                              : const Text(""),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Text(
                            "Mission",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          formFields(
                            missionController,
                            "Type",
                          ),
                          requireMission
                              ? const Text(
                                  "  Mission is required",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                )
                              : const Text(""),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Text(
                            "Contact Email/Number",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          formFields(
                            contactController,
                            "Type",
                          ),
                          requireContact
                              ? const Text(
                                  "  Contact is required",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                )
                              : const Text(""),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          InkWell(
                            onTap: () {
                              formValidate();
                            },
                            child: button(context, "Submit", loader),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
