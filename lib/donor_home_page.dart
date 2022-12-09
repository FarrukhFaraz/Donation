import 'package:flutter/material.dart';

import 'Donor/Nav_Screens/campaign_screen.dart';
import 'Donor/Nav_Screens/home_screen.dart';
import 'Donor/Nav_Screens/profile_screen.dart';
import 'Donor/Nav_Screens/wallet_screen.dart';
import 'Utils/colors.dart';


class DonorHomePage extends StatefulWidget {
  DonorHomePage({Key? key, required this.index}) : super(key: key);

  int index;

  @override
  State<DonorHomePage> createState() => _DonorHomePageState(index);
}

class _DonorHomePageState extends State<DonorHomePage> {
  _DonorHomePageState(this.index);

  int index;

  List bottomNavList = [
    const HomeScreen(),
    const CampaignScreen(),
    const WalletScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (ind) {
          setState(() {
            index = ind;
          });
        },
        // iconSize: 20,
        selectedItemColor: kColor,
        unselectedItemColor: kBlack,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/nav_home.png",
              width: MediaQuery.of(context).size.width * 0.055,
              height: MediaQuery.of(context).size.height * 0.055,
              //fit: BoxFit.cover,
              color: index == 0 ? kColor : kGrey,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/nav_campaign.png",
              width: MediaQuery.of(context).size.width * 0.055,
              height: MediaQuery.of(context).size.height * 0.06,
              color: index == 1 ? kColor : kGrey,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/nav_wallet.png",
              width: MediaQuery.of(context).size.width * 0.055,
              height: MediaQuery.of(context).size.height * 0.05,
              color: index == 2 ? kColor : kGrey,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/nav_profile.png",
              width: MediaQuery.of(context).size.width * 0.05,
              height: MediaQuery.of(context).size.height * 0.045,
              color: index == 3 ? kColor : kGrey,
            ),
            label: "",
          ),
        ],
      ),
      body: bottomNavList[index],
    ));
  }
}
