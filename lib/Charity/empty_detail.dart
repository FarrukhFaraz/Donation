import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CharityEmptyDetail extends StatefulWidget {
  const CharityEmptyDetail({Key? key}) : super(key: key);

  @override
  State<CharityEmptyDetail> createState() => _CharityEmptyDetailState();
}

class _CharityEmptyDetailState extends State<CharityEmptyDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(
        child: Text("This charity has been removed",style: GoogleFonts.montserrat(),),
      ),
    ));
  }
}
