import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instamarket/src/config/global_config.dart';

Future<Map<String, dynamic>> registration(
    String name,
    String surname,
    String email,
    String phone,
    String password,
    int authType,
    String socialId,
    int id) async {
  String url = "$GLOBAL_API_URL/users/save";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  Map<String, String> body = {
    "name": name,
    "surname": surname,
    "email": email,
    "phone": phone,
    "auth_type": authType.toString(),
    "password": password,
    "social_id": socialId,
    "id": id.toString()
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
