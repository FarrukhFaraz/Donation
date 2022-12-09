import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/colors.dart';

Widget campaignItemWidget(BuildContext context, String title, String icon) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: MediaQuery.of(context).size.height * 0.01,
      horizontal: MediaQuery.of(context).size.width * 0.02,
    ),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: kWhite,
    ),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: kLight,
          ),
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.01,
          ),
          child: Image.asset(
            icon,
            //fit: BoxFit.cover,
            color: kColor,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.08,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
            child: Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ))),
        Icon(
          Icons.arrow_forward_ios,
          color: kBrightYellow,
        )
      ],
    ),
  );
}
