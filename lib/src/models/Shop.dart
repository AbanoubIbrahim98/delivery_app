import 'package:instamarket/src/models/Product.dart';

class Shop {
  final int id;
  final String name;
  final String description;
  final String info;
  final String logoUrl;
  final String backImageUrl;
  final String address;
  final String openHour;
  final String closeHour;
  final double lat;
  final double lng;
  final int deliveryType;
  final double deliveryPrice;
  final double tax;
  bool active;
  List<Product> cartProducts = [];
  List<Product> likedProducts = [];
  int deliveryTimeId;
  int deliveryDayId;
  String deliveryDate;

  Shop(
      {this.id,
      this.name,
      this.description,
      this.info,
      this.logoUrl,
      this.backImageUrl,
      this.address,
      this.openHour,
      this.closeHour,
      this.lat,
      this.lng,
      this.deliveryType,
      this.deliveryPrice,
      this.tax,
      this.active,
      this.cartProducts,
      this.likedProducts,
      this.deliveryTimeId,
      this.deliveryDayId,
      this.deliveryDate});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "logoUrl": logoUrl,
      "backImageUrl": backImageUrl,
      "address": address,
      "openHour": openHour,
      "closeHour": closeHour,
      "lat": lat,
      "lng": lng,
      "deliveryType": deliveryType,
      "info": info,
      "deliveryPrice": deliveryPrice,
      "tax": tax,
      "active": active,
      "deliveryTimeId": deliveryTimeId,
      "deliveryDayId": deliveryDayId,
      "deliveryDate": deliveryDate,
      "cartProducts": cartProducts != null
          ? cartProducts.map((item) => item.toJson()).toList()
          : [],
      "likedProducts": likedProducts != null
          ? likedProducts.map((item) => item.toJson()).toList()
          : [],
    };
  }

  static Shop fromJson(dynamic json) {
    List cartProducts = json['cartProducts'];
    List likedProducts = json['likedProducts'];

    return Shop(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        logoUrl: json['logoUrl'],
        backImageUrl: json['backImageUrl'],
        address: json['address'],
        openHour: json['openHour'],
        closeHour: json['closeHour'],
        lat: json['lat'],
        lng: json['lng'],
        deliveryType: json['deliveryType'],
        info: json['info'],
        deliveryPrice: json['deliveryPrice'],
        tax: json['tax'],
        active: json['active'],
        deliveryTimeId: json['deliveryTimeId'],
        deliveryDayId: json['deliveryDayId'],
        deliveryDate: json['deliveryDate'],
        cartProducts: cartProducts != null && cartProducts.length > 0
            ? cartProducts.map((item) => Product.fromJson(item)).toList()
            : [],
        likedProducts: likedProducts != null && likedProducts.length > 0
            ? likedProducts.map((item) => Product.fromJson(item)).toList()
            : []);
  }
}
