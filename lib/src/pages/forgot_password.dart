import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/translations.dart';

class ForgotPassword extends StatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 40),
                height: 0.1.sh,
                alignment: Alignment.bottomLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    LineIcons.arrowLeft,
                    color: Theme.of(context).primaryColor,
                    size: 28.sp,
                  ),
                ),
              ),
              Container(
                height: 0.5.sh,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 40, bottom: 20),
                      child: Text(
                        Translations.of(context).text('forgot_password'),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.sp),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Text(
                        Translations.of(context)
                            .text('enter_your_phone_to_recovery'),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)),
                              color: Theme.of(context).buttonColor),
                          child: TextField(
                            onChanged: (text) {},
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5)),
                                hintText:
                                    Translations.of(context).text('phone'),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          width: 0.8.sw,
                          child: TextButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(vertical: 12)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(33, 160, 54, 1)),
                              ),
                              onPressed: () {},
                              child: Text(
                                Translations.of(context).text('next'),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Theme.of(context).buttonColor),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
