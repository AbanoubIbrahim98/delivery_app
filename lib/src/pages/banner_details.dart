import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/banner_item.dart';
import 'package:instamarket/src/requests/banner_products.dart';
import 'package:instamarket/src/widgets/product_panel.dart';
import 'package:instamarket/translations.dart';

class BannerDetails extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String position;
  final String imageUrl;
  final Color backgroundColor;
  final Color titleColor;

  BannerDetails(
      {this.id,
      this.title,
      this.description,
      this.position,
      this.imageUrl,
      this.backgroundColor,
      this.titleColor});

  @override
  BannerDetailsState createState() => BannerDetailsState();
}

class BannerDetailsState extends State<BannerDetails> {
  ScrollController scrollController = new ScrollController();
  bool loading = true;
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
        getBannerProducts();
      }
    });
  }

  Future<List> getBannerProducts() async {
    if (loading) {
      Map<String, dynamic> data =
          await bannerProductsRequest(widget.id, 10, offset);

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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).buttonColor,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        elevation: 0,
        title: Text(
          Translations.of(context).text('banners_detail'),
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.sp),
        ),
      ),
      body: Align(
          alignment: Alignment.topLeft,
          child: FutureBuilder<List>(
              future: getBannerProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> listWidget = [];

                  listWidget.add(Column(children: <Widget>[
                    BannerItem(
                      id: widget.id,
                      title: widget.title,
                      description: widget.description,
                      position: widget.position,
                      imageUrl: widget.imageUrl,
                      backgroundColor: widget.backgroundColor,
                      titleColor: widget.titleColor,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                    ),
                  ]));

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
                        isFixed: false,
                        quantity: products[i]['quantity'],
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
              })),
    );
  }
}
