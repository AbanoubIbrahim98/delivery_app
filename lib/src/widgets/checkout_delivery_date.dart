import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/checkout_panel_header.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/translations.dart';

class CheckoutDeliveryDate extends StatefulWidget {
  @override
  CheckoutDeliveryDateState createState() => CheckoutDeliveryDateState();
}

class CheckoutDeliveryDateState extends State<CheckoutDeliveryDate> {
  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CheckoutPanelHeader(
              title: Translations.of(context).text('delivery_date'),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/ShopInfo',
                    arguments: {"activeTabIndex": 1, "shop": shop});
              },
              child: Text(
                Translations.of(context).text('edit'),
                style: TextStyle(
                    color: Color.fromRGBO(33, 160, 54, 1),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
        Divider(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
        Container(
          width: 1.sw - 60,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            shop.deliveryDate != null ? shop.deliveryDate : "",
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(0.6),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400),
          ),
        ),
        Divider(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ],
    );
  }
}
