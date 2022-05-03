import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailItem extends StatelessWidget {
  final String title;
  final String data;

  ProductDetailItem({this.title, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5.sw - 40,
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).primaryColor.withOpacity(0.1)),
      child: Row(
        children: <Widget>[
          Text(
            "$title:",
            style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                fontWeight: FontWeight.w400),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              data,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
