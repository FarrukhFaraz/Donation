import 'dart:async';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Charity/all_charity.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/donor_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Intro_Screen/intro1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('user');
    //prefs.setString('user', "charity");

    Timer(const Duration(milliseconds: 1800), () {
      if (token == null) {
        navigateReplace(context, const Intro1());
      } else {
        if (user == 'charity') {
          navigateReplace(context, const AllCharity());
        } else {
          navigateReplace(context, DonorHomePage(index: 0));
        }
      }
    });
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: kColor,
      body: Center(
        child: Image.asset(
          "assets/images/splash_screen.png",
          fit: BoxFit.cover,
        ),
      ),
    ));
  }
}
