
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/colors.dart';


Widget emptyBookMarkWidget(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        "assets/images/empty_book_mark.png",
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.07,
      ),
      Text(
        "You have no bookmark",
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                color: kBlack, fontSize: 16, fontWeight: FontWeight.w400)),
      )
    ],
  );
}