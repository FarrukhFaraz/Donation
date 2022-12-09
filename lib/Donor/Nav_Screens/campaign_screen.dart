import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widgets/campaign/campaign_item_widget.dart';
import '../Screens/CampaignScreen/collaborate/collaborate.dart';
import '../Screens/CampaignScreen/draft/draft.dart';
import '../Screens/CampaignScreen/on_going/on_going_campaign.dart';
import '../Screens/CampaignScreen/schedule_campaign/schedule_campaign.dart';
import '../Screens/CampaignScreen/start_campaign/start_campaign.dart';
import '../Screens/Notification/notification_screen.dart';


class CampaignScreen extends StatefulWidget {
  const CampaignScreen({Key? key}) : super(key: key);

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: MediaQuery.of(context).size.width * 0.06,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    child: Text("Campaign",
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  )),
                  InkWell(
                    onTap: () {
                      navigatePush(context,const NotificationScreen());
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
                        "assets/images/notification.png",
                        height:
                        MediaQuery.of(context).size.height * 0.02,
                        width:
                        MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.035),
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  InkWell(
                    onTap: () {
                      navigatePush(context, const StartCampaign());
                    },
                    child: campaignItemWidget(context, "Start a campaign",
                        "assets/images/nav_campaign.png"),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  InkWell(
                    onTap: () {
                      navigatePush(context, const ViewOnGoingCampaign());
                    },
                    child: campaignItemWidget(context, "View on-going campaign",
                        "assets/images/campaign_view.png"),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  InkWell(
                    onTap: () {
                      navigatePush(context, const ScheduleCampaign());
                    },
                    child: campaignItemWidget(context, "Schedule campaign",
                        "assets/images/campaign_schedule.png"),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  InkWell(
                    onTap: () {
                      navigatePush(context, const CollaborateScreen());
                    },
                    child: campaignItemWidget(context, "Collaborate",
                        "assets/images/campaign_collaborate.png"),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  InkWell(
                      onTap: () {
                        navigatePush(context, const DraftCampaignScreen());
                      },
                      child: campaignItemWidget(context, "Drafts",
                          "assets/images/campaign_draft.png")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
