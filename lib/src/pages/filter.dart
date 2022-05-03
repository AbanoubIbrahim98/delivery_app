import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:instamarket/src/widgets/sort_by_item.dart';
import 'package:instamarket/src/requests/brands.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/translations.dart';

class Filter extends StatefulWidget {
  final int orderByTypeId;
  final int brandId;
  final Function(int, int) onComplete;

  Filter({this.onComplete, this.brandId, this.orderByTypeId});

  @override
  FilterState createState() => FilterState();
}

class FilterState extends State<Filter> {
  int orderByTypeId = 0;
  bool brandExtended = false;
  int brandId = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      orderByTypeId = widget.orderByTypeId ?? 0;
      brandId = widget.brandId ?? 0;
    });
  }

  Future<Map<String, dynamic>> getBrands(int shopId) async {
    Map<String, dynamic> data = await brandsRequest(shopId, 10, 0);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();

    return Scaffold(
      backgroundColor: Theme.of(context).buttonColor,
      appBar: AppBar(
          backgroundColor: Theme.of(context).buttonColor,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          elevation: 0,
          title: Text(
            Translations.of(context).text('filter'),
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 16.sp),
          )),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                Translations.of(context).text('sort_by'),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
            SortByItem(
              checked: orderByTypeId == 1,
              title: Translations.of(context).text('sort_by_low_price'),
              id: 1,
              onClick: (id) {
                setState(() {
                  orderByTypeId = id;
                });
              },
            ),
            SortByItem(
              checked: orderByTypeId == 2,
              title: Translations.of(context).text('sort_by_hight_price'),
              id: 2,
              onClick: (id) {
                setState(() {
                  orderByTypeId = id;
                });
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                Translations.of(context).text('brands'),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: getBrands(shop.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data = snapshot.data;
                  List brandData = data["data"];

                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: !brandExtended && brandData.length > 5
                          ? 6
                          : brandData.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 5 && !brandExtended)
                          return TextButton(
                            onPressed: () {
                              setState(() {
                                brandExtended = true;
                              });
                            },
                            child: Text(
                              Translations.of(context).text('show_more'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(33, 160, 54, 1),
                                  fontSize: 12.sp),
                            ),
                          );

                        return SortByItem(
                          checked: brandId == brandData[index]['id'],
                          title: "${brandData[index]['name']}",
                          id: brandData[index]['id'],
                          onClick: (id) {
                            setState(() {
                              brandId = id;
                            });
                          },
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Container();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        title: Translations.of(context).text('apply'),
        onClick: () {
          widget.onComplete(orderByTypeId, brandId);
          Navigator.of(context).pop();
        },
        isRounded: false,
      ),
    );
  }
}
