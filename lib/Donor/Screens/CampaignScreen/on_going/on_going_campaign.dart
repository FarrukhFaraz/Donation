import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewOnGoingCampaign extends StatefulWidget {
  const ViewOnGoingCampaign({Key? key}) : super(key: key);

  @override
  State<ViewOnGoingCampaign> createState() => _ViewOnGoingCampaignState();
}

class _ViewOnGoingCampaignState extends State<ViewOnGoingCampaign> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: MediaQuery.of(context).size.width * 0.06,
      ),
      child: Column(children: [
        Row(
          children: [
            GestureDetector(
              onTap: (){
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
                  child: const Text(
                    "View on going campaign",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
          ],
        ),
         SizedBox(height:MediaQuery.of(context).size.height*0.14 ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: kWhite,
          ),
          // height: MediaQuery.of(context).size.height * 0.045,
          //  width: MediaQuery.of(context).size.width * 0.09,
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.02,
          ),
          child: Image.asset(
            "assets/images/empty_book_mark.png",
            height: MediaQuery.of(context).size.height*0.35,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height*0.04,),
        Text('No on going campaign found',
          style: GoogleFonts.montserrat(textStyle: TextStyle(
              color: kBlack, fontSize: 16, fontWeight: FontWeight.w400)),
        ),

      ],),
    ),
    ));
  }
}
