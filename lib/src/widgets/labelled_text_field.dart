import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabelledTextField extends StatefulWidget {
  final String title;
  final Function(String) onChange;
  final bool last;
  final String value;

  LabelledTextField({this.title, this.onChange, this.last = false, this.value});

  @override
  LabelledTextFieldState createState() => LabelledTextFieldState();
}

class LabelledTextFieldState extends State<LabelledTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: widget.value)
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: widget.value.length)),
      style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.5)),
      decoration: InputDecoration(
          border: widget.last
              ? InputBorder.none
              : UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.1))),
          enabledBorder: widget.last
              ? InputBorder.none
              : UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.1))),
          focusedBorder: widget.last
              ? InputBorder.none
              : UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.1))),
          labelText: widget.title,
          labelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700)),
    );
  }
}
