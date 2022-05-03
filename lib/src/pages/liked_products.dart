import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/models/Product.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/widgets/product_panel.dart';
import 'package:instamarket/translations.dart';

class LikedProducts extends StatefulWidget {
  @override
  LikedProductsState createState() => LikedProductsState();
}

class LikedProductsState extends State<LikedProducts> {
  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();
    List<Product> likedProducts =
        context.read<ShopNotifier>().getLikedProducts(shop.id);

    List<Widget> listWidget = [];
    List<Widget> subListWidget = [];
    for (int i = 0; i < likedProducts.length; i++) {
      int pcount = context
          .read<ShopNotifier>()
          .getProductCount(shop.id, likedProducts[i].id);
      bool isLiked = context
          .read<ShopNotifier>()
          .isProductLiked(shop.id, likedProducts[i].id);

      subListWidget.add(Container(
        height: 270,
        child: ProductPanel(
          title: likedProducts[i].title,
          description: likedProducts[i].description,
          price: likedProducts[i].price,
          discount: likedProducts[i].discount,
          imageUrl: likedProducts[i].image,
          id: likedProducts[i].id,
          categoryId: likedProducts[i].categoryId,
          quantity: 0,
          isFixed: false,
          isLikedProduct: true,
          count: pcount,
          isLiked: isLiked,
          isCouponProduct: likedProducts[i].hasCoupon,
        ),
      ));

      if ((i + 1) % 2 == 0 || i == likedProducts.length - 1) {
        listWidget.add(Row(
          mainAxisAlignment: subListWidget.length == 2
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: subListWidget,
        ));

        subListWidget = [];
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).buttonColor,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        elevation: 0,
        title: Text(
          Translations.of(context).text('liked_products'),
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: listWidget,
        ),
      ),
    );
  }
}
