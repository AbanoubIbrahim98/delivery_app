import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:instamarket/src/widgets/google_sign_in.dart';
import 'package:instamarket/src/widgets/facebook_sign_in.dart';
import 'package:instamarket/src/widgets/apple_sign_in.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:instamarket/src/widgets/auth_input.dart';
import 'package:instamarket/src/requests/login.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AuthNotifier.dart';
import 'package:instamarket/src/models/User.dart';
import 'package:instamarket/translations.dart';
import 'package:instamarket/src/notifier/AddressNotifier.dart';
import 'package:instamarket/src/models/Address.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  String phoneNumber = "";
  String password = "";
  bool obscurePassword = true;
  bool loading = false;

  void logInUser(id, name, surname, image, phone) {
    context.read<AuthNotifier>().logIn(User(
        id: id, name: name, surname: surname, imageUrl: image, phone: phone));
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
                height: 0.2.sh,
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
              Container(
                height: 0.3.sh,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                        selectorTextStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        textStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        initialValue: number,
                        textFieldController: controller,
                        formatInput: true,
                        cursorColor: Theme.of(context).primaryColor,
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
                      icon:
                          obscurePassword ? LineIcons.eyeSlash : LineIcons.eye,
                      obscureText: obscurePassword,
                      onClickIcon: () {
                        this.setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/ForgotPassword');
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerRight,
                        child: Text(
                          Translations.of(context).text('forgot_password'),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              fontSize: 14.sp),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 0.3.sh,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CustomButton(
                      title: Translations.of(context).text('signin'),
                      loading: loading,
                      onClick: () async {
                        this.setState(() {
                          loading = true;
                        });

                        Map<String, dynamic> response =
                            await login(phoneNumber, password, 1, "");

                        if (response['success']) {
                          this.setState(() {
                            loading = false;
                          });

                          var user = response['user'];

                          logInUser(user['id'], user['name'], user['surname'],
                              user['image_url'], user['phone']);

                          List<Address> addresses =
                              Provider.of<AddressNotifier>(context,
                                      listen: false)
                                  .addresses;

                          Navigator.of(context).pushReplacementNamed('/Shops',
                              arguments: {addresses: addresses});
                        } else {
                          snackBar(Translations.of(context)
                              .text('not_found_account'));
                          this.setState(() {
                            loading = false;
                          });
                        }
                      },
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                            Translations.of(context).text('or_sign_in_with'),
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
                              onFinish: (name, surname, email, socialId) async {
                                this.setState(() {
                                  loading = true;
                                });

                                Map<String, dynamic> response =
                                    await login("", "", 2, socialId);

                                if (response['success']) {
                                  this.setState(() {
                                    loading = false;
                                  });

                                  var user = response['user'];

                                  logInUser(
                                      user['id'],
                                      user['name'],
                                      user['surname'],
                                      user['image_url'],
                                      user['phone']);

                                  List<Address> addresses =
                                      Provider.of<AddressNotifier>(context,
                                              listen: false)
                                          .addresses;

                                  Navigator.of(context).pushReplacementNamed(
                                      '/Shops',
                                      arguments: {addresses: addresses});
                                } else {
                                  snackBar("Not found account");
                                  this.setState(() {
                                    loading = false;
                                  });
                                }
                              },
                            ),
                            FacebookSignInButton(
                              onFinish: (name, surname, email, socialId) async {
                                if (mounted)
                                  this.setState(() {
                                    loading = true;
                                  });

                                Map<String, dynamic> response =
                                    await login("", "", 3, socialId);

                                if (response['success']) {
                                  this.setState(() {
                                    loading = false;
                                  });

                                  var user = response['user'];

                                  logInUser(
                                      user['id'],
                                      user['name'],
                                      user['surname'],
                                      user['image_url'],
                                      user['phone']);

                                  List<Address> addresses =
                                      Provider.of<AddressNotifier>(context,
                                              listen: false)
                                          .addresses;

                                  Navigator.of(context).pushReplacementNamed(
                                      '/Shops',
                                      arguments: {addresses: addresses});
                                } else {
                                  snackBar(Translations.of(context)
                                      .text('not_found_account'));
                                  this.setState(() {
                                    loading = false;
                                  });
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
                        Translations.of(context).text('you_dont_have_account'),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: Theme.of(context).primaryColor),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/Registration');
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.all(0)),
                          ),
                          child: Text(
                            Translations.of(context).text('signup'),
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
      ),
    );
  }
}
