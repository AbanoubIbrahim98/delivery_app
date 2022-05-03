import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProductEffect extends StatelessWidget {
  final bool isFixed;

  ProductEffect({this.isFixed = true});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
          width: isFixed ? 160 : 0.5.sw,
          padding: EdgeInsets.all(10),
          child: Stack(
            children: <Widget>[
              Container(
                  width: isFixed ? 160 : 0.5.sw - 20,
                  height: isFixed ? 70 : 150,
                  padding: isFixed
                      ? EdgeInsets.all(0)
                      : EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: isFixed
                        ? BorderRadius.circular(0)
                        : BorderRadius.circular(10),
                  )),
              Positioned(
                left: isFixed ? 0 : 10,
                right: isFixed ? 0 : 10,
                top: isFixed ? 70 : 160,
                child: Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.only(bottom: 8, left: 0, top: 5),
                  width: 100,
                  height: 20,
                  color: Theme.of(context).buttonColor,
                ),
              ),
              Positioned(
                  left: isFixed ? 0 : 10,
                  right: isFixed ? 0 : 10,
                  top: isFixed ? 100 : 180,
                  child: Container(
                    color: Theme.of(context).buttonColor,
                    width: 0.5.sw,
                    height: 30,
                  )),
              Positioned(
                  left: isFixed ? 0 : 10,
                  right: isFixed ? 0 : 10,
                  top: isFixed ? 120 : 190,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: 36,
                        height: 36,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).buttonColor,
                            border: Border.all(
                                color: Theme.of(context).buttonColor, width: 2),
                            borderRadius: BorderRadius.circular(18)),
                      )
                    ],
                  )),
            ],
          )),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
    );
  }
}
