import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/models/Product.dart';
import 'package:instamarket/src/models/Extras.dart';

class ShopNotifier with ChangeNotifier {
  List<Shop> shops = [];

  ShopNotifier() {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List shopsJson = prefs.getString('shop') != null
        ? json.decode(prefs.getString('shop'))
        : [];
    shops = shopsJson.map((json) {
      return Shop.fromJson(json);
    }).toList();
  }

  void addShop(Shop shop) {
    int activeIndex = shops.indexWhere((element) => element.active == true);
    if (activeIndex > -1) shops[activeIndex].active = false;

    int index = shops.indexWhere((element) => element.id == shop.id);
    if (index == -1) {
      shops.add(shop);
    } else {
      Shop oldShop = shops[index];

      shops[index] = shop;
      shops[index].active = true;
      shops[index].cartProducts = oldShop.cartProducts;
      shops[index].likedProducts = oldShop.likedProducts;
    }

    setData(shops);

    notifyListeners();
  }

  void setData(List<Shop> shops) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        "shop",
        json.encode(shops.map((item) {
          return item.toJson();
        }).toList()));
  }

  Shop getActiveShop() {
    int index = shops.indexWhere((element) => element.active == true);

    if (shops.length > 0)
      return index > 0 ? shops[index] : shops[0];
    else
      return Shop();
  }

  void addToCart(int shopId, Product product) {
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      List<Product> cartProducts = shops[index].cartProducts ?? [];
      int pIndex =
          cartProducts.indexWhere((element) => element.id == product.id);

      if (shops[index].cartProducts == null) shops[index].cartProducts = [];

      if (pIndex == -1) {
        shops[index].cartProducts.add(product);
      } else {
        List<Extras> oldExtras = shops[index].cartProducts[pIndex].extras;
        if (product.extras == null) product.extras = oldExtras;
        shops[index].cartProducts[pIndex] = product;
      }
    }

    setData(shops);

    notifyListeners();
  }

  void addToLiked(int shopId, Product product) {
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      List<Product> likedProducts = shops[index].likedProducts ?? [];
      int pIndex =
          likedProducts.indexWhere((element) => element.id == product.id);

      if (shops[index].likedProducts == null) shops[index].likedProducts = [];

      if (pIndex == -1) {
        shops[index].likedProducts.add(product);
      } else {
        shops[index].likedProducts.removeAt(pIndex);
      }
    }

    setData(shops);

    notifyListeners();
  }

  bool isProductLiked(int shopId, int productId) {
    bool isLiked = false;
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      List<Product> likedProducts = shops[index].likedProducts ?? [];
      if (likedProducts != null) {
        int pIndex =
            likedProducts.indexWhere((element) => element.id == productId);
        if (pIndex == -1) {
          isLiked = false;
        } else {
          isLiked = true;
        }
      }
    }

    return isLiked;
  }

  bool isCouponApplied(int shopId, int productId) {
    bool isCouponApplied = false;
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      List<Product> cartProducts = shops[index].cartProducts ?? [];
      if (cartProducts != null) {
        int pIndex =
            cartProducts.indexWhere((element) => element.id == productId);
        if (pIndex == -1) {
          isCouponApplied = false;
        } else {
          isCouponApplied = cartProducts[pIndex].couponApplied ?? false;
        }
      }
    }

    return isCouponApplied;
  }

  bool applyCoupon(
      int shopId, int productId, double couponPrice, int couponId) {
    bool isCouponApplied = false;
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      List<Product> cartProducts = shops[index].cartProducts ?? [];
      if (cartProducts != null) {
        int pIndex =
            cartProducts.indexWhere((element) => element.id == productId);
        if (pIndex == -1) {
          isCouponApplied = false;
        } else {
          isCouponApplied = true;
          cartProducts[pIndex].couponApplied = true;
          cartProducts[pIndex].couponPrice = couponPrice;
          cartProducts[pIndex].couponId = couponId;
        }
      }
    }

    setData(shops);

    notifyListeners();

    return isCouponApplied;
  }

  List<Product> getLikedProducts(int shopId) {
    List<Product> likedProducts = [];
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      likedProducts = shops[index].likedProducts ?? [];
    }

    return likedProducts;
  }

  void removeFromCart(int shopId, int productId) {
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      List<Product> cartProducts = shops[index].cartProducts;
      int pIndex =
          cartProducts.indexWhere((element) => element.id == productId);
      if (pIndex > -1) {
        shops[index].cartProducts.removeAt(pIndex);
      }
    }

    setData(shops);

    notifyListeners();
  }

  void clearCart(int shopId) {
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      shops[index].cartProducts = [];
    }

    setData(shops);

    notifyListeners();
  }

  int getProductCount(int shopId, int productId) {
    int count = 0;
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      List<Product> cartProducts = shops[index].cartProducts;
      if (cartProducts != null) {
        int pIndex =
            cartProducts.indexWhere((element) => element.id == productId);
        if (pIndex > -1) {
          count = shops[index].cartProducts[pIndex].count;
        }
      }
    }

    return count;
  }

  List<Extras> getProductExtras(int shopId, int productId) {
    List<Extras> extras = [];
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      List<Product> cartProducts = shops[index].cartProducts;
      if (cartProducts != null) {
        int pIndex =
            cartProducts.indexWhere((element) => element.id == productId);
        if (pIndex > -1) {
          extras = shops[index].cartProducts[pIndex].extras;
        }
      }
    }

    if (extras != null) return extras;
    return [];
  }

  List<Product> getShopCart(int shopId) {
    List<Product> products = [];
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      products = shops[index].cartProducts;
    }

    return products;
  }

  Map<String, dynamic> getCartTotalInfo(int shopId) {
    List<Product> products = [];
    double total = 0;
    double discount = 0;
    double deliveryFee = 0;
    int count = 0;
    double coupon = 0;
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      products = shops[index].cartProducts ?? [];
      deliveryFee =
          shops[index].deliveryPrice != null ? shops[index].deliveryPrice : 0;
      total = products.fold(0, (acc, cur) {
        double extaPrice = 0;
        if (cur.extras != null)
          extaPrice = cur.extras
              .fold(0, (acc2, cur2) => acc2 + double.parse(cur2.price));

        return acc + cur.count * (double.parse(cur.price) + extaPrice);
      });
      discount = products.fold(
          0,
          (acc, cur) => acc + double.parse(cur.discount) > 0
              ? cur.count *
                  (double.parse(cur.price) - double.parse(cur.discount))
              : 0);
      coupon = products.fold(
          0,
          (acc, cur) => acc +
                      double.parse(cur.couponPrice != null
                          ? cur.couponPrice.toString()
                          : "0") >
                  0
              ? cur.count *
                  double.parse(cur.couponPrice != null
                      ? cur.couponPrice.toString()
                      : "0")
              : 0);
      count = products.length;
    }

    return {
      "delivery_fee": deliveryFee,
      "subtotal": total,
      "total": total > 0 ? (total - discount + deliveryFee - coupon) : 0,
      "discount": discount,
      "count": count,
      "coupon": coupon
    };
  }

  void setDeliveryTime(
      int shopId, int deliveryTimeId, int deliveryDayId, String deliveryDate) {
    int index = shops.indexWhere((element) => element.id == shopId);
    if (index > -1) {
      shops[index].deliveryTimeId = deliveryTimeId;
      shops[index].deliveryDayId = deliveryDayId;
      shops[index].deliveryDate = deliveryDate;
    }

    setData(shops);

    notifyListeners();
  }
}
