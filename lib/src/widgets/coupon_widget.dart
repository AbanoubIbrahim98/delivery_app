import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/translations.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/src/widgets/rounded_button.dart';
import 'package:instamarket/src/requests/coupon_apply.dart';

class CouponWidget extends StatefulWidget {
  final int productId;
  final int count;
  final double price;
  final Function(bool) onApply;

  CouponWidget({this.productId, this.count, this.price, this.onApply});

  @override
  CouponWidgetState createState() => CouponWidgetState();
}

class CouponWidgetState extends State<CouponWidget> {
  String code;

  Widget applyCouponDialog(BuildContext context) {
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
                  Translations.of(context).text('enter_coupon_code'),
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
            Container(
              width: 0.8.sw,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context).primaryColor.withOpacity(0.1))),
              child: TextField(
                maxLines: 1,
                style: TextStyle(color: Theme.of(context).primaryColor),
                onChanged: (text) {
                  setState(() {
                    code = text;
                  });
                },
                decoration: InputDecoration.collapsed(
                    hintText:
                        Translations.of(context).text('enter_your_code_here'),
                    hintStyle: TextStyle(
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.1))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                    width: 0.3.sw,
                    child: RoundedButton(
                      title: Translations.of(context).text('save'),
                      color: Color.fromRGBO(33, 160, 54, 1),
                      onClick: () async {
                        if (code != null && code.length > 1) {
                          Map<String, dynamic> coupon =
                              await couponApplyRequest(widget.productId, code);

                          if (coupon['data'] != null &&
                              coupon['data'].length > 0) {
                            print(coupon['data']);
                            double discount = double.parse(
                                coupon['data'][0]['discount'].toString());
                            int discountType =
                                coupon['data'][0]['discount_type'];
                            int couponId = coupon['data'][0]['id'];
                            double discountPrice = discountType == 0
                                ? (discount * widget.price).round() / 100
                                : discount;

                            Shop shop =
                                context.read<ShopNotifier>().getActiveShop();
                            bool couponApplied = context
                                .read<ShopNotifier>()
                                .applyCoupon(shop.id, widget.productId,
                                    discountPrice, couponId);

                            widget.onApply(couponApplied);
                          }

                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        }
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
    bool isCouponApplied =
        context.read<ShopNotifier>().isCouponApplied(shop.id, widget.productId);

    return Container(
      width: 1.sw,
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (isCouponApplied != null && !isCouponApplied)
            SizedBox(
              width: 0.4.sw,
              height: 40,
              child: TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          applyCouponDialog(context));
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromRGBO(232, 14, 73, 1),
                              width: 0.5),
                          borderRadius: new BorderRadius.circular(5))),
                ),
                child: Text(
                  Translations.of(context).text('apply_coupon'),
                  style: TextStyle(
                      color: Color.fromRGBO(232, 14, 73, 1),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          if (isCouponApplied != null && isCouponApplied)
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
    );
  }
}
