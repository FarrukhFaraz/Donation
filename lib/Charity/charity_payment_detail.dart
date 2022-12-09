import 'package:flutter/material.dart';

import 'Model/charity_payment_history.dart';


class CharityPaymentDetail extends StatefulWidget {
   CharityPaymentDetail({Key? key ,required this.modelList}) : super(key: key);

  List<CharityPaymentModel> modelList;

  @override
  State<CharityPaymentDetail> createState() => _CharityPaymentDetailState();
}

class _CharityPaymentDetailState extends State<CharityPaymentDetail> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
