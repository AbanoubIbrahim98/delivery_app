import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/translations.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        width: 1.sw,
        height: 1.sh,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 0.2.sh,
              margin: EdgeInsets.only(bottom: 40),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Gmarket",
                    style: TextStyle(
                        color: Color.fromRGBO(33, 160, 54, 1),
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    Translations.of(context).text('world_of_shops'),
                    style: TextStyle(
                        color: Color.fromRGBO(33, 160, 54, 1),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(33, 160, 54, 1)),
            ),
          ],
        ),
      ),
    );
  }
}
