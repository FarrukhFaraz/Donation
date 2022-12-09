import 'package:flutter/material.dart';

import '../../../../Utils/colors.dart';





class NewStartCampaign extends StatefulWidget {
  const NewStartCampaign({Key? key}) : super(key: key);

  @override
  State<NewStartCampaign> createState() => _NewStartCampaignState();
}

class _NewStartCampaignState extends State<NewStartCampaign> {
  String fieldHint = "Pick a category";

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
                  child: const Text(
                    "Start a campaign",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 20),
            //////////////////////

            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: kWhite),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Campaign title',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  textField(),
                  const SizedBox(height: 8),
                  const Text(
                    'Location',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  textField(),
                  const SizedBox(height: 8),
                  const Text(
                    'Campaign Goal',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  textField(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      text("\$100"),
                      text("\$200"),
                      text("\$300"),
                      text("\$400"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category',
                    style: TextStyle(
                        color: kBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: kLightGrey,
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: [
                        DropdownMenuItem(
                          value: "Pick a category",
                          child: Text(fieldHint),
                        ),
                        const DropdownMenuItem(
                          value: "Web",
                          child: Text("Web"),
                        ),
                        const DropdownMenuItem(
                          value: "App",
                          child: Text("App"),
                        ),
                        const DropdownMenuItem(
                          value: "Desktop",
                          child: Text("Desktop"),
                        ),
                      ],
                      hint: Text(
                        fieldHint,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      elevation: 0,
                      onChanged: (value) {
                        setState(() {
                          fieldHint = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: kColor,
                elevation: 0,
                minimumSize: const Size(double.infinity, 40),
                maximumSize: const Size(double.infinity, 40),
              ),
              onPressed: () {},
              child: const Text("Start Campaign"),
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
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), color: kLightGrey),
        child: Text(
          txt,
          style: TextStyle(color: kBrightYellow),
        ),
      ),
    );
  }

  Widget textField() {
    return Container(
      decoration: BoxDecoration(
          color: kLightGrey, borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        decoration: InputDecoration(
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(width: 1.2, color: kColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(width: 1.2, color: kColor),
          ),
        ),
      ),
    );
  }
}
