import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BrandEffect extends StatelessWidget {
  final bool isMain;

  BrandEffect({this.isMain = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        width: isMain ? 160 : 0.5.sw - 25,
        height: isMain ? 160 : 180,
        margin: isMain
            ? EdgeInsets.only(right: 10)
            : EdgeInsets.symmetric(vertical: 5),
        decoration: isMain
            ? BoxDecoration()
            : BoxDecoration(
                boxShadow: <BoxShadow>[
                    BoxShadow(
                        offset: Offset(1, 1),
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 0)
                  ],
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).buttonColor),
      ),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
    );
  }
}
