import 'package:flutter/material.dart';

class TextReciept extends StatefulWidget {
  const TextReciept({Key? key}) : super(key: key);

  @override
  State<TextReciept> createState() => _TextRecieptState();
}

class _TextRecieptState extends State<TextReciept> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(child: Text("No tax reciept found"),),
    ));
  }
}
