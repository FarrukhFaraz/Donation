import 'package:flutter/material.dart';

navigatePush(BuildContext context, var home) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => home));
}

navigateReplace(BuildContext context, var home) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => home));
}
