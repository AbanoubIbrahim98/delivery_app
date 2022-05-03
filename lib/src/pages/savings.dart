import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/requests/discount.dart';
import 'package:instamarket/src/requests/coupon_products.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/widgets/product_panel.dart';
import 'package:instamarket/translations.dart';
import 'package:instamarket/src/widgets/effects/product_effect.dart';

class Savings extends StatefulWidget {
  @override
  SavingsState createState() => SavingsState();
}

class SavingsState extends State<Savings> with TickerProviderStateMixin {
  TabController tabController;
  int tabIndex = 0;
  ScrollController discountScrollController = new ScrollController();
  ScrollController couponScrollController = new ScrollController();
  bool loadingDiscount = true;
  bool loadingCoupon = true;
  int shopIds = 0;
  List discounts = [];
  List coupons = [];
  int offsetDiscount = 0;
  int offsetCoupon = 0;

  @override
  void initState() {
    super.initState();

    tabController = new TabController(length: 2, vsync: this);
    tabController.addListener(handleTabSelection);

    discountScrollController.addListener(() {
      if (discountScrollController.position.pixels ==
          discountScrollController.position.maxScrollExtent) {
        if (!loadingDiscount)
          setState(() {
            loadingDiscount = true;
          });
        getdiscountProducts(shopIds);
      }
    });

    couponScrollController.addListener(() {
      if (couponScrollController.position.pixels ==
          couponScrollController.position.maxScrollExtent) {
        if (!loadingCoupon)
          setState(() {
            loadingCoupon = true;
          });
        getCouponProducts(shopIds);
      }
    });
  }

  handleTabSelection() {
    if (tabController.indexIsChanging) {
      setState(() {
        tabIndex = tabController.index;
      });
    }
  }

  Future<List> getdiscountProducts(int shopId) async {
    if (loadingDiscount) {
      Map<String, dynamic> data =
          await discountRequest(shopId, 10, offsetDiscount);

      if (data['data'].length > 0) {
        List discountData = data['data'];

        if (mounted)
          setState(() {
            discounts.addAll(discountData);
            offsetDiscount = discounts.length;
            loadingDiscount = false;
          });
      }

      return discounts;
    } else
      return discounts;
  }

  Future<List> getCouponProducts(int shopId) async {
    if (loadingCoupon) {
      Map<String, dynamic> data =
          await couponProductsRequest(shopId, 10, offsetCoupon);

      if (data['data'].length > 0) {
        List couponData = data['data'] ?? [];

        if (mounted)
          setState(() {
            coupons.addAll(couponData);
            offsetCoupon = coupons.length;
            loadingCoupon = false;
          });
      }

      return coupons;
    } else
      return coupons;
  }

  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 160, 54, 1),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          Translations.of(context).text('savings'),
          style:
              TextStyle(color: Theme.of(context).buttonColor, fontSize: 16.sp),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            width: 1.sw,
            decoration: BoxDecoration(
              color: Color.fromRGBO(33, 160, 54, 1),
            ),
            child: TabBar(
              controller: tabController,
              labelStyle:
                  TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              labelColor: Theme.of(context).buttonColor,
              unselectedLabelColor:
                  Theme.of(context).buttonColor.withOpacity(0.3),
              indicatorColor: Theme.of(context).buttonColor,
              tabs: [
                Tab(
                  child: Text(Translations.of(context).text('discounts')),
                ),
                Tab(
                  child: Text(Translations.of(context).text('coupons')),
                )
              ],
            ),
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: [
          FutureBuilder<List>(
              future: getdiscountProducts(shop.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> listWidget = [];
                  List<Widget> subListWidget = [];
                  for (int i = 0; i < discounts.length; i++) {
                    subListWidget.add(Container(
                      height: 330,
                      child: ProductPanel(
                        title: discounts[i]["lang"][0]["name"],
                        description: discounts[i]["lang"][0]["description"],
                        price: discounts[i]["price"].toString(),
                        discount: discounts[i]['discount_price'].toString(),
                        imageUrl: discounts[i]["images"][0]["image_url"],
                        id: discounts[i]['id'],
                        categoryId: discounts[i]['id_category'],
                        quantity: discounts[i]['quantity'],
                        isFixed: false,
                        isCouponProduct: discounts[i]['has_coupon'],
                      ),
                    ));

                    if ((i + 1) % 2 == 0 || i == discounts.length - 1) {
                      listWidget.add(Row(
                        mainAxisAlignment: subListWidget.length == 2
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.start,
                        children: subListWidget,
                      ));

                      subListWidget = [];
                    }
                  }

                  return Scrollbar(
                    child: ListView(
                      controller: discountScrollController,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: listWidget,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Scrollbar(
                    child: ListView(
                  controller: discountScrollController,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            height: 310,
                            child: ProductEffect(
                              isFixed: false,
                            )),
                        Container(
                            height: 310,
                            child: ProductEffect(
                              isFixed: false,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            height: 310,
                            child: ProductEffect(
                              isFixed: false,
                            )),
                        Container(
                            height: 310,
                            child: ProductEffect(
                              isFixed: false,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            height: 310,
                            child: ProductEffect(
                              isFixed: false,
                            )),
                        Container(
                            height: 310,
                            child: ProductEffect(
                              isFixed: false,
                            )),
                      ],
                    )
                  ],
                ));
              }),
          FutureBuilder<List>(
              future: getCouponProducts(shop.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> listWidget = [];
                  List<Widget> subListWidget = [];
                  for (int i = 0; i < coupons.length; i++) {
                    subListWidget.add(Container(
                      height: 330,
                      child: ProductPanel(
                        title: coupons[i]["lang"][0]["name"],
                        description: coupons[i]["lang"][0]["description"],
                        price: coupons[i]["price"].toString(),
                        discount: coupons[i]['discount_price'].toString(),
                        imageUrl: coupons[i]["images"][0]["image_url"],
                        id: coupons[i]['id'],
                        categoryId: coupons[i]['id_category'],
                        quantity: coupons[i]['quantity'],
                        isCouponProduct: true,
                        isFixed: false,
                      ),
                    ));

                    if ((i + 1) % 2 == 0 || i == coupons.length - 1) {
                      listWidget.add(Row(
                        mainAxisAlignment: subListWidget.length == 2
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.start,
                        children: subListWidget,
                      ));

                      subListWidget = [];
                    }
                  }

                  return Scrollbar(
                    child: ListView(
                      controller: couponScrollController,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: listWidget,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Scrollbar(
                    child: ListView(
                  controller: discountScrollController,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            height: 310,
                            child: ProductEffect(
                              isFixed: false,
                            )),
                        Container(
                            height: 310,
                            child: ProductEffect(
                              isFixed: false,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            height: 310,
                            child: ProductEffect(
                              isFixed: false,
                            )),
                        Container(
                            height: 310,
                            child: ProductEffect(
                              isFixed: false,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            height: 310,
                            child: ProductEffect(
                              isFixed: false,
                            )),
                        Container(
                            height: 310,
                            child: ProductEffect(
                              isFixed: false,
                            )),
                      ],
                    )
                  ],
                ));
              }),
        ][tabIndex],
      ),
    );
  }
}
