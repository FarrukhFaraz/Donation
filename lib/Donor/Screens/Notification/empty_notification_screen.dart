import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/bottom_nav.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyNotification extends StatefulWidget {
  const EmptyNotification({Key? key}) : super(key: key);

  @override
  State<EmptyNotification> createState() => _EmptyNotificationState();
}

class _EmptyNotificationState extends State<EmptyNotification> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: bottomNav(context, 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: 12, horizontal: MediaQuery.of(context).size.width * 0.06),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: kWhite,
                    ),
                    // height: MediaQuery.of(context).size.height * 0.045,
                    //  width: MediaQuery.of(context).size.width * 0.09,
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.015,
                    ),
                    child: Image.asset(
                      "assets/images/back.png",
                      height: MediaQuery.of(context).size.height * 0.02,
                      width: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: Text("Notifications",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                )),
                Switch(
                    activeColor: kColor,
                    value: isSwitched,
                    onChanged: (bol) {
                      setState(() {
                        isSwitched = bol;
                      });
                    })
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            Image.asset(
              "assets/images/notification_image.png",
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Text("You have no notifications", style: GoogleFonts.montserrat()),
          ],
        ),
      ),
    ));
  }
}
