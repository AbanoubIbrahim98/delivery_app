import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/requests/brands.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/brand_item.dart';
import 'package:instamarket/translations.dart';

class Brands extends StatefulWidget {
  @override
  BrandsState createState() => BrandsState();
}

class BrandsState extends State<Brands> {
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
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        elevation: 0,
        title: Text(
          Translations.of(context).text('brands'),
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<Map<String, dynamic>>(
          future: getBrands(shop.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data;
              List brandData = data["data"];

              List<Widget> listWidget = [];
              List<Widget> subListWidget = [];
              for (int i = 0; i < brandData.length; i++) {
                subListWidget.add(Container(
                  height: 180,
                  child: BrandItem(
                    imageUrl: brandData[i]['image_url'],
                    id: brandData[i]['id'],
                    name: brandData[i]['name'],
                  ),
                ));

                if ((i + 1) % 2 == 0 || i == brandData.length - 1) {
                  listWidget.add(Row(
                    mainAxisAlignment: subListWidget.length == 2
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.start,
                    children: subListWidget,
                  ));

                  subListWidget = [];
                }
              }

              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listWidget);
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
