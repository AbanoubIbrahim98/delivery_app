import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShopEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 0.9.sw,
        height: 150,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 0.05.sw,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).buttonColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(1, 1),
              )
            ]),
        child: Shimmer.fromColors(
          child: Row(children: <Widget>[
            Container(
              width: 0.2.sw,
              height: 0.2.sw,
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(0.1.sw),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              height: 120,
              width: (0.7.sw - 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    width: (0.7.sw - 60),
                    height: 40,
                    color: Theme.of(context).buttonColor,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2, bottom: 2, left: 5),
                    width: (0.7.sw - 60),
                    height: 30,
                    color: Theme.of(context).buttonColor,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2, bottom: 2, left: 5),
                    width: (0.7.sw - 60),
                    height: 30,
                    color: Theme.of(context).buttonColor,
                  ),
                ],
              ),
            ),
          ]),
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
        ));
  }
}
