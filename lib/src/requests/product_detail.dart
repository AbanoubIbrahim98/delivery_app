import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instamarket/src/config/global_config.dart';

Future<Map<String, dynamic>> productDetailRequest(int productId) async {
  String url = "$GLOBAL_API_URL/products/product";
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  print(productId);

  Map<String, String> body = {
    "id": productId.toString(),
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
