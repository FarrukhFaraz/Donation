import 'dart:convert';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../Widgets/button.dart';
import '../../Widgets/input_text_form_field.dart';
import 'otp_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController controller = TextEditingController();

  late EmailAuth mailAuth;

  String value = "Email";
  String code = "+92";
  String user = "";

  bool click = true;
  bool loader = false;
  bool error = false;
  bool checkConnection = false;

  formValidate() {
    setState(() {
      error = false;
    });
    if (controller.text.trim().isEmpty) {
      setState(() {
        error = true;
      });
    } else {
      if (value == 'Email') {
        checkConnectivity();
      } else {
        try {
          double a = double.parse(controller.text);
          print(a);
          checkConnectivity();
        } catch (e) {
          print(e);
          showSnackMessage(context, "Invalid Phone Number");
        }
      }
    }
  }

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      submitDate();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  submitDate() async {
    setState(() {
      loader = true;
    });
    Map body = {"user": controller.text};
    print(body);
    try {
      http.Response response =
          await http.post(Uri.parse(userExitURL), body: body);

      Map jsonData = jsonDecode(response.body);

      if (jsonData['statusCode'] == 200) {
        if (value == 'Email') {
          mailAuth = EmailAuth(sessionName: "Education");
          verifyMailOtp();
          /////////////
        } else {
          verifyPhone();
        }
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, "No user exist with this $value");
      }
    } catch (e) {
      print("Network Exception");
      showSnackMessage(context, "Network Failed");
      setState(() {
        loader = false;
      });
    }
  }

  verifyMailOtp() async {
    setState(() {
      loader = true;
    });
    var res = await mailAuth.sendOtp(recipientMail: controller.text.trim());
    if (res) {
      showSnackMessage(context, "OTP has been sent");
      navigatePush(
          context,
          OTPScreen(
            id: "0",
            value: value,
            user: controller.text.trim(),
            userInput: controller.text,
          ));
    } else {
      showSnackMessage(context, "Something went wrong\nTry again later");
    }
    setState(() {
      loader = false;
    });
  }

  verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: code + controller.text,
      verificationCompleted: (PhoneAuthCredential credential) {
        print("userCredential:  $credential");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("ErrorOccurred: ${e.message}");
        print("PHONENO: ${code + controller.text}");

        showSnackMessage(context, e.message.toString());
        setState(() {
          loader = false;
        });
      },
      timeout: const Duration(seconds: 60),
      codeSent: (String verificationId, int? resendToken) {
        print("TokenPassed: $resendToken \nIdPassed: $verificationId");
        print("PHONENO: ${code + controller.text}");

        /////////// it will run when opt is successfully sent
        showSnackMessage(context, "OTP has been sent to this Number");
        setState(() {
          loader = false;
        });
        navigatePush(
            context,
            OTPScreen(
              id: verificationId,
              value: value,
              userInput: controller.text,
              user: code + controller.text,
            ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("RetrievalIdPassed: $verificationId");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return checkConnection
        ? OfflineUI(function: checkConnectivity)
        : SafeArea(
            child: Scaffold(
            backgroundColor: bgColor,
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 15, top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.06,
                      ),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.077),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.06),
                    child: Text(
                      "Forgot Password",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: kColor),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kWhite,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                      vertical: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                              child: Text("By Email",
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: click ? kBrightYellow : kBlack,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            Text("  |  ",
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                )),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  value = "Phone Number";
                                  click = false;
                                });
                              },
                              child: Text("By Phone Number",
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: click ? kBlack : kBrightYellow,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06),
                        Text(value,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: kBlack,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        value == 'Email'
                            ? textInputFormField(
                                context, click, controller, "Enter Email")
                            : Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: loginField),
                                child: Row(
                                  children: [
                                    SizedBox(height: 50, child: pickCountry()),
                                    Container(
                                      width: 2,
                                      height: 50,
                                      color: Colors.black,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: controller,
                                        keyboardType: TextInputType.phone,
                                        autofocus: false,
                                        showCursor: !error,
                                        onTap: () {
                                          setState(() {
                                            error = false;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: "Enter Phone Number",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        error
                            ? Text(
                                "  $value is required",
                                style: const TextStyle(color: Colors.red),
                              )
                            : const Text(""),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        InkWell(
                          onTap: () {
                            formValidate();
                          },
                          child: button(context, "Send OTP", loader),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
  }

  Widget pickCountry() {
    return CountryListPick(
      useSafeArea: true,
      pickerBuilder: (context, CountryCode? countryCode) {
        return Text(code);
      },
      // if you need custom picker use this
      theme: CountryTheme(
        isShowFlag: true,
        isShowTitle: true,
        isShowCode: true,
        isDownIcon: true,
        showEnglishName: true,
        labelColor: Colors.blueAccent,
      ),
      initialSelection: '+62',
      useUiOverlay: false,
      onChanged: (c) {
        setState(() {
          code = (c?.dialCode).toString();
        });
      },
    );
  }
}
