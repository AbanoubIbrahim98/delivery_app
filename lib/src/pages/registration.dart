import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/src/requests/sms.dart';
import 'package:instamarket/src/widgets/google_sign_in.dart';
import 'package:instamarket/src/widgets/facebook_sign_in.dart';
import 'package:instamarket/src/widgets/apple_sign_in.dart';
import 'package:instamarket/src/widgets/auth_input.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:instamarket/src/requests/registration.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AuthNotifier.dart';
import 'package:instamarket/src/models/User.dart';
import 'package:instamarket/translations.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class Registration extends StatefulWidget {
  @override
  RegistrationState createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  String phoneNumber = "";
  String name = "";
  String surname = "";
  String password = "";
  bool obscurePassword = true;
  bool loading = false;

  Future<bool> sendSms(String phoneNumber, String smsCode) async {
    final Map<String, dynamic> response =
        await sendSmsRequest(phoneNumber, smsCode);

    if (response.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(text) {
    return ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      backgroundColor: Color.fromRGBO(232, 14, 73, 1),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 12.sp, color: Theme.of(context).primaryColor),
      ),
    ));
  }

  void logIn(name, surname, image, phone, id) {
    context.read<AuthNotifier>().logIn(User(
        name: name, surname: surname, imageUrl: image, phone: phone, id: id));
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        Translations.of(context).text('create_new_account'),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.sp),
                      ),
                      Column(
                        children: <Widget>[
                          AuthInput(
                            hint: Translations.of(context).text('name'),
                            initialValue: name,
                            onChange: (text) {
                              this.setState(() {
                                name = text;
                              });
                            },
                          ),
                          AuthInput(
                            hint: Translations.of(context).text('surname'),
                            initialValue: surname,
                            onChange: (text) {
                              this.setState(() {
                                surname = text;
                              });
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1)),
                                color: Theme.of(context).buttonColor),
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                this.setState(() {
                                  phoneNumber = number.phoneNumber;
                                });
                              },
                              onInputValidated: (bool value) {},
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.DIALOG,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              textStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              initialValue: number,
                              textFieldController: controller,
                              formatInput: true,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              inputBorder: InputBorder.none,
                              onSaved: (PhoneNumber number) {},
                            ),
                          ),
                          AuthInput(
                            hint: Translations.of(context).text('password'),
                            initialValue: password,
                            onChange: (text) {
                              this.setState(() {
                                password = text;
                              });
                            },
                            icon: obscurePassword
                                ? LineIcons.eyeSlash
                                : LineIcons.eye,
                            obscureText: obscurePassword,
                            onClickIcon: () {
                              this.setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: 0.3.sh,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CustomButton(
                        title: Translations.of(context).text('signup'),
                        loading: loading,
                        onClick: () async {
                          if (name.length <= 0) {
                            snackBar(
                                Translations.of(context).text('enter_name'));
                            return false;
                          }

                          if (surname.length <= 0) {
                            snackBar(
                                Translations.of(context).text('enter_surname'));
                            return false;
                          }

                          if (phoneNumber.length <= 6) {
                            snackBar(Translations.of(context)
                                .text('enter_valid_phone_number'));
                            return false;
                          }

                          if (password.length < 8) {
                            snackBar(Translations.of(context)
                                .text('password_length'));
                            return false;
                          }

                          this.setState(() {
                            loading = true;
                          });
                          //String smsCode = generateSmsCode();
                          await firebase_auth.FirebaseAuth.instance
                              .verifyPhoneNumber(
                            phoneNumber: phoneNumber,
                            verificationCompleted:
                                (firebase_auth.PhoneAuthCredential credential) {
                              print(credential);
                              // this.setState(() {
                              //   loading = false;
                              // });

                              // Navigator.of(context)
                              //     .pushNamed('/OtpVerification', arguments: {
                              //   "smsCode": credential.smsCode,
                              //   "phone": phoneNumber,
                              //   "name": name,
                              //   "surname": surname,
                              //   "password": password
                              // });
                            },
                            verificationFailed:
                                (firebase_auth.FirebaseAuthException e) {},
                            codeSent: (String verificationId, int resendToken) {
                              this.setState(() {
                                loading = false;
                              });

                              Navigator.of(context)
                                  .pushNamed('/OtpVerification', arguments: {
                                "smsCode": verificationId,
                                "phone": phoneNumber,
                                "name": name,
                                "surname": surname,
                                "password": password
                              });
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                          // bool isSmsSent =
                          //     await sendSms(this.phoneNumber, smsCode);
                          // if (isSmsSent) {
                          //   this.setState(() {
                          //     loading = false;
                          //   });

                          //   Navigator.of(context)
                          //       .pushNamed('/OtpVerification', arguments: {
                          //     "smsCode": smsCode,
                          //     "phone": phoneNumber,
                          //     "name": name,
                          //     "surname": surname,
                          //     "password": password
                          //   });
                          // }
                        },
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Text(
                              Translations.of(context).text('or_sign_up_with'),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GoogleSignInButton(
                                onFinish:
                                    (name, surname, email, socialId) async {
                                  this.setState(() {
                                    loading = true;
                                  });

                                  Map<String, dynamic> response =
                                      await registration(name, surname, email,
                                          "", "", 2, socialId, 0);

                                  if (response['success']) {
                                    this.setState(() {
                                      loading = false;
                                    });

                                    logIn(name, surname, "", "",
                                        response['user']);

                                    Navigator.of(context)
                                        .pushReplacementNamed('/AuthSuccess');
                                  }
                                },
                              ),
                              FacebookSignInButton(
                                onFinish:
                                    (name, surname, email, socialId) async {
                                  this.setState(() {
                                    loading = true;
                                  });

                                  Map<String, dynamic> response =
                                      await registration(name, surname, email,
                                          "", "", 3, socialId, 0);

                                  if (response['success']) {
                                    this.setState(() {
                                      loading = false;
                                    });

                                    logIn(name, surname, "", "",
                                        response['user']);

                                    Navigator.of(context)
                                        .pushReplacementNamed('/AuthSuccess');
                                  }
                                },
                              ),
                              if (Platform.isIOS) AppleSignInButton()
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    height: 0.1.sh,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${Translations.of(context).text('you_already_have_account')} ?",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: Theme.of(context).primaryColor),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/Login');
                            },
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.all(0)),
                            ),
                            child: Text(
                              Translations.of(context).text('signin'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  color: Color.fromRGBO(33, 160, 54, 1)),
                            ))
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
