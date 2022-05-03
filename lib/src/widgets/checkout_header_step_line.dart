import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutHeaderStepLine extends StatelessWidget {
  final int status;

  CheckoutHeaderStepLine({this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5.sw - 30,
      height: 4,
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          color: status == 1
              ? Color.fromRGBO(33, 160, 54, 1)
              : Theme.of(context).primaryColor.withOpacity(0.1)),
    );
  }
}
