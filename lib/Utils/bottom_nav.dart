import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/donor_home_page.dart';

import 'colors.dart';

Widget bottomNav(BuildContext context, int index) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    iconSize: 20,
    selectedItemColor: kColor,
    unselectedItemColor: kBlack,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: InkWell(
          onTap: () {
            navigateReplace(context, DonorHomePage(index: 0));
          },
          child: Image.asset(
            "assets/images/nav_home.png",
            width: MediaQuery.of(context).size.width * 0.055,
            height: MediaQuery.of(context).size.height * 0.055,
            color: index == 0 ? kColor : kGrey,
          ),
        ),
        label: "",
      ),
      BottomNavigationBarItem(
        icon: InkWell(
          onTap: () {
            navigateReplace(context, DonorHomePage(index: 1));
          },
          child: Image.asset(
            "assets/images/nav_campaign.png",
            width: MediaQuery.of(context).size.width * 0.055,
            height: MediaQuery.of(context).size.height * 0.06,
            color: index == 1 ? kColor : kGrey,
          ),
        ),
        label: "",
      ),
      BottomNavigationBarItem(
        icon: InkWell(
          onTap: () {
            navigateReplace(context, DonorHomePage(index: 2));
          },
          child: Image.asset(
            "assets/images/nav_wallet.png",
            width: MediaQuery.of(context).size.width * 0.055,
            height: MediaQuery.of(context).size.height * 0.05,
            color: index == 2 ? kColor : kGrey,
          ),
        ),
        label: "",
      ),
      BottomNavigationBarItem(
        icon: InkWell(
          onTap: () {
            navigateReplace(context, DonorHomePage(index: 3));
          },
          child: Image.asset(
            "assets/images/nav_profile.png",
            width: MediaQuery.of(context).size.width * 0.05,
            height: MediaQuery.of(context).size.height * 0.045,
            color: index == 3 ? kColor : kGrey,
          ),
        ),
        label: "",
      ),
    ],
  );
}
