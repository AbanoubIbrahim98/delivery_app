import 'package:flutter/material.dart';
import 'package:instamarket/src/pages/forgot_password.dart';
import 'package:instamarket/src/pages/login.dart';
import 'package:instamarket/src/pages/otp_verification.dart';
import 'package:instamarket/src/pages/registration.dart';
import 'package:instamarket/src/pages/splash.dart';
import 'package:instamarket/src/pages/auth_success.dart';
import 'package:instamarket/src/pages/user_location_list.dart';
import 'package:instamarket/src/pages/user_location.dart';
import 'package:instamarket/src/pages/user_location_search.dart';
import 'package:instamarket/src/pages/shops.dart';
import 'package:instamarket/src/pages/shops_map.dart';
import 'package:instamarket/src/pages/shop_info.dart';
import 'package:instamarket/src/pages/product_details.dart';
import 'package:instamarket/src/pages/category_detail.dart';
import 'package:instamarket/src/pages/liked_products.dart';
import 'package:instamarket/src/pages/banner_details.dart';
import 'package:instamarket/src/pages/orders.dart';
import 'package:instamarket/src/pages/checkout.dart';
import 'package:instamarket/src/pages/settings.dart';
import 'package:instamarket/src/pages/qa.dart';
import 'package:instamarket/src/pages/about.dart';
import 'package:instamarket/src/pages/profile.dart';
import 'package:instamarket/src/pages/brands.dart';
import 'package:instamarket/src/pages/brand_products.dart';
import 'package:instamarket/src/pages/notification.dart';
import 'package:instamarket/src/layout/main_layout.dart';
import 'package:instamarket/src/pages/search.dart';
import 'package:instamarket/src/pages/order_track.dart';

class Routes {
  static Route<dynamic> routes(RouteSettings settings) {
    final Map args = settings.arguments;

    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => Splash());
      case '/main':
        return MaterialPageRoute(builder: (_) => MainLayout());
      case '/Login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/Registration':
        return MaterialPageRoute(builder: (_) => Registration());
      case '/ForgotPassword':
        return MaterialPageRoute(builder: (_) => ForgotPassword());
      case '/OtpVerification':
        return MaterialPageRoute(
            builder: (_) => OtpVerification(
                  smsCode: args['smsCode'],
                  name: args['name'],
                  surname: args['surname'],
                  phoneNumber: args['phone'],
                  password: args['password'],
                ));
      case '/AuthSuccess':
        return MaterialPageRoute(builder: (_) => AuthSuccess());
      case '/UserLocationList':
        return MaterialPageRoute(
            builder: (_) => UserLocationList(
                  onGoBack: args['onGoBack'],
                ));
      case '/UserLocation':
        return MaterialPageRoute(
            builder: (_) => UserLocation(
                address: args['address'],
                latitude: args['latitude'],
                longitude: args['longitude'],
                onGoBack: args['update']));
      case '/UserLocationSearch':
        return MaterialPageRoute(
            builder: (_) => UserLocationSearch(
                  onComplete: args['onComplete'],
                ));
      case '/Shops':
        return MaterialPageRoute(
            builder: (_) => Shops(
                  addresses: args["addresses"],
                ));
      case '/ShopsMap':
        return MaterialPageRoute(
            builder: (_) => ShopsMap(
                  data: args['data'],
                ));
      case '/ShopInfo':
        return MaterialPageRoute(
            builder: (_) => ShopInfo(
                activeTabIndex: args["activeTabIndex"], shop: args["shop"]));
      case '/ProductDetails':
        return MaterialPageRoute(
            builder: (_) => ProductDetails(
                  id: args["id"],
                  imageUrl: args["image"],
                  title: args["title"],
                  description: args["description"],
                  categoryId: args["categoryId"],
                  price: args["price"],
                  discount: args["discount"],
                  count: args["count"],
                  extrasData: args["extrasData"],
                  isLiked: args["isLiked"],
                  onChange: args["onChange"],
                  hasCoupon: args['hasCoupon'],
                ));
      case '/CategoryDetails':
        return MaterialPageRoute(
            builder: (_) => CategoryDetails(
                  id: args["id"],
                  name: args["name"],
                ));
      case '/LikedProducts':
        return MaterialPageRoute(builder: (_) => LikedProducts());
      case '/Orders':
        return MaterialPageRoute(builder: (_) => Orders());
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => Checkout());
      case '/Search':
        return MaterialPageRoute(builder: (_) => Search());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => Settings());
      case '/Qa':
        return MaterialPageRoute(builder: (_) => Qa());
      case '/About':
        return MaterialPageRoute(builder: (_) => About());
      case '/Notifications':
        return MaterialPageRoute(builder: (_) => Notifications());
      case '/Profile':
        return MaterialPageRoute(
            builder: (_) => Profile(
                  user: args['user'],
                ));
      case '/Brands':
        return MaterialPageRoute(builder: (_) => Brands());
      case '/OrderPoints':
        return MaterialPageRoute(
            builder: (_) => OrderTrack(
                  originLatitude: args['originLatitude'],
                  originLongitude: args['originLongitude'],
                  destLatitude: args['destLatitude'],
                  destLongitude: args['destLongitude'],
                ));
      case '/BrandProducts':
        return MaterialPageRoute(
            builder: (_) => BrandProducts(
                  brandId: args['id'],
                  brandImageUrl: args['imageUrl'],
                  brandName: args['name'],
                ));
      case '/BannerDetails':
        return MaterialPageRoute(
            builder: (_) => BannerDetails(
                id: args["id"],
                title: args["title"],
                description: args["description"],
                position: args["position"],
                imageUrl: args["imageUrl"],
                backgroundColor: args["backgroundColor"],
                titleColor: args["titleColor"]));
      default:
        return MaterialPageRoute(builder: (_) => Login());
    }
  }
}
