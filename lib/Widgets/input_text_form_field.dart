import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/colors.dart';

Widget textInputFormField(BuildContext context, bool click,
    TextEditingController controller, String txt,) {
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
      keyboardType: click ? TextInputType.emailAddress : TextInputType.number,
      cursorColor: kBrightYellow,
      decoration: InputDecoration(
          isDense: true,
          fillColor: loginField,
          hintText: txt,
          hintStyle: GoogleFonts.montserrat(),
          focusColor: loginField,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          )),
    ),
  );
}
