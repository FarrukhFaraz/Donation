import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Donor/Authorization/sign_up_screen.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:give_alil_bit_new/Widgets/input_text_form_field.dart';
import 'package:give_alil_bit_new/donor_home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/button.dart';
import '../../Widgets/password_input_field.dart';
import 'forgot_password.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String value = "Email";

  bool requirePhoneMail = false;
  bool requirePass = false;
  bool click = true;
  bool obsecure = true;
  bool checkBoxValue = false;
  bool loader = false;
  bool checkConnection = false;

  formValidate() {
    setState(() {
      requirePhoneMail = false;
      requirePass = false;
    });
    if (controller.text.trim().isEmpty) {
      setState(() {
        requirePhoneMail = true;
      });
    } else if (passwordController.text.toString().isEmpty) {
      setState(() {
        requirePass = true;
      });
    } else {
      checkPhone();
    }
  }

  checkPhone() {
    if (value == 'Email') {
      checkConnectivity();
    } else {
      try {
        double a = double.parse(controller.text.trim());
        print(a);
        checkConnectivity();
      } catch (e) {
        print(e);
        showSnackMessage(context, "Invalid Phone Number");
      }
    }
  }

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      loginApi();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  loginApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loader = true;
    });
/////////////////////// implement api

    Map body = {
      "user": controller.text.trim(),
      "password": passwordController.text
    };
    try {
      http.Response response =
          await http.post(Uri.parse(signInPhoneURL), body: body);

      Map jsonDate = jsonDecode(response.body);
      print(jsonDate);

      if (jsonDate['statusCode'] == 200) {
        showSnackMessage(context, "Login Successfully ");
        setState(() {
          loader = false;
        });
          var id = jsonDate['data']['user']['id'];
          var token = jsonDate['data']['token'];
          prefs.setString('id', id.toString());
          prefs.setString('token', token);
        prefs.setString('user', "donor");
          print("$id\n  token$token\nuserType: donor");
        navigateReplace(context,  DonorHomePage(index: 0));
      } else {
        showSnackMessage(context, "Invalid Credentials!");
        setState(() {
          loader = false;
        });
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
        ? OfflineUI(function: checkConnectivity)
        : SafeArea(
            child: Scaffold(
            backgroundColor: bgColor,
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.06,
                  vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Text(
                    "Log In",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 24,
                          color: kColor,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: kWhite,
                    ),
                    //padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.04,
                              left: MediaQuery.of(context).size.width * 0.04,
                              right: MediaQuery.of(context).size.width * 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    value = "Email";
                                    click = true;
                                  });
                                },
                                child: Text(
                                  " By Email",
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: click ? kBrightYellow : kBlack,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Text(
                                "  |  ",
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    value = "Phone Number";
                                    click = false;
                                  });
                                },
                                child: Text(
                                  "By Phone Number",
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: click ? kBlack : kBrightYellow,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.04),
                          child: Text(" $value",
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              )),
                        ),
                        //SizedBox(height: 8),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Container(
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.04,
                                right:
                                    MediaQuery.of(context).size.width * 0.04),
                            child: textInputFormField(
                                context, click, controller, "Enter $value")),
                        requirePhoneMail
                            ? Container(
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.04),
                                child: Text(
                                  "  $value is required",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              )
                            : const Text(""),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.04),
                          child: Text(
                            "Password",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        //SizedBox(height: 8),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.04,
                              right: MediaQuery.of(context).size.width * 0.04),
                          child: PasswordInputField(
                            obscure: obsecure,
                            controller: passwordController,
                            value: "Enter password",
                          ),
                        ),
                        requirePass
                            ? Container(
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.04),
                                child: const Text(
                                  "  Password is required",
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : const Text(""),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Container(
                          margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                side:
                                    BorderSide(color: kBrightYellow, width: 2),
                                focusColor: kBrightYellow,
                                value: checkBoxValue,
                                activeColor: kBrightYellow,
                                onChanged: (bol) {
                                  setState(() {
                                    checkBoxValue = bol!;
                                  });
                                },
                              ),
                              Text(
                                "Remember me",
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    navigatePush(
                                        context, const ForgotPassword());
                                  },
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Forgot Password?",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: kBrightYellow,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        InkWell(
                          onTap: () {
                            formValidate();
                          },
                          child: button(context, "Log In", loader),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account?   ",
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            navigatePush(context, const SignUpScreen());
                          },
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: kBrightYellow,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ));
  }
}
