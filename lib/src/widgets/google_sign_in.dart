import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class GoogleSignInButton extends StatefulWidget {
  final Function(String, String, String, String) onFinish;
  GoogleSignInButton({this.onFinish});

  @override
  GoogleSignInButtonState createState() => GoogleSignInButtonState();
}

class GoogleSignInButtonState extends State<GoogleSignInButton> {
  GoogleSignInAccount currentUser;

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (account != null) {
        if (mounted) {
          setState(() {
            currentUser = account;
          });
          var parts = account.displayName.split(" ");
          widget.onFinish(
              parts[0].trim(),
              parts.length > 1 ? parts[1].trim() : "",
              account.email,
              account.id);
          logOutGoogle();
        }
      }
    }).onError((e) => {print("Error $e")});
    //googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> logInGoogle() async {
    try {
      await googleSignIn.signIn().catchError((onError) {
        print("Error $onError");
      });
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<void> logOutGoogle() => googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: logInGoogle,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).buttonColor),
        child: Icon(
          LineIcons.googleLogo,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
