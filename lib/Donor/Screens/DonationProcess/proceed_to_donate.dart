import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:give_alil_bit_new/Widgets/form_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Utils/CheckConnection.dart';
import '../../../../Widgets/button.dart';
import '../../../Utils/messages.dart';
import '../../Model/all_donate_model.dart';

class ProceedToDonate extends StatefulWidget {
  ProceedToDonate({Key? key, required this.model}) : super(key: key);

  AllDonateModel model;

  @override
  State<ProceedToDonate> createState() => _ProceedToDonateState();
}

class _ProceedToDonateState extends State<ProceedToDonate> {
  TextEditingController addressController = TextEditingController();
  TextEditingController ostController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  String hint = "";
  String fieldHint = "Bitcoin";
  bool obsecure = true;

  bool loader = false;
  bool checkConnection = false;

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      submitData();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  submitData() async {
    setState(() {
      loader = true;
    });
    Map? body;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var donateType = prefs.getString('donateType');
    var donateItemId = prefs.getString('donateItemId');
    print(donateItemId);
    print(token);
    if (donateType == "1") {
      body = {
        "donatetype": "1",
        //"campaign_id":"",
        "donate_id": "1",
        "amounttype": "paypal",
        "amount": amountController.text.trim(),
      };
    } else if (donateType == "2") {
      body = {
        "donatetype": "2",
        //"donate_id":"",
        "campaign_id": "1",
        "amounttype": "paypal",
        "amount": amountController.text.trim(),
      };
    }
    try {

      print(body);
      http.Response response = await http.post(Uri.parse(addDonorHistory),
          headers: {"Authorization": "Bearer 3|tTeWDEtc3UaTUJHrITm7KSWiFAddp8a1J5nrHcUX"}, body: body);
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, "Payment sent successfully");
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
    // print(widget.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: MediaQuery.of(context).size.width * 0.06,
        ),
        child: Column(
          children: [
            /*Row(
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
                  child: Text("Proceed to Donate",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                )),
              ],
            ),*/
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: kWhite),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Wallet Address',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      )),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  formFields(
                    addressController,
                    "Type here",
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  formWidget(ostController, widget.model.title!),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    'Donate Amount',
                    style: GoogleFonts.montserrat(
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  formFields(
                    amountController,
                    "100",
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: (){
                            setState(() {
                              amountController.text='100';
                            });
                          },
                          child: text("\$100")),
                      InkWell(
                          onTap: (){
                            setState(() {
                              amountController.text='200';
                            });
                          },
                          child: text("\$200")),
                      InkWell(
                          onTap: (){
                            setState(() {
                              amountController.text='300';
                            });
                          },
                          child: text("\$300")),
                      InkWell(
                          onTap: (){
                            setState(() {
                              amountController.text='400';
                            });
                          },
                          child: text("\$400")),

                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  /*Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: MediaQuery.of(context).size.width * 0.02),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: loginField),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(" 0.0034245", style: GoogleFonts.montserrat()),
                            Text(" \$350.50", style: GoogleFonts.montserrat()),
                          ],
                        ),
                        Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: kWhite,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset(
                                      "assets/images/crypto.png",
                                      height: 25,
                                    )),
                                const SizedBox(width: 2),
                                SizedBox(
                                  height: 25,
                                  child: DropdownButton<String>(
                                    underline: const SizedBox(),
                                    items: const [
                                      DropdownMenuItem(
                                        value: "Bitcoin",
                                        child: Text("BitCoin"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Etherium",
                                        child: Text("Etherium"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Bitcoin",
                                        child: Text("Bitcoin"),
                                      ),
                                    ],
                                    hint: Text(fieldHint,
                                        style: GoogleFonts.montserrat()),
                                    borderRadius: BorderRadius.circular(12),
                                    elevation: 1,
                                    onChanged: (value) {
                                      setState(() {
                                        fieldHint = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
            const SizedBox(height: 16),
            /*Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: kWhite,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text("Amount include transaction fee",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat())),
                      Text(
                        "\$235.50",
                        style: GoogleFonts.montserrat(
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                          child: Text("Unit Price",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat())),
                      Text(
                        "BTC \$40,000",
                        style: GoogleFonts.montserrat(
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                          child: Text("Network fee",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat())),
                      Text(
                        "\$5.50",
                        style: GoogleFonts.montserrat(
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                ],
              ),
            ),*/
            const SizedBox(height: 15),
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
                            child: Text("Input Password",
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ))),
                        content: Container(
                          // height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: loginField,
                          ),
                          child: TextFormField(
                            cursorColor: kBrightYellow,
                            obscureText: obsecure,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Enter password",
                              hintStyle: GoogleFonts.montserrat(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    obsecure = !obsecure;
                                  });
                                },
                                child: Icon(
                                  obsecure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: kGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                              onTap: () {
                                /////////////
                                checkConnectivity();
                              },
                              child: button(context, "Donate", loader),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              },
              child: button(context, "Donate", false),
            ),
          ],
        ),
      ),
    ));
  }

  Widget text(String txt) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), color: kLightYellow),
        child: Text(
          txt,
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(color: kBrightYellow)),
        ),
      ),
    );
  }

  Widget formWidget(TextEditingController controller, String hint) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 50,
      //MediaQuery.of(context).size.height*0.060,
      // padding: const EdgeInsets.symmetric(
      //   horizontal: 6,
      // ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kLight,
      ),
      child: Text(hint),
    );
  }
}
