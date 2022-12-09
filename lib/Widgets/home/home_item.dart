import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Charity/New%20folder/charity_category.dart';
import 'package:give_alil_bit_new/Donor/Screens/CharityScreen/charity_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Donor/Screens/CampaignScreen/all_campaign_screen.dart';
import '../../Donor/Screens/CharityScreen/all_charity_category.dart';
import '../../Utils/colors.dart';
import '../../Utils/navigator.dart';

Widget item(BuildContext context, String text1, String text2, int id) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.06,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1,
          style: GoogleFonts.montserrat(
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        InkWell(
          onTap: () {
            debugPrint("clicked");
            if (id == 1) {
              navigatePush(context, const CharityScreen(id: -1, txt: "All Charity"));
            }
            if (id == 2) {
              navigatePush(context, const AllCampaignScreen());
            }
          },
          child: Text(
            text2,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(color: kBrightYellow)),
          ),
        ),
      ],
    ),
  );
}
