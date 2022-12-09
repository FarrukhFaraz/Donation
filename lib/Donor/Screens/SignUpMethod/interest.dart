import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:give_alil_bit_new/donor_home_page.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Widgets/button.dart';
import '../../Model/sign_up_interest_model.dart';

class SelectInterest extends StatefulWidget {
  const SelectInterest({Key? key}) : super(key: key);

  @override
  State<SelectInterest> createState() => _SelectInterestState();
}

class _SelectInterestState extends State<SelectInterest> {
  List<SignUpInterestModel> list = <SignUpInterestModel>[];

  @override
  void initState() {
    // TODO: implement initState
    list = getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: 10, horizontal: MediaQuery.of(context).size.width * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Text("Select Your Interest",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: kColor, fontSize: 24, fontWeight: FontWeight.bold),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              "Your feed will be personalized based on your interests. Don’t worry you can change it later.",
              maxLines: 5,
              style: GoogleFonts.montserrat(),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.040),
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return itemWidget(
                      index,
                      list[index].name,
                      list[index].image,
                      list[index].txtColor,
                      list[index].color,
                      list[index].bgColor);
                }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.040),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          icon: Icon(
                            Icons.check_circle,
                            color: kBrightYellow,
                            size: 60,
                          ),
                          title: Text("Great!",
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )),
                          alignment: Alignment.center,
                          content: Text(
                            "Your account has been successfully created.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(),
                            maxLines: 4,
                          ),
                          actions: [
                            InkWell(
                              onTap: () {
                                navigatePush(
                                    context,
                                    DonorHomePage(
                                      index: 0,
                                    ));
                              },
                              child: button(context, "Go Home", false),
                            ),
                          ],
                          actionsAlignment: MainAxisAlignment.center,
                        ));
              },
              child: button(context, "Continue", false),
            ),
          ],
        ),
      ),
    ));
  }

  Widget itemWidget(int index, String name, String image, Color txtColor,
      Color color, Color bgColor) {
    return InkWell(
      onTap: () {
        setState(() {
          list = getList();
          list[index].color = kWhite;
          list[index].bgColor = kColor;
          list[index].txtColor = kWhite;
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: bgColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              color: color,
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.12,
            ),
            const SizedBox(height: 6),
            Text(name,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(color: txtColor),
                ))
          ],
        ),
      ),
    );
  }
}
