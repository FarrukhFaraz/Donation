import 'dart:convert';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/colors.dart';
import '../../Utils/navigator.dart';
import '../../Utils/url.dart';
import '../../Widgets/button.dart';
import '../../Widgets/input_text_form_field.dart';
import '../../Widgets/password_input_field.dart';
import '../Screens/SignUpMethod/interest.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String value = "Email";
  String countryName = "Indonesia";


  bool requireName = false;
  bool requirePhoneMail = false;
  bool requirePassword = false;

  bool click = true;
  bool obscure = true;
  bool checkBoxValue = false;
  bool loader = false;
  bool checkConnection = false;

  formValidate() {
    setState(() {
      requireName = false;
      requirePassword = false;
      requirePhoneMail = false;
    });
    if(nameController.text.trim().toString().isEmpty){
      setState((){
        requireName=true;
      });
    }

    else if (controller.text.trim().toString().isEmpty) {
      setState(() {
        requirePhoneMail = true;
      });
    } else if (passwordController.text.toString().isEmpty) {
      setState(() {
        requirePassword = true;
      });
    } else {
      checkPhone();
    }
  }

  checkPhone() {
    if (value == "Phone Number") {
      try {
        double a = double.parse(controller.text.trim());
        print(a);
        checkConnectivity();
      } catch (e) {
        showSnackMessage(context, "Invalid Phone Number");
      }
    } else {
      print("email");
      checkConnectivity();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loader = true;
    });
    Map? body;
    if (value == 'Email') {
      body = {
        "name": nameController.text,
        "email": controller.text,
        "country": countryName,
        "password": passwordController.text
      };
    } else {
      body = {
        "phone": controller.text,
        "country": countryName,
        "password": passwordController.text
      };
    }
    try {
      http.Response response =
          await http.post(Uri.parse(signUpDonorURL), body: body);

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, jsonData['message']);
        var id = jsonData['data']['user']['id'];
        var token = jsonData['data']['token'];

        prefs.setString('id', id.toString());
        prefs.setString('token', token.toString());
        prefs.setString('user', "donor");
        print("id: $id\ntoken:$token\nuserType: donor");
        navigatePush(context, const SelectInterest());
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, "This $value already has been taken");
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.077),
                  Text("Sign Up",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: kColor,
                        ),
                      )),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kWhite,
                    ),
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                      fontWeight: FontWeight.bold),
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
                            height: MediaQuery.of(context).size.height * 0.03),
                        Text("Name",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: kBlack,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.020),
                        textInputFormField(
                          context,
                          click,
                          nameController,
                          "Enter name",
                        ),
                        Text(
                          requireName ? "  Name is required" : "",
                          style: TextStyle(
                            color: requirePhoneMail ? Colors.red : Colors.white,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text(value,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: kBlack,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.020),
                        textInputFormField(
                          context,
                          click,
                          controller,
                          "Enter $value",
                        ),
                        Text(
                          requirePhoneMail ? "  $value is required" : "",
                          style: TextStyle(
                            color: requirePhoneMail ? Colors.red : Colors.white,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text("Select Country",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: kBlack,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Container(
                          alignment: Alignment.center,
                          // height: 50,
                          //MediaQuery.of(context).size.height*0.060,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: loginField,
                          ),
                          child: CountryListPick(
                            useSafeArea: true,
                            // if you need custom picker use this
                            pickerBuilder: (context, CountryCode? countryCode) {
                              return Row(
                                children: [
                                  Image.asset(
                                    (countryCode!.flagUri)!,
                                    height: 30,
                                    //MediaQuery.of(context).size.height * 0.06,
                                    width: 50,
                                    //MediaQuery.of(context).size.width * 0.1,
                                    package: 'country_list_pick',
                                  ),
                                  //Text(countryCode.code!),
                                  Expanded(
                                      child: Text("  ${countryCode.name!}",
                                          style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: kGrey,
                                                fontWeight: FontWeight.w600),
                                          ))),
                                  Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: kGrey,
                                  ),
                                ],
                              );
                            },
                            theme: CountryTheme(
                              isShowFlag: true,
                              isShowTitle: true,
                              isShowCode: true,
                              isDownIcon: true,
                              showEnglishName: false,
                              labelColor: Colors.blueAccent,
                            ),
                            initialSelection: '+62',
                            useUiOverlay: false,
                            onChanged: (C) {
                              setState(() {
                                countryName = C!.name!;
                              });
                              print(countryName);
                              // print(code.name);
                              // print(code.code);
                              // print(code.dialCode);
                              // print(code.flagUri);
                            },
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text("Password",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: kBlack,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        PasswordInputField(
                          obscure: obscure,
                          controller: passwordController,
                          value: "Enter password",
                        ),
                        Text(
                          requirePassword ? "  Password is required" : "",
                          style: TextStyle(
                            color: requirePassword ? Colors.red : Colors.white,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        InkWell(
                          onTap: () {
                            formValidate();
                          },
                          child: button(context, "Sign Up", loader),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?   ",
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          )),
                      InkWell(
                          onTap: () {
                            navigatePush(context, const LoginScreen());
                          },
                          child: Text("Log In",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: kBrightYellow,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ))),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ));
  }
}
