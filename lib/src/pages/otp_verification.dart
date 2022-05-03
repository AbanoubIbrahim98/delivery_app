import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:instamarket/src/requests/registration.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AuthNotifier.dart';
import 'package:instamarket/src/models/User.dart';
import 'package:instamarket/translations.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class OtpVerification extends StatefulWidget {
  final String smsCode;
  final String name;
  final String surname;
  final String phoneNumber;
  final String password;

  OtpVerification(
      {this.smsCode, this.name, this.surname, this.phoneNumber, this.password});

  @override
  OtpVerificationState createState() => OtpVerificationState();
}

class OtpVerificationState extends State<OtpVerification> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  String confirmationCode = "";
  bool loading = false;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  void logIn(name, surname, image, phone, id) {
    context.read<AuthNotifier>().logIn(
        User(name: name, surname: surname, imageUrl: image, phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                        Translations.of(context).text('verification'),
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
                        Translations.of(context).text('enter_the_otp_code'),
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
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).buttonColor),
                          child: Form(
                            key: formKey,
                            child: Padding(
                                padding: EdgeInsets.symmetric(),
                                child: PinCodeTextField(
                                  appContext: context,
                                  pastedTextStyle: TextStyle(
                                    color: Color.fromRGBO(235, 237, 242, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]+')),
                                  ],
                                  length: 6,
                                  obscureText: false,
                                  obscuringCharacter: '*',
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 0.12.sw,
                                      fieldWidth: 0.12.sw,
                                      activeColor:
                                          Color.fromRGBO(235, 237, 242, 1),
                                      selectedColor:
                                          Color.fromRGBO(235, 237, 242, 1),
                                      inactiveColor:
                                          Color.fromRGBO(235, 237, 242, 1),
                                      selectedFillColor: Colors.white,
                                      inactiveFillColor:
                                          Color.fromRGBO(245, 247, 250, 1)),
                                  cursorColor: Colors.black,
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  textStyle:
                                      TextStyle(fontSize: 20, height: 1.6),
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  enableActiveFill: true,
                                  errorAnimationController: errorController,
                                  controller: textEditingController,
                                  keyboardType: TextInputType.number,
                                  onCompleted: (v) {},
                                  onChanged: (value) {
                                    this.setState(() {
                                      confirmationCode = value;
                                    });
                                  },
                                  beforeTextPaste: (text) {
                                    return true;
                                  },
                                )),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                Translations.of(context)
                                    .text('didnt_receive_code'),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12.sp),
                              ),
                              InkWell(
                                child: Text(
                                  Translations.of(context).text('resend'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 12.sp),
                                ),
                              )
                            ],
                          ),
                        ),
                        CustomButton(
                          title: Translations.of(context).text('submit'),
                          loading: loading,
                          onClick: () async {
                            try {
                              firebase_auth.PhoneAuthCredential credential =
                                  firebase_auth.PhoneAuthProvider.credential(
                                      verificationId: widget.smsCode,
                                      smsCode: confirmationCode);

                              auth
                                  .signInWithCredential(credential)
                                  .then((value) async {
                                setState(() {
                                  loading = true;
                                });
                                Map<String, dynamic> response =
                                    await registration(
                                        widget.name,
                                        widget.surname,
                                        "",
                                        widget.phoneNumber,
                                        widget.password,
                                        1,
                                        "",
                                        0);

                                logIn(widget.name, widget.surname, "",
                                    widget.phoneNumber, response['user']);

                                this.setState(() {
                                  loading = false;
                                });
                                Navigator.of(context)
                                    .pushReplacementNamed('/AuthSuccess');
                              }).catchError((e) {
                                print(e);
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(new SnackBar(
                                content: Text(
                                  Translations.of(context)
                                      .text('confirmation_code_is_not_correct'),
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ));
                            }
                          },
                        )
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
