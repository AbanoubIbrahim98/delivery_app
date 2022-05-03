import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/requests/products.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/widgets/category_item_rounded.dart';
import 'package:instamarket/src/widgets/product_panel.dart';
import 'package:instamarket/src/pages/filter.dart';
import 'package:instamarket/translations.dart';
import 'package:instamarket/src/widgets/effects/product_effect.dart';
import 'package:instamarket/src/widgets/effects/category_effect.dart';

class CategoryDetails extends StatefulWidget {
  final String name;
  final int id;

  CategoryDetails({this.name, this.id});

  @override
  CategoryDetailsState createState() => CategoryDetailsState();
}

class CategoryDetailsState extends State<CategoryDetails> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  int orderByType = 0;
  int brandId = 0;
  bool loading = true;
  int shopIds = 0;
  List products = [];
  List categories = [];
  int offset = 0;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!loading)
          setState(() {
            loading = true;
          });
        getProducts(shopIds);
      }
    });
  }

  Future<List> getProducts(int shopId) async {
    if (loading) {
      Map<String, dynamic> data = await productsRequest(
          shopId, widget.id, 10, offset, 0, brandId, orderByType);

      if (data['data'].length > 0) {
        List productsData = data['data'][0]["products"];
        List categoriesData = data['data'][0]["category"];

        if (mounted)
          setState(() {
            products.addAll(productsData);
            shopIds = shopId;
            offset = products.length;
            categories = categoriesData;
            loading = false;
          });
      }

      return products;
    } else
      return products;
  }

  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).buttonColor,
      endDrawer: Container(
        width: 0.7.sw,
        child: Filter(
          brandId: brandId,
          orderByTypeId: orderByType,
          onComplete: (orderByTypeId, brand) {
            setState(() {
              orderByType = orderByTypeId;
              brandId = brand;
              loading = true;
              products = [];
              offset = 0;
            });
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 160, 54, 1),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).buttonColor,
        ),
        title: Text(
          widget.name,
          style:
              TextStyle(color: Theme.of(context).buttonColor, fontSize: 16.sp),
        ),
        actions: [
          IconButton(
            onPressed: () {
              scaffoldKey.currentState.openEndDrawer();
            },
            icon: Icon(LineIcons.filter),
          )
        ],
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: FutureBuilder<List>(
          future: getProducts(shop.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> listWidget = [];

              listWidget.add(Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (categories.length > 0)
                    Container(
                      width: 1.sw,
                      height: 170,
                      child: ListView.builder(
                          itemCount: categories.length,
                          scrollDirection: Axis.horizontal,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: CategoryItemRounded(
                                name: categories[index]['lang'][0]['name'],
                                imageUrl: categories[index]['image_url'],
                                id: categories[index]['id'],
                              ),
                            );
                          }),
                    ),
                  Container(
                    margin:
                        EdgeInsets.only(bottom: categories.length > 0 ? 0 : 10),
                    padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: categories.length > 0 ? 10 : 0),
                    child: Text(
                      Translations.of(context).text('products'),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ));

              List<Widget> subListWidget = [];
              for (int i = 0; i < products.length; i++) {
                subListWidget.add(Container(
                  height: 330,
                  child: ProductPanel(
                    title: products[i]["lang"][0]["name"],
                    description: products[i]["lang"][0]["description"],
                    price: products[i]["price"].toString(),
                    discount: products[i]['discount_price'].toString(),
                    imageUrl: products[i]["images"][0]["image_url"],
                    id: products[i]['id'],
                    categoryId: products[i]['id_category'],
                    quantity: products[i]['quantity'],
                    isFixed: false,
                    isCouponProduct: products[i]['has_coupon'],
                  ),
                ));

                if ((i + 1) % 2 == 0 || i == products.length - 1) {
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
                  controller: scrollController,
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
              controller: scrollController,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (categories.length > 0)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          Translations.of(context).text('sub_categories'),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    if (categories.length > 0)
                      Container(
                        width: 1.sw,
                        height: 170,
                        child: Row(
                          children: <Widget>[
                            CategoryEffectEffect(),
                            CategoryEffectEffect(),
                            CategoryEffectEffect()
                          ],
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: categories.length > 0 ? 0 : 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: categories.length > 0 ? 10 : 0),
                      child: Text(
                        Translations.of(context).text('products'),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
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
          },
        ),
      ),
    );
  }
}
