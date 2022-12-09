import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/colors.dart';

class HomeNearByItemWidget extends StatefulWidget {
  const HomeNearByItemWidget({Key? key}) : super(key: key);

  @override
  State<HomeNearByItemWidget> createState() => _HomeNearByItemWidgetState();
}

class _HomeNearByItemWidgetState extends State<HomeNearByItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.06),
      height: MediaQuery.of(context).size.height * 0.120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return itemListWidget();
        },
      ),
    );
  }

  Widget itemListWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(12),
          ),
          margin:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.04),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Opacity(
              alwaysIncludeSemantics: true,
              opacity: 0.4,
              child: Image.asset(
                "assets/icons/check.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text("Education",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: kWhite),
            )),
      ],
    );
  }
}
