import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopInfoPanel extends StatelessWidget {
  final String title;
  final String info;

  ShopInfoPanel({this.title, this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            info,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}
