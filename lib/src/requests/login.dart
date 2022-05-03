import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instamarket/src/config/global_config.dart';

Future<Map<String, dynamic>> login(
    String phone, String password, int authType, String socialId) async {
  String url = "$GLOBAL_API_URL/users/login";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  Map<String, String> body = {
    "phone": phone,
    "auth_type": authType.toString(),
    "password": password,
    "social_id": socialId
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
