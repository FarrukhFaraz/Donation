import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Charity/Model/charity_payment_history.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/CheckConnection.dart';

class CharityPaymentHistory extends StatefulWidget {
  const CharityPaymentHistory({Key? key}) : super(key: key);

  @override
  State<CharityPaymentHistory> createState() => _CharityPaymentHistoryState();
}

class _CharityPaymentHistoryState extends State<CharityPaymentHistory> {
  bool loader = false;
  bool checkConnection = false;
  double totalAmount=0.0;

  List<CharityPaymentModel> list = <CharityPaymentModel>[];

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
    var token = prefs.getString('token');
    var charityId = prefs.getString('charityId');

    try {
      http.Response response = await http.post(
          Uri.parse(charityPaymentHistoryURL),
          headers: {"Authorization": "Bearer $token"},
          body: {"donate_id": charityId.toString()});

      Map jsonData = jsonDecode(response.body);

      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          CharityPaymentModel pos = CharityPaymentModel();
          pos = CharityPaymentModel.fromJson(obj);
          list.add(pos);
          if(pos.amount!=null){
            totalAmount = totalAmount+double.parse(pos.amount.toString()); 
          }
          print(totalAmount);
          print(pos.amount);
        }
        setState(() {
          loader = false;
        });
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, "Something went wrong");
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      showSnackMessage(context, "Something went wrong");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
                      vertical: MediaQuery.of(context).size.height * 0.025,
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Column(
                      children: [
                        //  const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "All Donations to this charity",
                                  style: GoogleFonts.montserrat(),
                                ),
                              ),
                            ),
                            Text(
                              "Total: \$${totalAmount}",
                              style: GoogleFonts.montserrat(
                                  fontSize: 12, color: kColor),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        list.isEmpty
                            ? Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.35),
                                child: const Text(
                                    "No one yet donated this charity"),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      // navigatePush(
                                      //     context,
                                      //     CharityPaymentDetail(
                                      //       modelList: list ,
                                      //     ));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06),
                                      decoration: BoxDecoration(
                                          color: kWhite,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Row(
                                        children: [
                                          /*list[index].user!.image == null
                                              ? Image.asset(
                                                  "assets/images/placeholder.png",
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                )
                                              : Image.network(
                                                  list[index]
                                                      .user!
                                                      .image
                                                      .toString(),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                ),*/
                                          const SizedBox(width: 12),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                list[index].user!.name == null
                                                    ? "No Name"
                                                    : list[index]
                                                        .user!
                                                        .name
                                                        .toString(),
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 14,
                                                    color: kBlack,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                list[index].user!.phone == null
                                                    ? list[index]
                                                        .user!
                                                        .email
                                                        .toString()
                                                    : list[index]
                                                        .user!
                                                        .phone
                                                        .toString(),
                                                style: GoogleFonts.montserrat(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          )),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "\$${list[index].amount}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 14,
                                                    color: kColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                "${list[index].updatedAt?.split("T").first}",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
          ));
  }
}
