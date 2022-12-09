import 'package:flutter/material.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/navigator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Donor/Model/intro_all_about_model.dart';
import '../Widgets/button.dart';
import 'Intro3.dart';
import 'intro4.dart';

class Intro2 extends StatefulWidget {
  Intro2({Key? key, required this.list}) : super(key: key);
  List<IntroAllAboutModel> list;

  @override
  State<Intro2> createState() => _Intro2State();
}

class _Intro2State extends State<Intro2> {
  int index = 0;

  /*List<SliderItem> slides = [
    SliderItem(
        name: "Education",
        description: "Thor this is new name",
        image: "assets/images/intro1.png"),
    SliderItem(
        name: "School",
        description: "Thor is School",
        image: "assets/images/intro2.png"),
    SliderItem(
        name: "Books",
        description: "Books are very close",
        image: "assets/images/intro3.png"),
  ];*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.06,
          vertical: 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Image.asset(
              "assets/images/intro1.png",
              height: MediaQuery.of(context).size.height * 0.26,
              width: MediaQuery.of(context).size.width,
              //fit: BoxFit.cover,f
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.11),
            Text("Donation",
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            widget.list.isNotEmpty
                ? Text(widget.list[0].donation.toString(),
                    //"Make your donations transparent & anonymous by paying with crypto",
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(fontSize: 14, height: 1.5),
                    ))
                : const Text(""),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, size: 15, color: kBrightYellow),
                const SizedBox(width: 6),
                Icon(Icons.circle, size: 15, color: kMediumYellow),
                const SizedBox(width: 6),
                Icon(Icons.circle, size: 15, color: kLightYellow),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //       maximumSize: const Size(double.infinity, 50),
            //       minimumSize: const Size(double.infinity, 50),
            //       backgroundColor: kColor,
            //       elevation: 10,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12))),
            //   onPressed: () {
            //     navigatePush(context, const Intro3());
            //   },
            //   child: Text("Next",
            //       style: GoogleFonts.montserrat(
            //         textStyle: const TextStyle(
            //             fontWeight: FontWeight.w600, fontSize: 16),
            //       )),
            // ),
            InkWell(
              onTap: () {
                navigatePush(
                    context,
                    Intro3(
                      list: widget.list,
                    ));
              },
              child: button(context, "Next", false),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.035),
            TextButton(
                onPressed: () {
                  navigatePush(
                      context,
                      Intro4(
                        list: widget.list,
                      ));
                },
                child: Text("Skip",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: kBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ))),
          ],
        ),
      ),
      /*body: CarouselSlider.builder(
          itemCount: slides.length,
          itemBuilder: (context, ind, realIndex) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    slides[index].image!,
                    width: MediaQuery.of(context).size.width * 0.75,
                    fit: BoxFit.contain,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      slides[index].name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.width * 0.03,
                      right: MediaQuery.of(context).size.width * 0.03,
                    ),
                    child: Text(
                      slides[index].description!,
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle,
                          size: 10,
                          color: index == 0 ? kColor : introIconColorLight),
                      Icon(Icons.circle,
                          size: 10,
                          color: index == 1 ? kColor : introIconColorLight),
                      Icon(Icons.circle,
                          size: 10,
                          color: index == 2 ? kColor : introIconColorLight),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  InkWell(
                    onTap: () {
                        if(index<slides.length-1){
                          setState(() {
                            index++;
                          });
                        }else{
                          navigateReplace(context, const LoginScreen());
                        }

                      //   next();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.06,
                          vertical: 20),
                      child: Text(
                          index == (slides.length - 1) ? "Get Started" : "Next"),
                    ),
                  ),
                  //SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      setState(() {
                        index=slides.length-1;
                      });
                    },
                    child: const Text("Skip"),
                  )
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
            autoPlay: false,
            enlargeCenterPage: true,
            initialPage: index,
            enableInfiniteScroll: false,
            onPageChanged: (ind , re){
              setState(() {
                index=ind;
              });
            },
            reverse: false,


          )),*/
    ));
  }
}
