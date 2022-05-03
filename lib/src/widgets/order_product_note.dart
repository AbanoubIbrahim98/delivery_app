import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/translations.dart';

class OrderProductNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromRGBO(232, 14, 73, 1).withOpacity(0.3)),
              ),
              Text(
                Translations.of(context).text('replaced_product'),
                style: TextStyle(
                    fontSize: 12.sp, color: Theme.of(context).primaryColor),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromRGBO(33, 160, 54, 1).withOpacity(0.3)),
              ),
              Text(
                Translations.of(context).text('replacement_product'),
                style: TextStyle(
                    fontSize: 12.sp, color: Theme.of(context).primaryColor),
              )
            ],
          )
        ],
      ),
    );
  }
}
