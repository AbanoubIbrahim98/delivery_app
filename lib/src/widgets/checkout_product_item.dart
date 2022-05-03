import 'package:flutter/material.dart';
import 'package:instamarket/src/config/global_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/translations.dart';

class CheckoutProductItem extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final int count;
  final int categoryId;
  final String discount;
  final bool isReplacement;
  final bool isReplaced;
  final bool isHistory;

  CheckoutProductItem(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.imageUrl,
      this.count,
      this.categoryId,
      this.discount,
      this.isHistory = false,
      this.isReplacement = false,
      this.isReplaced = false});

  @override
  CheckoutProductItemState createState() => CheckoutProductItemState();
}

class CheckoutProductItemState extends State<CheckoutProductItem> {
  int count = 0;

  @override
  void initState() {
    super.initState();

    if (widget.count > 0)
      setState(() {
        count = widget.count;
      });
  }

  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();
    bool isCouponApplied =
        context.read<ShopNotifier>().isCouponApplied(shop.id, widget.id);

    return Container(
        width: 1.sw - 60,
        padding: EdgeInsets.symmetric(vertical: 5),
        foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.isReplaced
                ? Color.fromRGBO(232, 14, 73, 1).withOpacity(0.3)
                : (widget.isReplacement
                    ? Color.fromRGBO(33, 160, 54, 1).withOpacity(0.3)
                    : Colors.transparent)),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "$GLOBAL_URL${widget.imageUrl}",
                fit: BoxFit.contain,
                width: 100,
                height: 100,
                loadingBuilder: (BuildContext ctx, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Image.asset(
                      "lib/assets/images/default.png",
                      fit: BoxFit.contain,
                      width: 100,
                      height: 100,
                    );
                  }
                },
              ),
            ),
            Container(
              width: 1.sw - 160,
              padding: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 1.sw - 250,
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        "x$count",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Container(
                    width: 1.sw - 180,
                    child: Text(
                      widget.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.6),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  if (double.parse(widget.discount) > 0)
                    Container(
                      width: 1.sw - 180,
                      child: Text(
                        "${widget.price} \$",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color:
                                Color.fromRGBO(232, 14, 73, 1).withOpacity(0.5),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  Container(
                    width: 1.sw - 180,
                    child: Text(
                      double.parse(widget.discount) > 0
                          ? "${widget.discount} \$"
                          : "${widget.price} \$",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (isCouponApplied && !widget.isHistory)
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        Translations.of(context).text('coupon_applied'),
                        style: TextStyle(
                            color: Color.fromRGBO(232, 14, 73, 1),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                ],
              ),
            )
          ],
        ));
  }
}
