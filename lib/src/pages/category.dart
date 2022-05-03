import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/requests/categories.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/widgets/category_item.dart';
import 'package:instamarket/translations.dart';
import 'package:instamarket/src/widgets/effects/category_effect.dart';

class Category extends StatefulWidget {
  @override
  CategoryState createState() => CategoryState();
}

class CategoryState extends State<Category> {
  Future<Map<String, dynamic>> getCategories(int shopId) async {
    Map<String, dynamic> data = await categoriesRequest(shopId, -1);

    return data;
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
          Translations.of(context).text('category'),
          style:
              TextStyle(color: Theme.of(context).buttonColor, fontSize: 16.sp),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              width: 1.sw,
              decoration: BoxDecoration(
                color: Color.fromRGBO(33, 160, 54, 1),
              ),
              child: TextField(
                style: TextStyle(color: Theme.of(context).primaryColor),
                onTap: () {
                  Navigator.of(context).pushNamed('/Search');
                },
                decoration: InputDecoration(
                    hintText: Translations.of(context).text('search_items'),
                    hintStyle: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: OutlineInputBorder(
                      gapPadding: 0.0,
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).buttonColor),
              )),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
        child: FutureBuilder<Map<String, dynamic>>(
          future: getCategories(shop.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data;
              List categoriesData = data["data"];
              List<Widget> listWidget = [];
              List<Widget> subListWidget = [];
              for (int i = 0; i < categoriesData.length; i++) {
                subListWidget.add(CategoryItem(
                  name: categoriesData[i]['lang'][0]['name'],
                  imageUrl: categoriesData[i]['image_url'],
                  id: categoriesData[i]['id'],
                ));

                if ((i + 1) % 3 == 0 || i == categoriesData.length - 1) {
                  listWidget.add(Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: subListWidget,
                  ));

                  subListWidget = [];
                }
              }

              return Column(children: listWidget);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CategoryEffectEffect(),
                    CategoryEffectEffect(),
                    CategoryEffectEffect()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CategoryEffectEffect(),
                    CategoryEffectEffect(),
                    CategoryEffectEffect()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CategoryEffectEffect(),
                    CategoryEffectEffect(),
                    CategoryEffectEffect()
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
