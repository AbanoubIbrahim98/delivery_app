import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:instamarket/src/config/global_config.dart';

Future<List> languageRequest() async {
  String url = "$GLOBAL_API_URL/language/activeLangs";
  final response = await http.post(Uri.parse(url));
  List responseJson = [];

  try {
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      responseJson = body['data'];
    }
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
