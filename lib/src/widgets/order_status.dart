import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/translations.dart';

class OrderStatus extends StatelessWidget {
  final int status;

  OrderStatus({this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: Stack(
        children: <Widget>[
          Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  height: 37,
                  width: 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: status > 1
                          ? Color.fromRGBO(33, 160, 54, 1)
                          : Theme.of(context).primaryColor.withOpacity(0.1)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  height: 37,
                  width: 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: status > 2
                          ? Color.fromRGBO(33, 160, 54, 1)
                          : Theme.of(context).primaryColor.withOpacity(0.1)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  height: 37,
                  width: 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: status > 3
                          ? Color.fromRGBO(33, 160, 54, 1)
                          : Theme.of(context).primaryColor.withOpacity(0.1)),
                )
              ],
            ),
          ),
          Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 16,
                      height: 16,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: status > 0
                                ? Color.fromRGBO(33, 160, 54, 1)
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3)),
                      ),
                    ),
                    Text(
                      Translations.of(context).text('order_accepted'),
                      style: TextStyle(
                          color: status > 0
                              ? Color.fromRGBO(33, 160, 54, 1)
                              : Theme.of(context).primaryColor.withOpacity(0.3),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 16,
                      height: 16,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: status > 1
                                ? Color.fromRGBO(33, 160, 54, 1)
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3)),
                      ),
                    ),
                    Text(
                      Translations.of(context).text('order_processing'),
                      style: TextStyle(
                          color: status > 1
                              ? Color.fromRGBO(33, 160, 54, 1)
                              : Theme.of(context).primaryColor.withOpacity(0.3),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 16,
                      height: 16,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: status > 2
                                ? Color.fromRGBO(33, 160, 54, 1)
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3)),
                      ),
                    ),
                    Text(
                      Translations.of(context).text('out_for_delivery'),
                      style: TextStyle(
                          color: status > 2
                              ? Color.fromRGBO(33, 160, 54, 1)
                              : Theme.of(context).primaryColor.withOpacity(0.3),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 16,
                      height: 16,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: status > 3
                                ? Color.fromRGBO(33, 160, 54, 1)
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3)),
                      ),
                    ),
                    Text(
                      Translations.of(context).text('delivered_to_customer'),
                      style: TextStyle(
                          color: status > 3
                              ? Color.fromRGBO(33, 160, 54, 1)
                              : Theme.of(context).primaryColor.withOpacity(0.3),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
