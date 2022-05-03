import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoryEffectEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: 0.3.sw,
      height: 150,
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(1, 1),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).buttonColor),
      child: Shimmer.fromColors(
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              width: 0.3.sw,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).buttonColor),
            ),
            Container(
              margin: EdgeInsets.all(5),
              width: 100,
              height: 20,
              color: Theme.of(context).buttonColor,
            )
          ],
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
      ),
    );
  }
}
