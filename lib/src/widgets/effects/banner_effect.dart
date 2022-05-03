import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BannerEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        width: 1.sw,
        height: 180,
        margin: EdgeInsets.only(top: 10),
        color: Theme.of(context).buttonColor,
      ),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
    );
  }
}
