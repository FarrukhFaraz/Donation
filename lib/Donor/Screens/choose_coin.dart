import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/bottom_nav.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseCoin extends StatefulWidget {
  const ChooseCoin({Key? key}) : super(key: key);

  @override
  State<ChooseCoin> createState() => _ChooseCoinState();
}

class _ChooseCoinState extends State<ChooseCoin> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: bottomNav(context, 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: MediaQuery.of(context).size.width * 0.06,
        ),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
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
                  child: Text("Choose a Coin",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                )),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: searchController,
                autofocus: false,
                decoration: InputDecoration(
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.2, color: kColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(width: 1.2, color: kColor),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: kGrey,
                  ),
                  hintText: "Search coin...",
                  hintStyle: GoogleFonts.montserrat(),
                ),
                cursorColor: kBrightYellow,
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 7,
              itemBuilder: (context, index) {
                return itemWidget();
              },
            ),
          ],
        ),
      ),
    ));
  }

  Widget itemWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      //height: MediaQuery.of(context).size.height*0.1,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kWhite,
      ),
      alignment: Alignment.center,
      child: ListTile(
        leading: const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage("assets/icons/cd.png"),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "\$350.50",
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kBlack)),
            ),
            Text(
              "0.0000222",
              style: GoogleFonts.montserrat(textStyle: TextStyle(color: kGrey)),
            ),
          ],
        ),
        title: Text(
          "Etherium",
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: kBlack)),
        ),
        subtitle: Text(
          "ETH",
          style: GoogleFonts.montserrat(textStyle: TextStyle(color: kGrey)),
        ),
      ),
    );
  }
}
