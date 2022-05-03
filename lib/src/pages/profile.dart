import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:instamarket/src/widgets/auth_input.dart';
import 'package:instamarket/src/models/User.dart';
import 'package:instamarket/src/requests/registration.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AuthNotifier.dart';
import 'package:instamarket/translations.dart';

class Profile extends StatefulWidget {
  final User user;

  Profile({this.user});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  String phoneNumber = "";
  String name = "";
  String surname = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      name = widget.user.name;
      surname = widget.user.surname;
      phoneNumber = widget.user.phone;
    });
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(text) {
    return ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      backgroundColor: Color.fromRGBO(33, 160, 54, 1),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 12.sp, color: Theme.of(context).primaryColor),
      ),
    ));
  }

  void logIn(name, surname, image, phone, id) {
    context.read<AuthNotifier>().logIn(
        User(name: name, surname: surname, imageUrl: image, phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).buttonColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).buttonColor,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        elevation: 0,
        title: Text(
          Translations.of(context).text('profile'),
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
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
                      color: Theme.of(context).primaryColor.withOpacity(0.1)),
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
                textStyle: TextStyle(color: Theme.of(context).primaryColor),
                initialValue: number,
                textFieldController: controller,
                formatInput: true,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: InputBorder.none,
                onSaved: (PhoneNumber number) {},
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: CustomButton(
            title: Translations.of(context).text('apply'),
            loading: loading,
            onClick: () async {
              this.setState(() {
                loading = true;
              });
              Map<String, dynamic> response = await registration(
                  name, surname, "", phoneNumber, "", 1, "", 0);

              if (response['success']) {
                logIn(name, surname, "", phoneNumber, response['user']);

                this.setState(() {
                  loading = false;
                });
                snackBar(Translations.of(context).text('successfully_saved'));
              }
            }),
      ),
    );
  }
}
