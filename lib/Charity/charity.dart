import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/colors.dart';
import 'Model/all_charity_model.dart';

class Charity2 extends StatefulWidget {
  const Charity2({super.key, required this.model});

  final AllCharityModel model;

  @override
  State<Charity2> createState() => _Charity2State();
}

class _Charity2State extends State<Charity2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 12),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: FadeInImage(
                            placeholder: const AssetImage(
                                "assets/images/placeholder.png"),
                            image: NetworkImage(widget.model.image!),
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          )
                          //Image.asset(
                          //   "assets/icons/check3.png",
                          //   width: MediaQuery.of(context).size.width,
                          //   fit: BoxFit.cover,
                          // ),
                          ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.01,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03),
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
                            // const CircleAvatar(
                            //   radius: 18,
                            //   backgroundImage: AssetImage("assets/images/Icon.png"),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(widget.model.title!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: kBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                            const Icon(
                              Icons.share_outlined,
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: kColor,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                widget.model.location!,
                                // "600 N US Highway 17 92, Longwood, FL 32750",
                                maxLines: 2,
                                style: GoogleFonts.montserrat(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: kColor,
                              size: 18,
                            ),
                            Text(
                              "  Phone:  ",
                              maxLines: 1,
                              style: GoogleFonts.montserrat(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(widget.model.phone!,
                                //" (407) 260-9155",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(color: kColor),
                                )),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.mail_rounded,
                              color: kColor,
                              size: 18,
                            ),
                            Expanded(
                              child: Text(
                                widget.model.email!,
                                maxLines: 2,
                                style: GoogleFonts.montserrat(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Image.asset("assets/icons/ccc.png"),
                        const SizedBox(height: 20),
                        Text("Category",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: kBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )),
                        const SizedBox(height: 6),
                        Text(
                          widget.model.cateDesc!,
                          maxLines: 2,
                          style: GoogleFonts.montserrat(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        Text("About",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: kBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )),
                        const SizedBox(height: 6),
                        Text(
                          widget.model.about!,
                          maxLines: 7,
                          style: GoogleFonts.montserrat(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        Text("Year Founded",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: kBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )),
                        const SizedBox(height: 6),
                        Text(widget.model.founded!,
                            style: GoogleFonts.montserrat()),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
