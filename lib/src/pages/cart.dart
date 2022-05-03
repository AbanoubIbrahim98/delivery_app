import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/models/Product.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AuthNotifier.dart';
import 'package:instamarket/src/models/User.dart';
import 'package:instamarket/src/widgets/cart_item.dart';
import 'package:instamarket/src/widgets/cart_bottom_sheet.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/src/widgets/rounded_button.dart';
import 'package:instamarket/translations.dart';

class Cart extends StatefulWidget {
  @override
  CartState createState() => CartState();
}

class CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isCheckoutAction = false;

  Widget alertDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Theme.of(context).buttonColor,
      child: Container(
        width: 0.8.sw,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  Translations.of(context).text('attention'),
                  style: TextStyle(
                      fontSize: 16.sp, color: Theme.of(context).primaryColor),
                ),
                IconButton(
                    icon: Icon(LineIcons.times,
                        size: 20.sp, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    })
              ],
            ),
            Divider(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
            Text(
              Translations.of(context).text('to_complete_your_order'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).primaryColor.withOpacity(0.6)),
            ),
            Divider(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                    width: 0.4.sw - 15,
                    child: RoundedButton(
                      title: Translations.of(context).text('signin'),
                      color: Color.fromRGBO(33, 160, 54, 1),
                      onClick: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.of(context).pushNamed('/Login');
                      },
                      isFilled: true,
                    )),
                SizedBox(
                    width: 0.4.sw - 15,
                    child: RoundedButton(
                      title: Translations.of(context).text('signup'),
                      color: Color.fromRGBO(33, 160, 54, 1),
                      onClick: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.of(context).pushNamed('/Registration');
                      },
                      isFilled: true,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();
    List<Product> cartProduct = shop.cartProducts ?? [];
    Map<String, dynamic> totalData =
        context.read<ShopNotifier>().getCartTotalInfo(shop.id);
    User user = context.watch<AuthNotifier>().user;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).buttonColor,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 160, 54, 1),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).buttonColor,
        ),
        title: Text(
          Translations.of(context).text('cart'),
          style:
              TextStyle(color: Theme.of(context).buttonColor, fontSize: 16.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: cartProduct.length == 0
            ? Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 1.sw,
                    padding: EdgeInsets.only(top: 0.1.sh),
                    child: Image(
                        height: 300,
                        fit: BoxFit.contain,
                        image: AssetImage('lib/assets/images/emptycart.png')),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    width: 0.8.sw,
                    alignment: Alignment.center,
                    child: Text(
                      Translations.of(context).text('cart_empty'),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Color.fromRGBO(232, 14, 73, 1)),
                    ),
                  ),
                  RoundedButton(
                    title: Translations.of(context).text('order_history'),
                    color: Color.fromRGBO(232, 14, 73, 1),
                    onClick: () {
                      Navigator.of(context).pushNamed("/Orders");
                    },
                    isFilled: true,
                  )
                ],
              )
            : Column(
                children: cartProduct.map((item) {
                  return CartItem(
                    title: item.title,
                    description: item.description,
                    imageUrl: item.image,
                    price: item.price,
                    id: item.id,
                    count: item.count,
                    categoryId: item.categoryId,
                    discount: item.discount,
                  );
                }).toList(),
              ),
      ),
      bottomNavigationBar: isCheckoutAction || totalData['total'] <= 0
          ? null
          : Container(
              height: 60,
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(1, 1),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translations.of(context).text('total_amount'),
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "${totalData['total']} \$",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 0.3.sw,
                    child: CustomButton(
                      title: Translations.of(context).text('checkout'),
                      onClick: () {
                        setState(() {
                          isCheckoutAction = true;
                        });

                        scaffoldKey.currentState
                            .showBottomSheet<Null>((BuildContext context) {
                              return CartBottomSheet(
                                onCancel: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    isCheckoutAction = false;
                                  });
                                },
                                onSubmit: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    isCheckoutAction = false;
                                  });

                                  if (user != null &&
                                      user.id != null &&
                                      user.id > 0)
                                    Navigator.of(context)
                                        .pushNamed('/Checkout');
                                  else
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            alertDialog());
                                },
                              );
                            })
                            .closed
                            .then((value) {
                              setState(() {
                                isCheckoutAction = false;
                              });
                            });
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
