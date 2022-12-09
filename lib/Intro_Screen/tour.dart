import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Charity/non_profit_signup.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/button.dart';
import '../Donor/Authorization/login_screen.dart';

class TourScreen extends StatefulWidget {
  const TourScreen({super.key});

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.035,
              horizontal: MediaQuery.of(context).size.width * 0.0450,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    navigatePush(context, const LoginScreen());
                  },
                  child: button(context, "Sign In / Sign Up", false),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                InkWell(
                  onTap: () {
                    navigatePush(context, const NonProfitSignupScreen());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    // height: 50,
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                    //MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.2,
                          color: kColor,
                        ),
                        borderRadius: BorderRadius.circular(
                          12,
                        )),
                    child: Text("Non-Profit Sign Up",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: kColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                /*InkWell(
                  onTap: () {
                    navigatePush(context, const FormScreen());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    // height: 50,
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                    //MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      border: Border.all(
                        width: 1.2,
                        color: kColor,
                      ),
                    ),
                    child: Text("Start The Tour",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: kColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
