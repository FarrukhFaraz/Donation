import 'dart:async';

import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../Utils/colors.dart';
import '../../Utils/navigator.dart';
import '../../Widgets/button.dart';
import 'new_password_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    Key? key,
    required this.id,
    required this.value,
    required this.user,
    required this.userInput,
  }) : super(key: key);

  final String id;
  final String value;
  final String userInput;
  final String user;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();

  FirebaseAuth phoneAuth = FirebaseAuth.instance;
  late EmailAuth mailAuth;

  bool checkConnection = false;
  bool loader = false;
  bool error = false;
  bool cancelTimer = false;
  int time = 60;
  String timeToDisplay = "60";

  timer() async {
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (cancelTimer) {
          t.cancel();
        }
        if (time < 1) {
          t.cancel();
        } else {
          time = time - 1;
          timeToDisplay = time.toString();
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    timer();
    super.initState();
    mailAuth = EmailAuth(sessionName: "Education");
  }


  resendMailOtp() async {
    setState(() {
      cancelTimer = false;
      loader = true;
      time = 60;
    });
    var res = await mailAuth.sendOtp(recipientMail: widget.user.trim());
    if (res) {
      timer();
      showSnackMessage(context, "OTP has been sent");
    } else {
      showSnackMessage(context, "Something went wrong\nTry again later");
    }
    setState(() {
      loader = false;
    });
  }

  resendPhoneOtp() async {
    setState(() {
      cancelTimer = false;
      loader = true;
      time = 60;
    });
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.user,
        verificationCompleted: (PhoneAuthCredential credential) {
          print("userCredential:  $credential");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("ErrorOccurred: ${e.message}");
          print("PHONENO: ${widget.user}");

          showSnackMessage(context, e.message.toString());
          setState(() {
            loader = false;
          });
        },
        timeout: const Duration(seconds: 60),
        codeSent: (String verificationId, int? resendToken) {
          print("TokenPassed: $resendToken \nIdPassed: $verificationId");
          print("PHONENO: ${widget.user}");

          /////////// it will run when opt is successfully sent
          timer();
          showSnackMessage(context, "OTP has been sent to this Number");
          setState(() {
            loader = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("RetrievalIdPassed: $verificationId");
        },
      );
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      showSnackMessage(context, "Network failed");
    }
  }

  formValidate() {
    if (otpController.text.trim().isNotEmpty) {
      if (time > 0) {
        setState(() {
          loader = true;
        });
        checkConnectivity();
      } else {
        showSnackMessage(context, "Time Out\nTry to resend OTP");
        print("TIMEOUT");
      }
    } else {
      print("empty");
      setState(() {
        error = true;
      });
      print(error);
    }
  }

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      if (widget.value == 'Email') {
        verifyEmailOtp();
      } else {
        //////////// Phone
        print("PHONE OTP");
        verifyPhoneOtp();
      }
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  verifyEmailOtp() async {
    var res = mailAuth.validateOtp(
        recipientMail: widget.user, userOtp: otpController.text.trim());
    if (res) {
      showSnackMessage(context, "OTP verified");
      navigateReplace(
          context,
          NewPasswordScreen(
            userInput: widget.userInput,
          ));
    } else {
      setState(() {
        loader=false;
      });
      showSnackMessage(context, "Invalid OTP");
    }
  }

  verifyPhoneOtp() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.id, smsCode: otpController.text);
      print("MethodForSignINUSED:  ${credential.signInMethod}");
      print("CREDENTIALEDUSED:  $credential");
      print("OTP: ${credential.smsCode}");
      setState(() {
        loader=false;
      });
      // Sign the user in (or link) with the credential
      await phoneAuth.signInWithCredential(credential);
      showSnackMessage(context, "OTP Verified");
      navigateReplace(
          context,
          NewPasswordScreen(
            userInput: widget.userInput,
          ));
      setState(() {
        cancelTimer = true;
        loader = false;
      });
      /////////////
    } catch (e) {
      print("ErrorFORINVALIDOTP: $e");
      showSnackMessage(context, "Invalid OTP");
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
              padding: const EdgeInsets.only(bottom: 15, top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    child: Text("Security Verification",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: kColor,
                          ),
                        )),
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
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Verification Code",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            )),
                        //SizedBox(height: 8),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Pinput(
                          controller: otpController,
                          keyboardType: TextInputType.phone,
                          length: 6,
                          showCursor: !error,
                          onTap: () {
                            setState(() {
                              error = false;
                            });
                          },
                        ),
                        Text(
                          error ? "  Required" : "",
                          style: TextStyle(
                              fontSize: 12,
                              color: error ? Colors.red : Colors.white),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            timeToDisplay,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.020),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don’t received code yet!  ",
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                )),
                            InkWell(
                              onTap: () {
                                if (loader == false) {
                                  if (timeToDisplay == "0") {
                                    if (widget.value == 'Email') {
                                      resendMailOtp();
                                    } else {
                                      resendPhoneOtp();
                                    }
                                  }
                                }
                              },
                              child: Text("Resend",
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: kBrightYellow,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        InkWell(
                          onTap: () {
                            if (loader == false) {
                              formValidate();
                            }
                          },
                          child: button(context, "Confirm", loader),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
  }
}
