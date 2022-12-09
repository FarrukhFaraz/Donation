import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/donor_home_page.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/colors.dart';
import '../../../../Widgets/button.dart';

class PaymentSent extends StatefulWidget {
  const PaymentSent({Key? key}) : super(key: key);

  @override
  State<PaymentSent> createState() => _PaymentSentState();
}

class _PaymentSentState extends State<PaymentSent> {

  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: 15, horizontal: MediaQuery.of(context).size.width * 0.06),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Row(
              children: [
                Container(
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
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child:  Text(
                        "Payment Sent",
                        style: GoogleFonts.montserrat(textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),)
                      )),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.28,
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: kWhite,
                backgroundImage: const AssetImage(
                  "assets/images/check.png",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
               Text(
                "You sent \$150.50 to 0xDc9AE ...942552Fcf",
                maxLines: 4,
                style: GoogleFonts.montserrat(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.067),
              InkWell(
                onTap: (){
                  debugPrint("clicked");
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.55 ,
                  child: button(context , "QST Foundation" ,loader),
                ),
              ),
            ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.21,
            ),
            InkWell(
              onTap: (){
                navigatePush(context,  DonorHomePage( index: 0,));
              },
              child: button(context , "Go Home" , false),
            ),
            const SizedBox(height: 4,)
          ],
        ),
      ),
    ));
  }
}
