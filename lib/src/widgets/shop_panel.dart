import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/config/global_config.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/translations.dart';

class ShopPanel extends StatelessWidget {
  final int id;
  final String name;
  final String description;
  final String info;
  final String logoUrl;
  final String address;
  final String backImageUrl;
  final String openHours;
  final String closeHours;
  final double lat;
  final double lng;
  final int deliveryType;
  final double deliveryPrice;
  final double tax;
  final int showType;

  ShopPanel(
      {@required this.name,
      @required this.description,
      @required this.logoUrl,
      @required this.closeHours,
      @required this.openHours,
      this.backImageUrl,
      this.address,
      this.lat,
      this.lng,
      this.deliveryType,
      this.deliveryPrice,
      this.tax,
      this.info,
      this.id,
      this.showType = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 0.9.sw,
        height: 150,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 0.05.sw,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).buttonColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(1, 1),
              )
            ]),
        child: Stack(
          children: <Widget>[
            if (showType > 1)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromRGBO(232, 14, 73, 1)),
                  child: Text(
                    showType == 2
                        ? Translations.of(context).text('new')
                        : Translations.of(context).text('top'),
                    style: TextStyle(
                        fontSize: 10.sp, color: Theme.of(context).buttonColor),
                  ),
                ),
              ),
            TextButton(
              onPressed: () {
                context.read<ShopNotifier>().addShop(Shop(
                    id: id,
                    name: name,
                    description: description,
                    info: info,
                    logoUrl: logoUrl,
                    backImageUrl: backImageUrl,
                    address: address,
                    openHour: openHours,
                    closeHour: closeHours,
                    lat: lat,
                    lng: lng,
                    deliveryType: deliveryType,
                    deliveryPrice: deliveryPrice,
                    active: true));

                Navigator.of(context).pushReplacementNamed('/main');
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(0))),
              child: Row(
                children: <Widget>[
                  Container(
                      width: 0.2.sw,
                      height: 0.2.sw,
                      decoration: BoxDecoration(
                          color: Theme.of(context).buttonColor,
                          borderRadius: BorderRadius.circular(0.1.sw),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(1, 1),
                            )
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.1.sw),
                        child: Image.network(
                          "$GLOBAL_URL$logoUrl",
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    width: (0.7.sw - 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.turned_in_not,
                              size: 16.sp,
                              color: Color.fromARGB(255, 248, 132, 98),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.only(top: 4, bottom: 4, left: 5),
                              width: 0.5.sw,
                              child: Text(
                                description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.6),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.timer,
                              size: 16.sp,
                              color: Color.fromARGB(255, 248, 132, 98),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              width: 0.5.sw,
                              child: Text(
                                "${Translations.of(context).text('working_hours')}: ${openHours.substring(0, 5)} - ${closeHours.substring(0, 5)}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.6),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
