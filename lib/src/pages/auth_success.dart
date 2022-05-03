import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:instamarket/translations.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AddressNotifier.dart';
import 'package:instamarket/src/models/Address.dart';

class AuthSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          height: 1.sh,
          width: 1.sw,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                LineIcons.checkCircle,
                color: Color.fromRGBO(33, 160, 54, 1),
                size: 120.sp,
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 0.05.sh),
                child: Text(
                  Translations.of(context).text('successfully_registered'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              CustomButton(
                title: Translations.of(context).text('start_shopping'),
                onClick: () async {
                  List<Address> addresses =
                      Provider.of<AddressNotifier>(context, listen: false)
                          .addresses;
                  Navigator.of(context).pushReplacementNamed('/Shops',
                      arguments: {addresses: addresses});
                },
              ),
            ],
          ),
        ));
  }
}
