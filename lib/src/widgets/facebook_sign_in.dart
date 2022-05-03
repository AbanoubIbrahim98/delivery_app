import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:line_icons/line_icons.dart';

class FacebookSignInButton extends StatefulWidget {
  final Function(String, String, String, String) onFinish;
  FacebookSignInButton({this.onFinish});
  @override
  FacebookSignInButtonState createState() => FacebookSignInButtonState();
}

class FacebookSignInButtonState extends State<FacebookSignInButton> {
  Future<Null> logInFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken;
      final graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}'));

      final profile = json.decode(graphResponse.body);
      widget.onFinish(
        profile['first_name'],
        profile['last_name'],
        profile['email'],
        profile['id'],
      );
      logOutFacebook();
    }
  }

  Future<Null> logOutFacebook() async {
    await FacebookAuth.instance.logOut();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).buttonColor),
        child: Icon(
          LineIcons.facebook,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onTap: logInFacebook,
    );
  }
}
