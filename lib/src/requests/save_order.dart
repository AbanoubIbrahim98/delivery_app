import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instamarket/src/config/global_config.dart';

Future<Map<String, dynamic>> saveOrderRequest(
    int userId,
    String name,
    String phone,
    String address,
    double longitude,
    double latitude,
    int shopId,
    double tax,
    double deliveryFee,
    double totalSum,
    double totaDiscount,
    String deliveryDate,
    String comment,
    int type,
    List<Map<String, dynamic>> detail,
    int paymentStatus,
    int paymentMethod) async {
  String url = "$GLOBAL_API_URL/orders/saveOrder";
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> body = {
    "id_user": userId.toString(),
    "name": name,
    "phone": phone,
    "address": address,
    "longitude": longitude.toString(),
    "latitude": latitude.toString(),
    "id_shop": shopId.toString(),
    "tax": tax.toString(),
    "delivery_fee": deliveryFee.toString(),
    "total_sum": totalSum.toString(),
    "total_discount": totaDiscount.toString(),
    "delivery_date": deliveryDate,
    "comment": comment,
    "type": type.toString(),
    "detail": json.encode(detail),
    "payment_status": paymentStatus.toString(),
    "payment_method": paymentMethod.toString()
  };

  final client = new http.Client();
  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  Map<String, dynamic> responseJson = {};

  print(response.body);

  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
