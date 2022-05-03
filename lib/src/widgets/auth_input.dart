import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final String hint;
  final Function(String) onChange;
  final IconData icon;
  final bool obscureText;
  final Function onClickIcon;
  final String initialValue;

  AuthInput(
      {this.hint,
      this.onChange,
      this.icon,
      this.obscureText = false,
      this.onClickIcon,
      this.initialValue = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: 1, color: Theme.of(context).primaryColor.withOpacity(0.1)),
          color: Theme.of(context).buttonColor),
      child: TextField(
        controller: TextEditingController(text: initialValue)
          ..selection = TextSelection.fromPosition(
              TextPosition(offset: initialValue.length)),
        onChanged: (text) => onChange(text),
        textAlignVertical: TextAlignVertical.center,
        obscureText: obscureText,
        style: TextStyle(color: Theme.of(context).primaryColor),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            hintStyle: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(0.5)),
            hintText: hint,
            suffixIcon: InkWell(
              onTap: onClickIcon,
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }
}
