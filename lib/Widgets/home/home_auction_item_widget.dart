import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../Donor/Model/all_campaign_model.dart';
import '../../Donor/Screens/CampaignScreen/campaign_detail.dart';
import '../../Utils/colors.dart';

Widget homeAuctionCampaignWidget(BuildContext context, AllCampaignModel model) {
  double raised = double.parse(model.raised.toString());
  double goal = double.parse(model.campaignGoal.toString());
  double percent = (raised/goal);

  return InkWell(
    onTap: (){
      navigatePush(context, CampaignDetail(model: model, donateType: "2",));
    },
    child: Container(
      margin: EdgeInsets.symmetric(
        vertical:15,
        horizontal: MediaQuery.of(context).size.width * 0.06,
      ),
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height * 0.59,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kWhite,
      ),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.036),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:  FadeInImage(
                    placeholder: const AssetImage("assets/images/placeholder.png"),
                    image: NetworkImage(model.image!
                    ),
                    fit: BoxFit.cover,
                  ), /*Image.asset(
                    'assets/icons/check.png',
                    fit: BoxFit.cover,
                  ),*/
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              //   child: const CircleAvatar(
              //     radius: 15,
              //     backgroundImage: AssetImage("assets/images/Icon.png"),
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Text(
            model.auctionTitle!,
            style: GoogleFonts.montserrat(
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          LinearPercentIndicator(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.03),
            width: MediaQuery.of(context).size.width * 0.8,
            animation: true,
            curve: Curves.bounceInOut,
            barRadius: const Radius.circular(2),
            lineHeight: 8,
            percent: percent,
            progressColor: kBrightYellow,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Container(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.03,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Raised",
                  style: GoogleFonts.montserrat(),
                ),
                Text(
                  "${percent*100}%",
                  style: GoogleFonts.montserrat(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.watch_later_outlined,
                size: 20,
                color: kBrightYellow,
              ),
              Text("  ${model.endDate!}", style: GoogleFonts.montserrat()),
            ],
          )
        ],
      ),
    ),
  );
}
