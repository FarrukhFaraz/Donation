import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/colors.dart';

Widget button(BuildContext context, String txt, bool loader) {
  return Container(
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width,
    // height: 50,
    padding: EdgeInsets.symmetric(
      vertical: MediaQuery.of(context).size.height * 0.02,
    ),
    //MediaQuery.of(context).size.height * 0.06,
    decoration: BoxDecoration(
        color: kColor,
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.2),
            blurRadius: MediaQuery.of(context).size.height / 46,
            offset: Offset(0, MediaQuery.of(context).size.height / 46),
          ),
        ],
        borderRadius: BorderRadius.circular(
          12,
        )),
    child: loader
        ?  Container(
            child: CircularProgressIndicator(color: kBrightYellow,),
          )
        : Text(txt,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  color: kWhite, fontSize: 16, fontWeight: FontWeight.w600),
            )),
  );
}
