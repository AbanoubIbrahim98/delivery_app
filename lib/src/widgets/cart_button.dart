import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/models/Product.dart';
import 'package:provider/provider.dart';

class CartButton extends StatefulWidget {
  final String title;
  final String description;
  final String price;
  final String discount;
  final String imageUrl;
  final int id;
  final int categoryId;
  final int count;
  final Function(int) onChange;

  CartButton(
      {@required this.title,
      @required this.description,
      @required this.price,
      @required this.discount,
      @required this.imageUrl,
      @required this.id,
      @required this.categoryId,
      @required this.onChange,
      this.count = 0});

  @override
  CartButtonState createState() => CartButtonState();
}

class CartButtonState extends State<CartButton> {
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
    return Container(
      height: 50,
      width: 0.5.sw - 30,
      decoration: BoxDecoration(
          border: Border.all(
              color: Color.fromRGBO(33, 160, 54, 1),
              width: 1,
              style: BorderStyle.solid),
          borderRadius: new BorderRadius.circular(30.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 50,
            width: 50,
            child: TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(0))),
                onPressed: () {
                  if (count > 0)
                    setState(() {
                      count = count - 1;
                    });

                  descriment();
                  widget.onChange(count);
                },
                child:
                    Icon(Icons.remove, color: Color.fromRGBO(33, 160, 54, 1))),
          ),
          Container(
            width: 0.5.sw - 132,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        width: 1, color: Color.fromRGBO(33, 160, 54, 1)),
                    right: BorderSide(
                        width: 1, color: Color.fromRGBO(33, 160, 54, 1)))),
            child: Text(
              "$count",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(0))),
                onPressed: () {
                  setState(() {
                    count = count + 1;
                  });
                  increment();
                  widget.onChange(count);
                },
                child: Icon(Icons.add, color: Color.fromRGBO(33, 160, 54, 1))),
          )
        ],
      ),
    );
  }
}
