import 'package:http/http.dart' as http;
import 'package:instamarket/src/config/global_config.dart';

Future<String> languageRequestByCode(String langCode) async {
  String url = "$GLOBAL_API_URL/language/language";
  final response =
      await http.post(Uri.parse(url), body: {"lang_code": langCode});
  String responseJson = "";

  try {
    if (response.statusCode == 200) {
      responseJson = response.body;
    }
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
