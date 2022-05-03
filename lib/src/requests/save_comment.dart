import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instamarket/src/config/global_config.dart';

Future<Map<String, dynamic>> saveCommentRequest(
    int productId, int userId, double star, String comment) async {
  String url = "$GLOBAL_API_URL/products/saveComments";
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> body = {
    "id_product": productId.toString(),
    "id_user": userId.toString(),
    "star": star.toString(),
    "comment": comment
  };

  print(body);

  final client = new http.Client();
  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  print(response.body);

  Map<String, dynamic> responseJson = {};

  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
