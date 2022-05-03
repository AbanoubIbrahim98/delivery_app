import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SortByItem extends StatelessWidget {
  final bool checked;
  final String title;
  final int id;
  final Function(int) onClick;

  SortByItem({this.checked, this.id, this.title, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        child: CheckboxListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          title: Text(
            title,
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 12.sp),
          ),
          value: checked,
          checkColor: Theme.of(context).buttonColor,
          activeColor: Color.fromRGBO(232, 14, 73, 1),
          onChanged: (newValue) {
            onClick(id);
          },
          controlAffinity: ListTileControlAffinity.leading,
        ));
  }
}
