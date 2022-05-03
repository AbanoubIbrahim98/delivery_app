import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/requests/products.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/widgets/product_panel.dart';

class BrandProducts extends StatefulWidget {
  final String brandName;
  final String brandImageUrl;
  final int brandId;

  BrandProducts({this.brandName, this.brandImageUrl, this.brandId});

  @override
  BrandProductsState createState() => BrandProductsState();
}

class BrandProductsState extends State<BrandProducts> {
  ScrollController scrollController = new ScrollController();
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
        getProducts(shopIds);
      }
    });
  }

  Future<List> getProducts(int shopId) async {
    if (loading) {
      Map<String, dynamic> data =
          await productsRequest(shopId, 0, 10, offset, 0, widget.brandId, 0);
      if (data['data'].length > 0) {
        List productsData = data['data'][0]["products"];
        if (mounted)
          setState(() {
            products.addAll(productsData);
            shopIds = shopId;
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
          backgroundColor: Theme.of(context).buttonColor,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          elevation: 0,
          title: Text(
            "${widget.brandName}",
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 16.sp),
          )),
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
                  height: 310,
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

            return Container();
          },
        ),
      ),
    );
  }
}
