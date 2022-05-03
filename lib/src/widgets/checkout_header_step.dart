import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckOutStep extends StatelessWidget {
  final String title;
  final int status;
  final int position;

  CheckOutStep({this.title, this.status, this.position});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.3.sw - 20,
      child: Column(
        crossAxisAlignment: position == 1
            ? CrossAxisAlignment.start
            : (position == 2
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.end),
        children: <Widget>[
          Container(
            height: 20,
            width: 20,
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(10)),
            child: Container(
              decoration: BoxDecoration(
                  color: status == 1
                      ? Color.fromRGBO(33, 160, 54, 1)
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}
