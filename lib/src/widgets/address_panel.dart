import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/src/notifier/AddressNotifier.dart';
import 'package:instamarket/src/models/Address.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/translations.dart';

class AddressPanel extends StatelessWidget {
  final String address;
  final bool isChecked;
  final bool isSelected;
  final Function() onDelete;

  AddressPanel(
      {this.address, this.isChecked, this.onDelete, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    List<Address> addresses = context.watch<AddressNotifier>().addresses ?? [];
    return Container(
      width: 0.9.sw,
      margin: EdgeInsets.only(left: 0.05.sw, right: 0.05.sw, bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).buttonColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 5,
                spreadRadius: 1,
                color: Theme.of(context).primaryColor.withOpacity(0.2))
          ]),
      child: Dismissible(
        key: Key(address),
        onDismissed: (direction) {
          int index =
              addresses.indexWhere((element) => element.address == address);
          if (index > -1)
            context.read<AddressNotifier>().deleteAddressByIndex(index);

          onDelete();
        },
        direction: DismissDirection.endToStart,
        background: Container(
          width: 0.2.sw,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color.fromRGBO(232, 14, 73, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            Translations.of(context).text('swipe_to_delete'),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).buttonColor,
                fontSize: 12.sp),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 0.6.sw,
              child: Text(
                address,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 12.sp),
              ),
            ),
            if (isChecked)
              Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  LineIcons.check,
                  color: Color.fromRGBO(33, 160, 54, 1),
                ),
              )
          ],
        ),
      ),
    );
  }
}
