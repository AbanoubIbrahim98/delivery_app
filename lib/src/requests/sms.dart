import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instamarket/src/config/sms_config.dart';
import 'package:instamarket/src/config/global_config.dart';

Future<Map<String, dynamic>> sendSmsRequest(
    String phoneNumber, String smsCode) async {
  String url = "$SMS_URL";
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> body = {
    "from": "$APP_NAME",
    "text": "Your activation code is $smsCode",
    "to": phoneNumber,
    "api_key": "$SMS_API_KEY",
    "api_secret": "$SMS_API_SECRET"
  };

  final client = new http.Client();
  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  Map<String, dynamic> responseJson = {};

  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
