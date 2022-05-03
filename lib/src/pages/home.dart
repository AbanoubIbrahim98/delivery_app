import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AuthNotifier.dart';
import 'package:instamarket/src/models/User.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/models/Address.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/notifier/AddressNotifier.dart';
import 'package:instamarket/src/config/global_config.dart';
import 'package:instamarket/src/widgets/delivery_type_panel.dart';
import 'package:instamarket/src/widgets/delivery_info_panel.dart';
import 'package:instamarket/src/requests/products.dart';
import 'package:instamarket/src/requests/token.dart';
import 'package:instamarket/src/widgets/category_panel.dart';
import 'package:instamarket/src/widgets/banners.dart';
import 'package:instamarket/src/widgets/brand_panel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instamarket/src/notifier/AppLanguage.dart';
import 'package:instamarket/src/models/Language.dart';
import 'package:instamarket/src/widgets/language_bottom_sheet.dart';
import 'package:instamarket/translations.dart';
import 'package:instamarket/src/widgets/effects/category_block_effect.dart';

class Home extends StatefulWidget {
  final Function menuClick;

  Home({this.menuClick});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();

    tabController = new TabController(length: 3, vsync: this);
    tabController.addListener(handleTabSelection);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        RemoteNotification notification = message.notification;
        String title = notification.title;
        String body = notification.body;
        showAlertDialog(context, title, body);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      String token = await FirebaseMessaging.instance.getAPNSToken();
      if (token != null) {
        User user = Provider.of<AuthNotifier>(context, listen: false).user;
        if (user != null && user.id > 0) {
          await tokenRequest(user.id, token, 1);
        }

        assert(token != null);
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
      }
      if (notification != null && android != null) {
        String title = notification.title;
        String body = notification.body;
        showAlertDialog(context, title, body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message != null) {
        RemoteNotification notification = message.notification;
        String title = notification.title;
        String body = notification.body;
        showAlertDialog(context, title, body);
      }
    });
  }

  showAlertDialog(BuildContext context, String title, String body) {
    Widget continueButton = TextButton(
      child: Text("OK"),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).buttonColor,
      title: Text(title),
      content: Text(body),
      actions: [
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  handleTabSelection() {
    if (tabController.indexIsChanging) {
      setState(() {
        tabIndex = tabController.index;
      });
    }
  }

  Future<Map<String, dynamic>> getProducts(int shopId, int showType) async {
    Map<String, dynamic> data =
        await productsRequest(shopId, -1, 10, 0, showType, 0, 0);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    List<Language> languages = context.watch<AppLanguage>().languages;
    Shop shop = context.read<ShopNotifier>().getActiveShop();
    List<Address> addresses = context.watch<AddressNotifier>().addresses;

    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: Color.fromRGBO(33, 160, 54, 1),
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  double imageHeight = (constraints.biggest.height - 180);

                  return FlexibleSpaceBar(
                    centerTitle: true,
                    background: Image.network(
                      "$GLOBAL_URL${shop.backImageUrl}",
                      fit: BoxFit.fill,
                    ),
                    title: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: 1.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  width: imageHeight > 0 ? imageHeight : 0,
                                  height: imageHeight > 0 ? imageHeight : 0,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).buttonColor,
                                      borderRadius:
                                          BorderRadius.circular(imageHeight)),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(imageHeight),
                                    child: Image.network(
                                      "$GLOBAL_URL${shop.logoUrl}",
                                      height: imageHeight,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: imageHeight > 0 ? 10 : 0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/Shops',
                                      arguments: {"addresses": addresses});
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        shop.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                imageHeight > 0 ? 12.sp : 16.sp,
                                            color:
                                                Theme.of(context).buttonColor),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Theme.of(context).buttonColor,
                                        size: imageHeight > 0 ? 12.sp : 16.sp,
                                      )
                                    ]),
                              ),
                            ),
                            if (imageHeight > 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (shop.deliveryType == 1 ||
                                      shop.deliveryType == 3)
                                    DeliveryTypePanel(
                                      title: Translations.of(context)
                                          .text('delivery'),
                                    ),
                                  if (shop.deliveryType == 2 ||
                                      shop.deliveryType == 3)
                                    DeliveryTypePanel(
                                      title: Translations.of(context)
                                          .text('pickup'),
                                    ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    padding: EdgeInsets.only(left: 5),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: Theme.of(context)
                                                    .buttonColor,
                                                width: 0.5))),
                                    child: Text(
                                      "${Translations.of(context).text('working_hours')}: ${shop.openHour.substring(0, 5)} - ${shop.closeHour.substring(0, 5)}",
                                      style: TextStyle(
                                          fontSize: 6.sp,
                                          color: Theme.of(context).buttonColor,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              )
                          ],
                        )),
                  );
                }),
                leading: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(0)),
                    ),
                    child: Icon(
                      Icons.format_align_left,
                      size: 24.sp,
                      color: Theme.of(context).buttonColor,
                    ),
                    onPressed: widget.menuClick),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      scaffoldKey.currentState
                          .showBottomSheet<Null>((BuildContext context) {
                        return LanguageBottomSheet(
                          languages: languages,
                        );
                      });
                    },
                    icon: Icon(
                      Icons.language,
                      size: 24.sp,
                      color: Theme.of(context).buttonColor,
                    ),
                  )
                ],
              )
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                DeliveryInfoPanel(),
                Banners(),
                Container(
                  width: 1.sw,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).buttonColor,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            offset: Offset(1, 1),
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1)
                      ]),
                  child: TabBar(
                    controller: tabController,
                    labelStyle:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor:
                        Theme.of(context).primaryColor.withOpacity(0.3),
                    indicatorColor: Color.fromRGBO(33, 160, 54, 1),
                    tabs: [
                      Tab(
                        child: Text(
                          Translations.of(context).text('all'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          Translations.of(context).text('new'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          Translations.of(context).text('recomended'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: [
                    for (int i = 0; i < 3; i++)
                      Container(
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: getProducts(shop.id, i),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> data = snapshot.data;
                              List productData = data["data"] ?? [];

                              return Column(
                                children: productData.map((item) {
                                  return CategoryBlock(
                                    categoryName: item["category"]["lang"][0]
                                        ["name"],
                                    categoryId: item["category"]["id"],
                                    products: item["products"].length > 0
                                        ? item["products"]
                                        : [],
                                  );
                                }).toList(),
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }

                            return Column(
                              children: <Widget>[
                                CategoryBlockEffect(),
                                CategoryBlockEffect(),
                                CategoryBlockEffect()
                              ],
                            );
                          },
                        ),
                      )
                  ][tabIndex],
                ),
                BrandPanel()
              ],
            ),
          )),
    );
  }
}
