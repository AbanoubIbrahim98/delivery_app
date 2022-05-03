import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Address.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/AddressNotifier.dart';
import 'package:instamarket/translations.dart';

class DeliveryInfoPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Address defaultAddress =
        context.read<AddressNotifier>().getDefaultAddress();
    Shop shop = context.read<ShopNotifier>().getActiveShop();

    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(1, 1),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1)
          ]),
      child: Column(
        children: <Widget>[
          Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.2)))),
            child: Text(
              Translations.of(context).text('deliver_to'),
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800),
            ),
          ),
          Container(
            width: 1.sw,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.2)))),
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/UserLocationList',
                        arguments: {"onGoBack": () {}});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 0.5.sw - 70,
                        child: Text(defaultAddress.address,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        width: 35,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.edit,
                          color: Color.fromRGBO(
                            33,
                            160,
                            54,
                            1,
                          ),
                          size: 20.sp,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  width: 1,
                  height: 20,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                ),
                InkWell(
                  onTap: () {
                    Shop shop = context.read<ShopNotifier>().getActiveShop();
                    Navigator.of(context).pushNamed('/ShopInfo',
                        arguments: {"activeTabIndex": 1, "shop": shop});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 0.5.sw - 70,
                        child: Text(
                            shop.deliveryDate != null ? shop.deliveryDate : "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        width: 35,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.info_outline,
                          color: Color.fromRGBO(
                            33,
                            160,
                            54,
                            1,
                          ),
                          size: 20.sp,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
