import 'package:flutter/material.dart';
import 'package:instamarket/translations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/src/requests/search_products.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/widgets/product_panel.dart';
import 'package:instamarket/src/widgets/effects/product_effect.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  ScrollController scrollController = new ScrollController();
  TextEditingController _controller = TextEditingController();
  String searchText = "";
  bool loading = true;
  int shopIds = 0;
  List products = [];
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
      }
    });
  }

  Future<List> getProducts(int shopId) async {
    if (loading && searchText.length >= 3) {
      Map<String, dynamic> data =
          await searchProductsRequest(shopId, searchText, 10, offset);

      if (data['data'].length > 0) {
        List productsData = data['data'];

        if (mounted)
          setState(() {
            products.addAll(productsData);
            offset = products.length;
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
      backgroundColor: Theme.of(context).buttonColor,
      appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Theme.of(context).buttonColor,
          ),
          automaticallyImplyLeading: false,
          title: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Container(
                width: 1.sw,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 0.7.sw,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2)),
                      child: TextField(
                        onChanged: (text) async {
                          setState(() {
                            searchText = text;
                            products = [];
                            offset = 0;
                            loading = true;
                          });

                          getProducts(shop.id);
                        },
                        controller: _controller,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        decoration: InputDecoration(
                          hintText:
                              Translations.of(context).text('type_something'),
                          icon: Icon(
                            LineIcons.search,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (searchText.length > 0) _controller.clear();
                            },
                            icon: Icon(Icons.clear_rounded),
                            color: searchText.length > 0
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            padding: EdgeInsets.all(0),
                          ),
                          hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 0.2.sw,
                        alignment: Alignment.center,
                        child: Text(
                          Translations.of(context).text('cancel'),
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Color.fromRGBO(33, 160, 54, 1),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              )),
          elevation: 0,
          backgroundColor: Theme.of(context).buttonColor),
      body: Align(
        alignment: Alignment.topLeft,
        child: FutureBuilder<List>(
            future: getProducts(shop.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Widget> listWidget = [];
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
                      isCouponProduct: true,
                      isFixed: false,
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
      ),
    );
  }
}
