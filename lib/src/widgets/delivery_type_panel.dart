import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeliveryTypePanel extends StatelessWidget {
  final String title;

  DeliveryTypePanel({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Theme.of(context).buttonColor, width: 0.5),
      ),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 6.sp,
            color: Theme.of(context).buttonColor,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
