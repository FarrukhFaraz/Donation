import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Donor/Model/all_campaign_model.dart';
import 'package:give_alil_bit_new/Donor/Model/all_donate_model.dart';
import 'package:give_alil_bit_new/Donor/Model/donate_history_model.dart';
import 'package:give_alil_bit_new/Donor/Screens/CampaignScreen/campaign_detail.dart';
import 'package:give_alil_bit_new/Donor/Screens/CharityScreen/charity_detail.dart';
import 'package:give_alil_bit_new/Donor/Screens/Notification/notification_screen.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/button.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  //TextEditingController nameController = TextEditingController();
//  TextEditingController numberController = TextEditingController();
  // TextEditingController dateController = TextEditingController();
  // TextEditingController cvvController = TextEditingController();

  bool nameError = false;
  bool numberError = false;
  bool dateError = false;
  bool cvvError = false;

  bool click = true;
  bool creditClick = false;
  bool cryptoClick = true;
  bool glbClick = false;
  bool loader = false;
  bool checkConnection = false;

  String? notShowWallet;
  var totalAmount;

  List<History> list = <History>[];

  // formValidate() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => StatefulBuilder(
  //       builder: (context, StateSetter setState) {
  //         return AlertDialog(
  //           title: Container(
  //               alignment: Alignment.center, child: const Text("Paypal")),
  //           content: SizedBox(
  //             height: 260,
  //             child: loader
  //                 ? const Center(
  //                     child: CircularProgressIndicator(),
  //                   )
  //                 : SingleChildScrollView(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         formFields(nameController, "Enter Name"),
  //                         Text(
  //                           nameError ? "require" : "",
  //                           style: TextStyle(fontSize: 12, color: Colors.red),
  //                         ),
  //                         SizedBox(
  //                             height:
  //                                 MediaQuery.of(context).size.height * 0.015),
  //                         formFields(numberController, "Enter Number"),
  //                         Text(
  //                           numberError ? "require" : "",
  //                           style: TextStyle(fontSize: 12, color: Colors.red),
  //                         ),
  //                         SizedBox(
  //                             height:
  //                                 MediaQuery.of(context).size.height * 0.015),
  //                         formFields(dateController, "Enter Expiry date"),
  //                         Text(
  //                           dateError ? "require" : "",
  //                           style: TextStyle(fontSize: 12, color: Colors.red),
  //                         ),
  //                         SizedBox(
  //                             height:
  //                                 MediaQuery.of(context).size.height * 0.015),
  //                         formFields(cvvController, "Enter cvv"),
  //                         Text(
  //                           cvvError ? "require" : "",
  //                           style: TextStyle(fontSize: 12, color: Colors.red),
  //                         ),
  //                         SizedBox(
  //                             height:
  //                                 MediaQuery.of(context).size.height * 0.015),
  //                       ],
  //                     ),
  //                   ),
  //           ),
  //           actions: [
  //             loader
  //                 ? Container()
  //                 : Container(
  //                     margin: EdgeInsets.only(
  //                         top: MediaQuery.of(context).size.height * 0.013,
  //                         bottom: MediaQuery.of(context).size.height * 0.025),
  //                     child: InkWell(
  //                       onTap: () {
  //                         setState(() {
  //                           nameError = false;
  //                           numberError = false;
  //                           dateError = false;
  //                           cvvError = false;
  //                         });
  //                         if (nameController.text.isEmpty) {
  //                           setState(() {
  //                             nameError = true;
  //                           });
  //                         } else if (numberController.text.isEmpty) {
  //                           setState(() {
  //                             numberError = true;
  //                           });
  //                         } else if (dateController.text.isEmpty) {
  //                           setState(() {
  //                             dateError = true;
  //                           });
  //                         } else if (cvvController.text.isEmpty) {
  //                           setState(() {
  //                             cvvError = true;
  //                           });
  //                         } else {
  //                           shareData();
  //                         }
  //                       },
  //                       child: button(context, "Confirm", false),
  //                     ),
  //                   )
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  getData() async {
    setState(() {
      notShowWallet = "notShowWallet";
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('notShowWallet', notShowWallet.toString());
  }

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      loadData();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  loadData() async {
    setState(() {
      loader = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var wallet = prefs.getString('notShowWallet');
    var token = prefs.getString('token');
    print(token);
    print(wallet);
    try {
      http.Response response = await http.get(Uri.parse(getDonateHistoryURL),
          headers: {"Authorization": "Bearer $token"});
      Map jsonData = jsonDecode(response.body);
      print(jsonData);
      if (jsonData['statusCode'] == 200) {
        totalAmount = jsonData['data']['total_amout'];
        print(totalAmount);
        for (int i = 0; i < jsonData['data']['history'].length; i++) {
          Map<String, dynamic> obj = jsonData['data']['history'][i];
          History pos = History();
          pos = History.fromJson(obj);
          list.add(pos);
        }
        setState(() {
          loader = false;
        });
      } else {
        setState(() {
          loader = false;
        });
        totalAmount = 0;
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      showSnackMessage(context, "Network failed");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      loader = true;
    });
    checkConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return checkConnection
        ? OfflineUI(function: checkConnectivity)
        : SafeArea(
            child: Scaffold(
            backgroundColor: bgColor,
            body: loader
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: notShowWallet != null
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.center,
                                    child: Text("Wallet",
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  )),
                                ],
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1),
                              Image.asset(
                                "assets/images/wallet.png",
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: MediaQuery.of(context).size.width,
                                //fit: BoxFit.cover,
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Text(
                                "Set up your wallet",
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Text(
                                "GiveAlilBit uses WalletConnect to connect to multiple blockchain wallets.",
                                maxLines: 4,
                                style: GoogleFonts.montserrat(),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.06),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                      builder: (context, StateSetter setState) {
                                        return AlertDialog(
                                          title: Container(
                                              alignment: Alignment.center,
                                              child: Text("WalletConnect",
                                                  style: GoogleFonts.montserrat(
                                                    textStyle: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))),
                                          content: SizedBox(
                                            height: 230,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            click = true;
                                                          });
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            color: click
                                                                ? kColor
                                                                : kLight,
                                                          ),
                                                          child: Text("Mobile",
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                textStyle: TextStyle(
                                                                    color: click
                                                                        ? kWhite
                                                                        : kBlack),
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            click = false;
                                                          });
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            color: click
                                                                ? kLight
                                                                : kColor,
                                                          ),
                                                          child: Text("QR Code",
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                textStyle: TextStyle(
                                                                    color: click
                                                                        ? kBlack
                                                                        : kWhite),
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Choose your preferred wallet",
                                                    style: GoogleFonts
                                                        .montserrat(),
                                                  ),
                                                ),
                                                const SizedBox(height: 15),
                                                click
                                                    ? Column(
                                                        children: [
                                                          /*InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          creditClick = true;
                                                          cryptoClick = false;
                                                          glbClick = false;
                                                        });
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/credit_card.png",
                                                            height: 25,
                                                            width: 25,
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Expanded(
                                                              child: Text(
                                                            " Credit Card",
                                                            style: GoogleFonts
                                                                .montserrat(),
                                                          )),
                                                          creditClick
                                                              ? Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  size: 20,
                                                                  color: kColor,
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                    ),*/
                                                          const Divider(),
                                                          const SizedBox(
                                                              height: 10),
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                creditClick =
                                                                    false;
                                                                cryptoClick =
                                                                    true;
                                                                glbClick =
                                                                    false;
                                                              });
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  "assets/images/crypto.png",
                                                                  height: 25,
                                                                  width: 25,
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Expanded(
                                                                    child: Text(
                                                                        " Paypal",
                                                                        style: GoogleFonts
                                                                            .montserrat())),
                                                                cryptoClick
                                                                    ? Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        size:
                                                                            20,
                                                                        color:
                                                                            kColor,
                                                                      )
                                                                    : const SizedBox(),
                                                              ],
                                                            ),
                                                          ),
                                                          const Divider(),
                                                          const SizedBox(
                                                              height: 10),
                                                          /*InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          creditClick = false;
                                                          cryptoClick = false;
                                                          glbClick = true;
                                                        });
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/glb_token.png",
                                                            height: 25,
                                                            width: 25,
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Expanded(
                                                              child: Text(
                                                                  " GLB Token",
                                                                  style: GoogleFonts
                                                                      .montserrat())),
                                                          glbClick
                                                              ? Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  size: 20,
                                                                  color: kColor,
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                    ),*/
                                                          const Divider(),
                                                        ],
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 8, bottom: 15),
                                              child: InkWell(
                                                onTap: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setString(
                                                      "notShowWallet",
                                                      notShowWallet.toString());
                                                  getData();
                                                  Navigator.pop(context);
                                                },
                                                child: button(
                                                    context, "Next", false),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: button(context, "Connect Wallet", false),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.center,
                                    child: Text("Wallet",
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  )),
                                  InkWell(
                                    onTap: () {
                                      navigatePush(
                                          context, const NotificationScreen());
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: kWhite,
                                      ),
                                      // height: MediaQuery.of(context).size.height * 0.045,
                                      //  width: MediaQuery.of(context).size.width * 0.09,
                                      padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.015,
                                      ),
                                      child: Image.asset(
                                        "assets/images/notification.png",
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total Amount",
                                        style: GoogleFonts.montserrat(
                                            textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "\$$totalAmount",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 18,
                                                color: kColor,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        AssetImage("assets/images/intro1.png"),
                                  )
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.035),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("Donations",
                                    style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return itemWidget(list[index]);
                                },
                              )
                            ],
                          )),
          ));
  }

  Widget itemWidget(History model) {
    return InkWell(
      onTap: () {
        if (model.donatetype == "1") {
          AllDonateModel m = AllDonateModel();
          m.id = model.donate!.id;
          m.categoryId = model.donate!.categoryId;
          m.title = model.donate!.title;
          m.image = model.donate!.image;
          m.percentage = model.donate!.percentage;
          m.target = model.donate!.target;
          m.raised = model.donate!.raised;
          m.foundation = model.donate!.foundation;
          m.location = model.donate!.location;
          m.longitude = model.donate!.longitude;
          m.latitude = model.donate!.latitude;
          m.about = model.donate!.about;
          m.favouriteStatus = model.donate!.favouriteStatus;
          m.createdAt == model.donate!.createdAt;
          m.updatedAt = model.donate!.updatedAt;

          navigatePush(context, CharityDetail(model: m, donateType: "1"));
        } else {
          AllCampaignModel m = AllCampaignModel();
          m.id = model.campaign!.id;
          m.userId = model.campaign!.userId;
          m.categoryId = model.campaign!.categoryId;
          m.campaignTitle = model.campaign!.campaignTitle;
          m.location = model.campaign!.location;
          m.campaignGoal = model.campaign!.campaignGoal;
          m.raised = model.campaign!.raised;
          m.auctionTitle = model.campaign!.auctionTitle;
          m.endDate == model.campaign!.endDate;
          m.image = model.campaign!.image;
          m.about = model.campaign!.about;
          m.updatedAt = model.campaign!.updatedAt;
          m.createdAt = model.campaign!.createdAt;

          navigatePush(context, CampaignDetail(model: m, donateType: '2'));
        }
      },
      child: Container(
        alignment: Alignment.center,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.015),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: kWhite,
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: model.donate == null && model.campaign == null
                    ? Image.asset(
                        "assets/images/placeholder.png",
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.08,
                        fit: BoxFit.cover,
                      )
                    : model.donate == null
                        ? model.campaign!.image == null
                            ? Image.asset(
                                "assets/images/placeholder.png",
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                fit: BoxFit.cover,
                              )
                            : FadeInImage(
                                placeholder: const AssetImage(
                                  "assets/images/placeholder.png",
                                ),
                                image: NetworkImage(
                                    model.campaign!.image.toString()),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                              )
                        : model.donate!.image == null
                            ? Image.asset(
                                "assets/images/placeholder.png",
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                fit: BoxFit.cover,
                              )
                            : FadeInImage(
                                placeholder: const AssetImage(
                                    "assets/images/placeholder.png"),
                                image: NetworkImage(
                                    model.donate!.image.toString()),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                              ),
                // Image.asset(
                //   "assets/icons/check3.png",
                //   height: MediaQuery.of(context).size.height * 0.09,
                //   width: MediaQuery.of(context).size.width * 0.15,
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  model.donate == null && model.campaign == null
                      ? const Text("")
                      : Text(
                          model.donate == null
                              ? model.campaign!.campaignTitle.toString()
                              : model.donate!.title.toString(),
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(fontSize: 14, color: kBlack),
                          )),
                  Text(
                    model.createdAt.toString().split('T').first,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(color: kGrey, fontSize: 12)),
                  ),
                ],
              ),
            ),
            Text("${model.amount}",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: kColor),
                )),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
