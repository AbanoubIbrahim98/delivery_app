import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/requests/brands.dart';
import 'package:instamarket/src/widgets/brand_item.dart';
import 'package:instamarket/translations.dart';
import 'package:instamarket/src/widgets/effects/brand_effect.dart';

class BrandPanel extends StatefulWidget {
  @override
  BrandPanelState createState() => BrandPanelState();
}

class BrandPanelState extends State<BrandPanel> {
  Future<Map<String, dynamic>> getBrands(int shopId) async {
    Map<String, dynamic> data = await brandsRequest(shopId, 10, 0);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();

    return FutureBuilder<Map<String, dynamic>>(
        future: getBrands(shop.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data;
            List brandData = data["data"] ?? [];

            return Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: 1.sw,
                decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      )
                    ]),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 7),
                      width: 1.sw - 20,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2)))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 0.5.sw,
                            child: Text(
                              Translations.of(context).text('brands'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/Brands");
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 0.5.sw - 50,
                                  child: Text(
                                    Translations.of(context).text('view_more'),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(232, 14, 73, 1)),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Color.fromRGBO(232, 14, 73, 1),
                                  size: 20.sp,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 1.sw,
                      height: 180,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: ListView.builder(
                          itemCount: brandData.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return BrandItem(
                              imageUrl: brandData[index]['image_url'],
                              isMain: true,
                              id: brandData[index]['id'],
                              name: brandData[index]['name'],
                            );
                          }),
                    )
                  ],
                ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Container(
              width: 1.sw,
              height: 180,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return BrandEffect(
                      isMain: true,
                    );
                  }));
        });
  }
}
