import 'package:flutter/material.dart';
import 'package:instamarket/src/config/global_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/models/Product.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/translations.dart';

class CartItem extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final int count;
  final int categoryId;
  final String discount;

  CartItem(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.imageUrl,
      this.count,
      this.categoryId,
      this.discount});

  @override
  CartItemState createState() => CartItemState();
}

class CartItemState extends State<CartItem> {
  int count = 0;

  @override
  void initState() {
    super.initState();

    if (widget.count > 0)
      setState(() {
        count = widget.count;
      });
  }

  void increment() {
    Shop shop = context.read<ShopNotifier>().getActiveShop();
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
            discount: widget.discount));
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
              discount: widget.discount));
    else
      context.read<ShopNotifier>().removeFromCart(shop.id, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();

    return Container(
        width: 0.9.sw,
        margin: EdgeInsets.only(right: 0.05.sw, left: 0.05.sw, top: 15),
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(1, 1),
              )
            ],
            color: Theme.of(context).buttonColor,
            borderRadius: BorderRadius.circular(10)),
        child: Dismissible(
          key: Key(widget.id.toString()),
          onDismissed: (direction) {
            context.read<ShopNotifier>().removeFromCart(shop.id, widget.id);
          },
          direction: DismissDirection.endToStart,
          background: Container(
            width: 0.2.sw,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(232, 14, 73, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              Translations.of(context).text('swipe_to_delete'),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).buttonColor,
                  fontSize: 12.sp),
            ),
          ),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "$GLOBAL_URL${widget.imageUrl}",
                  fit: BoxFit.fitWidth,
                  width: 0.2.sw,
                  height: 150,
                  loadingBuilder: (BuildContext ctx, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Image.asset(
                        "lib/assets/images/default.png",
                        fit: BoxFit.fitWidth,
                        width: 0.2.sw,
                        height: 150,
                      );
                    }
                  },
                ),
              ),
              Container(
                width: 0.6.sw,
                height: 150,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 0.6.sw - 20,
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: 0.6.sw - 20,
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
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 4, right: 10),
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
                        if (double.parse(widget.discount) > 0)
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            child: Text(
                              "${widget.price} \$",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Color.fromRGBO(232, 14, 73, 1)
                                      .withOpacity(0.5),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                      ],
                    ),
                    Container(
                      width: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                              width: 100,
                              height: 36,
                              padding: EdgeInsets.all(0),
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
                                                if (count > 1)
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
                              )),
                          Container(
                              width: 36,
                              height: 36,
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).buttonColor,
                                  border: Border.all(
                                      color: Color.fromRGBO(33, 160, 54, 0.5),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(18)),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      count = count + 1;
                                    });
                                    increment();
                                  },
                                  child: Icon(Icons.add,
                                      color: Color.fromRGBO(33, 160, 54, 1))))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
