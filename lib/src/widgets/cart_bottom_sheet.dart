import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/translations.dart';

class CartBottomSheet extends StatelessWidget {
  final Function onCancel;
  final Function onSubmit;
  final bool isCheckOut;

  CartBottomSheet({this.onCancel, this.onSubmit, this.isCheckOut = false});

  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();
    Map<String, dynamic> totalData =
        context.read<ShopNotifier>().getCartTotalInfo(shop.id);

    return Container(
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              if (!isCheckOut)
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(1, 1),
                )
            ],
            color: Theme.of(context).buttonColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        width: 1.sw,
        padding:
            EdgeInsets.symmetric(horizontal: isCheckOut ? 0 : 30, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (!isCheckOut)
              Container(
                height: 4,
                width: 80,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Theme.of(context).primaryColor.withOpacity(0.1)),
              ),
            if (!isCheckOut)
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(33, 160, 54, 1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      Icons.shopping_bag,
                      color: Theme.of(context).buttonColor,
                      size: 20.sp,
                    ),
                  ),
                  Text(
                    Translations.of(context).text('cart_summary'),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${Translations.of(context).text('subtotal')} (${totalData['count']} ${Translations.of(context).text('items')})",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "${totalData['subtotal']} \$",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.1)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Translations.of(context).text('discount'),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "${totalData['discount']} \$",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Translations.of(context).text('delivery_fee'),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "${totalData['delivery_fee']} \$",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.1)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Translations.of(context).text('add_coupon'),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "${totalData['coupon']} \$",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Translations.of(context).text('total'),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "${totalData['total']} \$",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
            ),
            if (!isCheckOut)
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: 0.3.sw,
                      child: TextButton(
                        onPressed: onCancel,
                        child: Text(
                          Translations.of(context).text('cancel'),
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Color.fromRGBO(33, 160, 54, 1)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 0.3.sw,
                      child: CustomButton(
                        title: Translations.of(context).text('order_now'),
                        onClick: onSubmit,
                      ),
                    )
                  ],
                ),
              )
          ],
        ));
  }
}
