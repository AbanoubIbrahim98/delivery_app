import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashOutlinedButton extends StatelessWidget {
  final String name;
  final Function onPress;

  SplashOutlinedButton({this.name, this.onPress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.4.sw,
      height: 45,
      child: OutlinedButton(
        onPressed: onPress,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  side: BorderSide(
                      color: Theme.of(context).buttonColor, width: 1.5),
                  borderRadius: new BorderRadius.circular(10.0))),
        ),
        child: Text(
          name,
          style: TextStyle(
              color: Theme.of(context).buttonColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
