import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:instamarket/src/widgets/effects/product_effect.dart';

class CategoryBlockEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: 1.sw,
      decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(1, 1),
            )
          ]),
      child: Shimmer.fromColors(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 7),
              width: 1.sw - 20,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.2)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 0.5.sw,
                    height: 30,
                    color: Theme.of(context).buttonColor,
                  ),
                  Container(
                    width: 100,
                    height: 30,
                    color: Theme.of(context).buttonColor,
                  )
                ],
              ),
            ),
            Container(
              height: 250,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext ctx, int index) {
                  return ProductEffect();
                },
              ),
            )
          ],
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
      ),
    );
  }
}
