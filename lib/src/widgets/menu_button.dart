import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuButton extends StatelessWidget {
  final String title;
  final IconData leftIcon;
  final Function onTap;
  final bool rightIcon;

  MenuButton({this.title, this.leftIcon, this.onTap, this.rightIcon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 0.6.sw,
        child: Row(children: <Widget>[
          Icon(
            leftIcon,
            size: 20.sp,
            color: Theme.of(context).buttonColor,
          ),
          Container(
              width: 0.5.sw,
              margin: EdgeInsets.only(left: 10),
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 0.5.sw - 30,
                    child: Text(title,
                        maxLines: 3,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).buttonColor,
                            fontSize: 16.sp)),
                  ),
                  if (rightIcon)
                    Icon(Icons.keyboard_arrow_right,
                        size: 16.sp, color: Theme.of(context).buttonColor)
                ],
              )),
        ]),
      ),
    );
  }
}
