import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Donor/Model/donate_category_model.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/colors.dart';
import 'charity_screen.dart';

class AllCharityCategory extends StatefulWidget {
  const AllCharityCategory({Key? key, required this.cateList})
      : super(key: key);

  final List<DonateCategoryModel> cateList;

  @override
  State<AllCharityCategory> createState() => _AllCharityCategoryState();
}

class _AllCharityCategoryState extends State<AllCharityCategory> {
//  List<DonateCategoryModel> list = <DonateCategoryModel>[];

  /*bool loader = false;
  bool checkConnection = false;

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      loadList();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  loadList() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      http.Response response = await http.get(Uri.parse(allDonateCategoryURL),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['statusCode'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          DonateCategoryModel pos = DonateCategoryModel();
          pos = DonateCategoryModel.fromJson(obj);
          pos.color = kBlack;
          pos.bgColor = kWhite;
          list.add(pos);
        }
        print("List : ${list.length}");
      } else {
        showSnackMessage(context, "Something went wrong!");
      }
    } catch (e) {
      print(e);
      showSnackMessage(context, "Network failed");
    }
    setState(() {
      loader = false;
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    //checkConnectivity();
    widget.cateList.removeAt(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: bgColor,
      body: widget.cateList.isEmpty
          ? const Center(
              child: Text("No Category available yet"),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Row(
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
                          child: Text("All Categories",
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                        )),
                      ],
                    ),
                  ),
                   SizedBox(height: MediaQuery.of(context).size.height*0.02),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: widget.cateList.length,
                      itemBuilder: (context, index) {
                        return itemWidget(index, widget.cateList[index].id!,
                                widget.cateList[index].name.toString());
                      },
                    ),
                  )
                ],
              ),
            ),
    ));
  }

  Widget itemWidget(int index, int id, String name) {
    return InkWell(
      onTap: () {
        navigatePush(context, CharityScreen(id: id, txt: name));
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kWhite,
        ),
        child: Text(name,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(fontSize: 16,color: kBlack, fontWeight: FontWeight.w600),
            )),
      ),
    );
  }
}
