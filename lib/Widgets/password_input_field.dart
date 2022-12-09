import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/colors.dart';

class PasswordInputField extends StatefulWidget {
  const PasswordInputField(
      {Key? key,
      required this.obscure,
      required this.controller,
      required this.value,})
      : super(key: key);

  final bool obscure;
  final TextEditingController controller;
  final String value;

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool? obscure;

  @override
  void initState() {
    // TODO: implement initState
    obscure = widget.obscure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 50, //MediaQuery.of(context).size.height*0.060,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: loginField,
      ),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscure!,
        cursorColor: kBrightYellow,
        decoration: InputDecoration(
            isDense: true,
            fillColor: loginField,
            focusColor: loginField,
            hintText: widget.value,
            hintStyle: GoogleFonts.montserrat(),
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  obscure = !obscure!;
                });
              },
              child: Icon(
                obscure!
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: kGrey,
              ),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            )),
      ),
    );
  }
}
