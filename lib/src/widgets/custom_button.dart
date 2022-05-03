import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onClick;
  final bool loading;
  final bool isRounded;

  CustomButton(
      {this.title, this.onClick, this.loading = false, this.isRounded = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.8.sw,
      height: 45,
      child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 12)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                        new BorderRadius.circular(isRounded ? 10.0 : 0))),
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(33, 160, 54, 1)),
          ),
          onPressed: onClick,
          child: loading
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).buttonColor),
                  ),
                )
              : Text(
                  title,
                  style: TextStyle(
                      fontSize: 14.sp, color: Theme.of(context).buttonColor),
                )),
    );
  }
}
