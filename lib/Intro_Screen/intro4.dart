import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Donor/Authorization/login_screen.dart';
import '../../Donor/Model/intro_all_about_model.dart';
import 'tour.dart';
import '../Utils/colors.dart';
import '../Widgets/button.dart';

class Intro4 extends StatefulWidget {
  Intro4({Key? key, required this.list}) : super(key: key);

  List<IntroAllAboutModel> list;

  @override
  State<Intro4> createState() => _Intro4State();
}

class _Intro4State extends State<Intro4> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhite,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: MediaQuery.of(context).size.width * 0.06),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Image.asset(
                "assets/images/intro3.png",
                height: MediaQuery.of(context).size.height * 0.26,
                width: MediaQuery.of(context).size.width,
                // fit: BoxFit.cover,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.11),
              Text("Wallet",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              widget.list.isNotEmpty
                  ? Text(widget.list[0].wallet.toString(),
                      //"Send & receive donations directly into your crypto wallet",
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(fontSize: 14, height: 1.5),
                      ))
                  : const Text(""),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, size: 15, color: kLightYellow),
                  const SizedBox(width: 6),
                  Icon(Icons.circle, size: 15, color: kMediumYellow),
                  const SizedBox(width: 6),
                  Icon(Icons.circle, size: 15, color: kBrightYellow),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              InkWell(
                onTap: () {
                  navigatePush(context, const TourScreen());
                },
                child: button(context, "Get Started", false),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.055),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?   ",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      )),
                  InkWell(
                      onTap: () {
                        navigateReplace(context, const LoginScreen());
                      },
                      child: Text("Log In",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: kBrightYellow,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
