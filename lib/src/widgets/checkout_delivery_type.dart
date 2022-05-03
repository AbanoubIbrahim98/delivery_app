import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/checkout_panel_header.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/translations.dart';

class CheckoutDeliveryType extends StatefulWidget {
  final int deliveryType;
  final Function(int) onChange;

  CheckoutDeliveryType({this.deliveryType, this.onChange});

  @override
  CheckoutDeliveryTypeState createState() => CheckoutDeliveryTypeState();
}

class CheckoutDeliveryTypeState extends State<CheckoutDeliveryType> {
  int deliveryType = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      deliveryType = widget.deliveryType;
    });
  }

  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CheckoutPanelHeader(
          title: Translations.of(context).text('delivery_type'),
        ),
        Divider(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (shop.deliveryType == 1 || shop.deliveryType == 3)
              TextButton(
                onPressed: () {
                  setState(() {
                    deliveryType = 0;
                  });
                  widget.onChange(1);
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.delivery_dining,
                      color: deliveryType == 0
                          ? Color.fromRGBO(33, 160, 54, 1)
                          : Theme.of(context).primaryColor,
                      size: 30.sp,
                    ),
                    Container(
                      child: Text(
                        Translations.of(context).text('delivery'),
                        style: TextStyle(
                            color: deliveryType == 0
                                ? Color.fromRGBO(33, 160, 54, 1)
                                : Theme.of(context).primaryColor,
                            fontSize: 12.sp),
                      ),
                    )
                  ],
                ),
              ),
            if (shop.deliveryType == 2 || shop.deliveryType == 3)
              TextButton(
                onPressed: () {
                  setState(() {
                    deliveryType = 1;
                  });
                  widget.onChange(1);
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_basket_outlined,
                      color: deliveryType == 1
                          ? Color.fromRGBO(33, 160, 54, 1)
                          : Theme.of(context).primaryColor,
                      size: 30.sp,
                    ),
                    Container(
                      child: Text(
                        Translations.of(context).text('pickup'),
                        style: TextStyle(
                            color: deliveryType == 1
                                ? Color.fromRGBO(33, 160, 54, 1)
                                : Theme.of(context).primaryColor,
                            fontSize: 12.sp),
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
        Divider(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ],
    );
  }
}
