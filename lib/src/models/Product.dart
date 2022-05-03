import 'package:instamarket/src/models/Extras.dart';

class Product {
  final String image;
  final String title;
  final String description;
  final String price;
  final String discount;
  final int categoryId;
  final int id;
  final int count;
  final bool hasCoupon;
  bool couponApplied;
  double couponPrice;
  int couponId;
  List<Extras> extras;

  Product(
      {this.image,
      this.title,
      this.description,
      this.price,
      this.discount,
      this.categoryId,
      this.id,
      this.count,
      this.hasCoupon,
      this.couponApplied,
      this.couponPrice,
      this.couponId,
      this.extras});

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "title": title,
      "description": description,
      "price": price,
      "discount": discount,
      "categoryId": categoryId,
      "id": id,
      "count": count,
      "hasCoupon": hasCoupon,
      "couponApplied": couponApplied,
      "couponPrice": couponPrice,
      "extras":
          extras != null ? extras.map((item) => item.toJson()).toList() : []
    };
  }

  static Product fromJson(dynamic json) {
    List extras = json['extras'];

    return Product(
        image: json['image'],
        title: json['title'],
        description: json['description'],
        price: json['price'],
        discount: json['discount'],
        categoryId: json['categoryId'],
        id: json['id'],
        count: json['count'],
        hasCoupon: json['hasCoupon'],
        couponApplied: json['couponApplied'],
        couponPrice: json['couponPrice'],
        extras: extras != null
            ? extras.map((item) => Extras.fromJson(item)).toList()
            : []);
  }
}
