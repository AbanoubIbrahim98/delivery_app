import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpCheckbox extends StatefulWidget {
  final bool isChecked;
  final Function onChange;

  SpCheckbox({this.isChecked, this.onChange});
  @override
  SpCheckboxState createState() => SpCheckboxState();
}

class SpCheckboxState extends State<SpCheckbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChange();
      },
      child: Container(
        width: 40,
        height: 20,
        decoration: BoxDecoration(
            color: widget.isChecked
                ? Color.fromRGBO(33, 160, 54, 1).withOpacity(0.5)
                : Color.fromRGBO(210, 210, 210, 0.1),
            border: Border.all(width: 1, color: Color.fromRGBO(33, 160, 54, 1)),
            borderRadius: BorderRadius.circular(30)),
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
                left: widget.isChecked ? 20 : 1,
                top: 1,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 5,
                            color: Color.fromRGBO(33, 160, 54, 0.1),
                            offset: Offset(1, 1))
                      ],
                      color: Color.fromRGBO(33, 160, 54, 1),
                      borderRadius: BorderRadius.circular(27)),
                ),
                duration: Duration(milliseconds: 10))
          ],
        ),
      ),
    );
  }
}
