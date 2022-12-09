import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Donor/Model/intro_all_about_model.dart';
import '../Utils/colors.dart';
import '../Widgets/button.dart';
import 'intro4.dart';

class Intro3 extends StatefulWidget {
  Intro3({Key? key, required this.list}) : super(key: key);

  List<IntroAllAboutModel> list;

  @override
  State<Intro3> createState() => _Intro3State();
}

class _Intro3State extends State<Intro3> {
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
                "assets/images/intro2.png",
                height: MediaQuery.of(context).size.height * 0.26,
                width: MediaQuery.of(context).size.width,
                //fit: BoxFit.cover,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.11),
              Text("Fundraising",
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
                  ? Text(widget.list[0].fundraising.toString(),
                      //"Fundraise with transparency, publish & get people support your campaign",
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
                  Icon(Icons.circle, size: 15, color: kBrightYellow),
                  const SizedBox(width: 6),
                  Icon(Icons.circle, size: 15, color: kMediumYellow),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              InkWell(
                onTap: () {
                  navigatePush(
                      context,
                      Intro4(
                        list: widget.list,
                      ));
                },
                child: button(context, "Next", false),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.035),
              TextButton(
                  onPressed: () {
                    navigatePush(
                        context,
                        Intro4(
                          list: widget.list,
                        ));
                  },
                  child: Text("Skip",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
