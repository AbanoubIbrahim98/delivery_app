import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> locationWithoutPermission() async {
  Map<String, dynamic> responseJson = {};

  try {
    await http.get(Uri.parse('http://ip-api.com/json')).then((value) {
      print(json.decode(value.body).toString());
    });
  } catch (err) {
    print(err);
  }

  return responseJson;
}
