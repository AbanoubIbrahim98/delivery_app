import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class AppleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Theme.of(context).buttonColor),
      child: Icon(
        LineIcons.apple,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
