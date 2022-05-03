import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/config/global_config.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/models/Product.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Extras.dart';
import 'package:instamarket/translations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductPanel extends StatefulWidget {
  final String title;
  final String description;
  final String price;
  final String discount;
  final String imageUrl;
  final int id;
  final int categoryId;
  final bool isFixed;
  final bool isLiked;
  final bool isLikedProduct;
  final int count;
  final int quantity;
  final bool isCouponProduct;
  final double star;
  final int comment;

  ProductPanel(
      {@required this.title,
      @required this.description,
      @required this.price,
      @required this.discount,
      @required this.imageUrl,
      @required this.id,
      @required this.categoryId,
      @required this.quantity,
      this.isFixed = true,
      this.isLiked = false,
      this.isLikedProduct = false,
      this.count = 0,
      this.star = 0,
      this.comment,
      this.isCouponProduct = false});

  ProductPanelState createState() => ProductPanelState();
}

class ProductPanelState extends State<ProductPanel>
    with TickerProviderStateMixin {
  bool isLiked = false;
  final Duration duration = const Duration(milliseconds: 500);
  int count = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.count > 0) count = widget.count;
      isLiked = widget.isLiked;
    });
  }

  void increment() {
    Shop shop = context.read<ShopNotifier>().getActiveShop();
    if (count <= widget.quantity)
      context.read<ShopNotifier>().addToCart(
          shop.id,
          Product(
              id: widget.id,
              image: widget.imageUrl,
              title: widget.title,
              description: widget.description,
              categoryId: widget.categoryId,
              count: count,
              price: widget.price,
              discount: widget.discount,
              hasCoupon: widget.isCouponProduct));
  }

  void descriment() {
    Shop shop = context.read<ShopNotifier>().getActiveShop();
    if (count > 0)
      context.read<ShopNotifier>().addToCart(
          shop.id,
          Product(
              id: widget.id,
              image: widget.imageUrl,
              title: widget.title,
              description: widget.description,
              categoryId: widget.categoryId,
              count: count,
              price: widget.price,
              discount: widget.discount,
              hasCoupon: widget.isCouponProduct));
    else
      context.read<ShopNotifier>().removeFromCart(shop.id, widget.id);
  }

  void addToLiked() {
    Shop shop = context.read<ShopNotifier>().getActiveShop();
    context.read<ShopNotifier>().addToLiked(
        shop.id,
        Product(
            id: widget.id,
            image: widget.imageUrl,
            title: widget.title,
            description: widget.description,
            categoryId: widget.categoryId,
            count: count,
            price: widget.price,
            discount: widget.discount,
            hasCoupon: widget.isCouponProduct));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Shop shop = context.read<ShopNotifier>().getActiveShop();
        List<Extras> extrasData =
            context.read<ShopNotifier>().getProductExtras(shop.id, widget.id);
        print("extrasData: $extrasData");
        Navigator.of(context).pushNamed('/ProductDetails', arguments: {
          "id": widget.id,
          "image": widget.imageUrl,
          "title": widget.title,
          "description": widget.description,
          "categoryId": widget.categoryId,
          "price": widget.price,
          "discount": widget.discount,
          "count": count,
          "extrasData": extrasData,
          "isLiked": isLiked,
          "hasCoupon": widget.isCouponProduct,
          "onChange": () {
            int pcount = context
                .read<ShopNotifier>()
                .getProductCount(shop.id, widget.id);
            bool pisLiked =
                context.read<ShopNotifier>().isProductLiked(shop.id, widget.id);

            setState(() {
              count = pcount;
              isLiked = pisLiked;
            });
          }
        });
      },
      child: Container(
          width: widget.isFixed ? 160 : 0.5.sw,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: widget.isFixed
                  ? Colors.transparent
                  : Theme.of(context).buttonColor),
          child: Stack(
            children: <Widget>[
              Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Container(
                    width: widget.isFixed ? 160 : 0.5.sw - 20,
                    padding: widget.isFixed
                        ? EdgeInsets.all(0)
                        : EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: widget.isFixed
                          ? BorderRadius.circular(0)
                          : BorderRadius.circular(10),
                      child: Image.network(
                        "$GLOBAL_URL${widget.imageUrl}",
                        fit: BoxFit.contain,
                        width: widget.isFixed ? 160 : 0.5.sw - 20,
                        height: widget.isFixed ? 150 : 150,
                        loadingBuilder: (BuildContext ctx, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Image.asset(
                              "lib/assets/images/default.png",
                              fit: BoxFit.contain,
                              width: widget.isFixed ? 160 : 0.5.sw - 20,
                              height: widget.isFixed ? 150 : 150,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: InkWell(
                        onTap: () {
                          this.setState(() {
                            isLiked = !isLiked;
                          });

                          addToLiked();
                        },
                        child: Container(
                            width: 40,
                            height: 40,
                            child: Icon(Icons.favorite,
                                size: 24.sp,
                                color: isLiked
                                    ? Color.fromRGBO(232, 14, 73, 1)
                                    : Color.fromRGBO(232, 14, 73, 1)
                                        .withOpacity(0.3))),
                      )),
                ],
              ),
              Positioned(
                left: widget.isFixed ? 0 : 10,
                right: widget.isFixed ? 0 : 10,
                top: widget.isFixed ? 200 : 150,
                child: Container(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.only(bottom: 8, left: 0, top: 5),
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        Text(
                            widget.discount != null &&
                                    double.parse(widget.discount) > 0
                                ? "${widget.discount} \$"
                                : "${widget.price} \$",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700)),
                        if (widget.discount != null &&
                            double.parse(widget.discount) > 0)
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("${widget.price} \$",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Color.fromRGBO(232, 14, 73, 1)
                                          .withOpacity(0.5),
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w400))),
                      ],
                    )),
              ),
              if (double.parse(widget.discount) > 0 &&
                  (double.parse(widget.price) - double.parse(widget.discount)) >
                      0)
                Positioned(
                  top: widget.isFixed ? 225 : 175,
                  left: 5,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(232, 14, 73, 1),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "${(double.parse(widget.price) - double.parse(widget.discount)).toStringAsFixed(2)} \$ off",
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: Theme.of(context).buttonColor),
                    ),
                  ),
                ),
              Positioned(
                  left: widget.isFixed ? 0 : 10,
                  right: widget.isFixed ? 0 : 10,
                  top: widget.isFixed ? 150 : 210,
                  child: Text(widget.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.6)))),
              if (widget.isFixed)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 180,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        RatingBar.builder(
                          initialRating: double.parse(
                              widget.star != null ? "${widget.star}" : "0"),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 5,
                          unratedColor:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          itemPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                          itemSize: 14,
                          itemBuilder: (context, _) =>
                              Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {},
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.comment != null
                                ? "(${widget.comment})"
                                : "(0)",
                            style: TextStyle(
                                fontSize: 10.sp,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.8),
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              if (!widget.isLikedProduct &&
                  widget.quantity != null &&
                  widget.quantity > 0 &&
                  !widget.isFixed)
                Positioned(
                    left: widget.isFixed ? 0 : 10,
                    right: widget.isFixed ? 0 : 10,
                    top: widget.isFixed ? 175 : 220,
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          width: widget.isFixed ? 100 : 0.45.sw - 70,
                          height: 36,
                          padding: EdgeInsets.all(0),
                          child: Stack(alignment: Alignment.topLeft, children: <
                              Widget>[
                            AnimatedPositioned(
                                left: 0,
                                right: 0,
                                top: count == 0 ? 70 : 0,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InkWell(
                                            onTap: () {
                                              if (count > 0)
                                                setState(() {
                                                  count = count - 1;
                                                });

                                              descriment();
                                            },
                                            child: Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Color.fromRGBO(
                                                            33, 160, 54, 0.5),
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18)),
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Color.fromRGBO(
                                                      33, 160, 54, 1),
                                                ))),
                                        Container(
                                            width: 60,
                                            child: Text(
                                              "$count pc",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14.sp),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                                duration: duration)
                          ]),
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                count = count + 1;
                              });
                              increment();
                            },
                            child: Container(
                                width: 36,
                                height: 36,
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).buttonColor,
                                    border: Border.all(
                                        color: Color.fromRGBO(33, 160, 54, 0.5),
                                        width: 2),
                                    borderRadius: BorderRadius.circular(18)),
                                child: Icon(Icons.add,
                                    color: Color.fromRGBO(33, 160, 54, 1))))
                      ],
                    )),
              if (count >= widget.quantity && !widget.isFixed)
                Positioned(
                    right: 10,
                    top: widget.isFixed ? 260 : 290,
                    height: 30,
                    child: Text(
                      Translations.of(context).text('out_of_stock'),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: Color.fromRGBO(232, 14, 73, 1)),
                    )),
              if (widget.isCouponProduct &&
                  !(count >= widget.quantity) &&
                  !widget.isFixed)
                Positioned(
                  left: widget.isFixed ? 0 : 10,
                  top: widget.isFixed ? 260 : 290,
                  child: Row(
                    children: <Widget>[
                      Text(
                        Translations.of(context).text('see_coupon_offer'),
                        style: TextStyle(
                            color: Color.fromRGBO(232, 14, 73, 1),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                )
            ],
          )),
    );
  }
}
