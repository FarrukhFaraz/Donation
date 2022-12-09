import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/colors.dart';

Widget formFields(TextEditingController controller, String hint) {
  return Container(
    alignment: Alignment.center,
    // height: 50,
    //MediaQuery.of(context).size.height*0.060,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: loginField,
    ),
    child: TextFormField(
      controller: controller,
      cursorColor: kBrightYellow,
      decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: GoogleFonts.montserrat(),
          fillColor: loginField,
          focusColor: loginField,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          )),
    ),
  );
}
