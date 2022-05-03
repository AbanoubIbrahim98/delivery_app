import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Function onClick;
  final bool isFilled;
  final Color color;

  RoundedButton({this.title, this.isFilled, this.onClick, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 0.5.sw - 30,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                isFilled ? color : Theme.of(context).buttonColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  side: BorderSide(
                      color: color, width: 1, style: BorderStyle.solid),
                  borderRadius: new BorderRadius.circular(30.0)),
            )),
        onPressed: onClick,
        child: Text(
          title,
          style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isFilled ? Theme.of(context).buttonColor : color),
        ),
      ),
    );
  }
}
