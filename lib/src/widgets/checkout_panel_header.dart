import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutPanelHeader extends StatelessWidget {
  final String title;

  CheckoutPanelHeader({this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w800),
    );
  }
}
