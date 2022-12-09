import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Charity/charity_payment_history.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:google_fonts/google_fonts.dart';

class CharityDrawer extends StatefulWidget {
  const CharityDrawer({Key? key}) : super(key: key);

  @override
  State<CharityDrawer> createState() => _CharityDrawerState();
}

class _CharityDrawerState extends State<CharityDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 150,
              child: DrawerHeader(
                decoration: const BoxDecoration(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(CupertinoIcons.back),
                    ),
                    Text("More",
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        )),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(CupertinoIcons.xmark),
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              color: Colors.black26,
            ),
            const SizedBox(height: 8),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                navigatePush(context, const CharityPaymentHistory());
              },
              leading: const Icon(CupertinoIcons.money_dollar_circle),
              title: Text("Donations",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(fontSize: 20.0),
                  )),
            ),
            const SizedBox(height: 8),
            /* ListTile(
              onTap: () {
                navigatePush(context, const AboutScreen());
              },
              leading: const Icon(Icons.info_outline),
              title:  Text(
                "About Us",
                style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 20.0)),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
