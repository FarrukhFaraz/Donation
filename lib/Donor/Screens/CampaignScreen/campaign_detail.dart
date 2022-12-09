import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Donor/Model/all_campaign_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/colors.dart';
import '../../../Widgets/button.dart';
import '../DonationProcess/paypal_payment.dart';

class CampaignDetail extends StatefulWidget {
  const CampaignDetail(
      {Key? key, required this.model, required this.donateType})
      : super(key: key);

  final AllCampaignModel model;
  final String donateType;

  @override
  State<CampaignDetail> createState() => _CampaignDetailState();
}

class _CampaignDetailState extends State<CampaignDetail> {
  var a;

  bool loader = false;
  bool checkConnection = false;

  double percent = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    double raised = double.parse(widget.model.raised.toString());
    double goal = double.parse(widget.model.campaignGoal.toString());
    percent = raised / goal;
    super.initState();
  }

  static void navigateTo(String lat, String lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: bgColor,
      body: loader
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: widget.model.image == null
                            ? Image.asset("assets/images.placeholder.png")
                            :
                        FadeInImage(
                                placeholder: const AssetImage(
                                    "assets/images.placeholder.png"),
                                image: NetworkImage(widget.model.image!),
                                fit: BoxFit.cover,
                              ),
                        /*Image.asset(
                    "assets/icons/check2.png",
                    fit: BoxFit.cover,
                  ),*/
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.06,
                            vertical:
                                MediaQuery.of(context).size.height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: kGrey,
                                ),
                                // height: MediaQuery.of(context).size.height * 0.045,
                                //  width: MediaQuery.of(context).size.width * 0.09,
                                padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.015,
                                ),
                                child: Image.asset(
                                  "assets/images/back.png",
                                  color: kWhite,
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  width:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                            ),
                            /*InkWell(
                              onTap: () {
                                if (widget.model.favouriteStatus == "1") {
                                  removeBookMark(widget.model);
                                } else {
                                  addToBookMar(widget.model);
                                }
                              },
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor:
                                    widget.model.favouriteStatus == "1"
                                        ? kBrightYellow
                                        : Colors.white,
                                child: Icon(
                                  Icons.bookmark,
                                  color: widget.model.favouriteStatus == "1"
                                      ? kWhite
                                      : Colors.black54,
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.018),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: Text(widget.model.campaignTitle!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kBlack,
                                    fontSize: 18),
                              )),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025),
                        LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width * 0.94,
                          animation: true,
                          curve: Curves.bounceInOut,
                          barRadius: const Radius.circular(2),
                          lineHeight: 8,
                          percent: percent,
                          progressColor: kBrightYellow,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Raised", style: GoogleFonts.montserrat()),
                              Text("${percent * 100}%",
                                  style: GoogleFonts.montserrat()),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("Target:",
                                      style: GoogleFonts.montserrat()),
                                  Text(
                                    "\$${widget.model.campaignGoal}",
                                    style: GoogleFonts.montserrat(
                                        textStyle:
                                            TextStyle(color: kBrightYellow)),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Raised:",
                                      style: GoogleFonts.montserrat()),
                                  Text(
                                    "\$${widget.model.raised}",
                                    style: GoogleFonts.montserrat(
                                        textStyle:
                                            TextStyle(color: kBrightYellow)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: Text("${widget.model.auctionTitle}",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: kBlack),
                              )),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: InkWell(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_sharp,
                                  color: kColor,
                                ),
                                Text(" ${widget.model.location}",
                                    style: GoogleFonts.montserrat()),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025),
                        /*Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width * 0.03,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: kWhite),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Text(
                              "Education",
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: kColor,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: kWhite,
                            ),
                            margin: const EdgeInsets.only(left: 5),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Text(
                              "Infrastructure",
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: kColor,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),*/
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025),
                        /* Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: kLight, width: 2)),
                        margin: EdgeInsets.symmetric(
                          horizontal:
                          MediaQuery.of(context).size.width * 0.03,
                        ),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: InkWell(
                          onTap: () {
                          },
                          child: Stack(
                            children: [
                              Image.asset(
                                "assets/icons/map.png",
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                  left:
                                  MediaQuery.of(context).size.width / 2.2,
                                  top: MediaQuery.of(context).size.height *
                                      0.08,
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025),*/
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: Text("About Campaign",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: kBlack),
                              )),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.014),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: Text(widget.model.about!,
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat()),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.035),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: InkWell(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('donateType', widget.donateType);
                              prefs.setString(
                                  'donateItemId', widget.model.id.toString());

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PaypalPayment(
                                    onFinish: (number) async {
                                      // payment done
                                      print('order id: ' + number);
                                    },
                                  ),
                                ),
                              );
                            },
                            child: button(context, "Donate", false),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.014)
                      ],
                    ),
                  ),
                ],
              ),
            ),
    ));
  }
}
