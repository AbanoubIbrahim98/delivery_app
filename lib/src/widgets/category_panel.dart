import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/product_panel.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/translations.dart';

class CategoryBlock extends StatelessWidget {
  final String categoryName;
  final int categoryId;
  final List products;

  CategoryBlock(
      {@required this.categoryName, @required this.categoryId, this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: 1.sw,
      decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(1, 1),
            )
          ]),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 7),
            width: 1.sw - 20,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.2)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 0.5.sw,
                  child: Text(
                    categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed("/CategoryDetails",
                        arguments: {"name": categoryName, "id": categoryId});
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 0.5.sw - 50,
                        child: Text(
                          Translations.of(context).text('view_more'),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(232, 14, 73, 1)),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Color.fromRGBO(232, 14, 73, 1),
                        size: 20.sp,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 280,
            child: ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext ctx, int index) {
                Shop shop = context.read<ShopNotifier>().getActiveShop();
                int pcount = context
                    .read<ShopNotifier>()
                    .getProductCount(shop.id, products[index]["id"]);
                bool isLiked = context
                    .read<ShopNotifier>()
                    .isProductLiked(shop.id, products[index]["id"]);

                return ProductPanel(
                  title: products[index]["lang"][0]["name"],
                  description: products[index]["lang"][0]["description"],
                  price: products[index]["price"].toString(),
                  discount: products[index]["discount_price"].toString(),
                  imageUrl: products[index]["images"][0]["image_url"],
                  id: products[index]["id"],
                  quantity: products[index]["quantity"],
                  categoryId: categoryId,
                  count: pcount,
                  isLiked: isLiked,
                  isCouponProduct: products[index]["has_coupon"],
                  star: double.parse(products[index]["star"].toString()),
                  comment: products[index]["comments_count"],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
