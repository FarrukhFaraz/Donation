import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Donor/Authorization/login_screen.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:give_alil_bit_new/Widgets/password_input_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../Utils/colors.dart';
import '../../Widgets/button.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({
    Key? key,
    required this.userInput,
  }) : super(key: key);

  final String userInput;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  bool obscure = true;
  bool loader = false;

  bool checkConnection = false;
  bool passError = false;
  bool rePassError = false;
  bool notMatchPass = false;

  formValidate() {
    setState(() {
      passError = false;
      rePassError = false;
      notMatchPass = false;
    });
    if (passwordController.text.trim().isEmpty) {
      setState(() {
        passError = true;
      });
    } else if (rePasswordController.text.trim().isEmpty) {
      setState(() {
        rePassError = true;
      });
    } else {
      if (passwordController.text.trim() == rePasswordController.text.trim()) {
        checkConnectivity();
      } else {
        setState(() {
          notMatchPass = true;
        });
      }
    }
  }

  checkConnectivity() async {
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
    setState(() {
      loader = true;
    });

    Map body = {
      "user": widget.userInput,
      "password": passwordController.text.trim()
    };

    try {
      http.Response response =
          await http.post(Uri.parse(resetPasswordURL), body: body);
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        showSnackMessage(context, "Password successfully updated");
        navigateReplace(context, const LoginScreen());
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 15, top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.077),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.060),
              child: Text("Choose a Password",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: kColor),
                  )),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: kWhite,
              ),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Password",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      )),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  PasswordInputField(
                    obscure: obscure,
                    controller: passwordController,
                    value: "Enter password",
                  ),
                  Text(
                    passError ? "Required" : "",
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text("Confirm Password",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      )),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  PasswordInputField(
                    obscure: obscure,
                    controller: rePasswordController,
                    value: "Confirm password",
                  ),
                  Text(
                    rePassError
                        ? "Required"
                        : notMatchPass
                            ? "Password not match"
                            : "",
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  InkWell(
                    onTap: () {
                      formValidate();
                    },
                    child: button(context, "Reset", loader),
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
