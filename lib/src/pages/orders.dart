import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/requests/order.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AuthNotifier.dart';
import 'package:instamarket/src/models/User.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/widgets/checkout_product_item.dart';
import 'package:instamarket/src/widgets/rounded_button.dart';
import 'package:instamarket/src/requests/order_cancel.dart';
import 'package:instamarket/src/widgets/order_status.dart';
import 'package:instamarket/src/widgets/order_product_note.dart';
import 'package:instamarket/translations.dart';
import 'package:url_launcher/url_launcher.dart';

class Orders extends StatefulWidget {
  @override
  OrdersState createState() => OrdersState();
}

class OrdersState extends State<Orders> with TickerProviderStateMixin {
  TabController tabController;
  int tabIndex = 1;
  bool update = false;
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();

    tabController = new TabController(length: 3, initialIndex: 1, vsync: this);
    tabController.addListener(handleTabSelection);
  }

  handleTabSelection() {
    if (tabController.indexIsChanging) {
      setState(() {
        tabIndex = tabController.index;
        data = {};
      });
    }
  }

  Future<Map<String, dynamic>> getOrders(
      int shopId, int userId, int tabIndex) async {
    int status = 1;
    if (tabIndex == 0) status = 4;
    if (tabIndex == 2) status = 5;
    Map<String, dynamic> result =
        await ordersRequest(shopId, userId, status, 10, 0);

    if (mounted)
      setState(() {
        data = result;
      });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    User user = context.watch<AuthNotifier>().user;
    Shop shop = context.read<ShopNotifier>().getActiveShop();

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
          Translations.of(context).text('my_orders'),
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.sp),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            width: 1.sw,
            decoration: BoxDecoration(
              color: Theme.of(context).buttonColor,
            ),
            child: TabBar(
              controller: tabController,
              labelStyle:
                  TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor:
                  Theme.of(context).primaryColor.withOpacity(0.3),
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(
                  child: Text(Translations.of(context).text('completed')),
                ),
                Tab(
                  child: Text(Translations.of(context).text('open')),
                ),
                Tab(
                  child: Text(Translations.of(context).text('cancelled')),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
            future: getOrders(shop.id, user.id, tabIndex),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List orders = data['data'] != null ? data['data'] : [];

                return Column(
                    children: orders.map((item) {
                  List details = item['order_detail'];
                  String deliveryAddress = "";
                  if (item['delivery_address'] != null)
                    deliveryAddress = item['delivery_address']['address'];
                  Map<String, dynamic> deliveryBoy = item['delivery_boy'];
                  double destlat =
                      double.parse("${item['delivery_address']['latitude']}");
                  double destlang =
                      double.parse("${item['delivery_address']['longtitude']}");
                  double originlat =
                      double.parse("${item['shops']['latitude']}");
                  double originlang =
                      double.parse("${item['shops']['longtitude']}");

                  double orderTotal = 0;
                  double discountTotal = 0;

                  return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 3,
                              offset: Offset(1, 1),
                            )
                          ],
                          color: Theme.of(context).buttonColor,
                          borderRadius: BorderRadius.circular(10)),
                      width: 1.sw,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${Translations.of(context).text('order')}(ID: ${item['id']}) - ${details.length} ${Translations.of(context).text('items')}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w800),
                          ),
                          Divider(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                Translations.of(context).text('date_purchased'),
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                Translations.of(context).text('delivery_date'),
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                item['created_at'],
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.6),
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                item['delivery_date'],
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.6),
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Divider(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                          ),
                          Text(
                            Translations.of(context).text('delivery_address'),
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            width: 0.9.sw,
                            child: Text(
                              deliveryAddress,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.6),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Divider(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                          ),
                          Column(
                            children: details.map((product) {
                              if (product['is_replaced'] != 1) {
                                int count = product['quantity'];
                                double price =
                                    double.parse(product['price'].toString()) *
                                        count;
                                double discountPrice = double.parse(
                                        product['discount'].toString()) *
                                    count;
                                discountTotal += discountPrice > 0
                                    ? (price - discountPrice)
                                    : 0;
                                orderTotal += price;
                              }

                              return CheckoutProductItem(
                                title: product['product']['lang'][0]['name'],
                                description: product['product']['lang'][0]
                                    ['description'],
                                imageUrl: product['product']['images'][0]
                                    ['image_url'],
                                price: product['price'].toString(),
                                id: product['product']['id'],
                                count: product['quantity'],
                                categoryId: product['product']['id_category'],
                                discount: product['discount'].toString(),
                                isHistory: true,
                                isReplaced:
                                    product['is_replaced'] == 1 ? true : false,
                                isReplacement:
                                    product['is_replacement_product'] == 1
                                        ? true
                                        : false,
                              );
                            }).toList(),
                          ),
                          OrderProductNote(),
                          Divider(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  Translations.of(context).text('discount'),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "$discountTotal \$",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  Translations.of(context).text('delivery_fee'),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "${item['delivery_fee']} \$",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  Translations.of(context).text('total'),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  "${(orderTotal - discountTotal + item['delivery_fee'])} \$",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                          ),
                          if (tabIndex == 1)
                            OrderStatus(
                              status: item['order_status']['id'],
                            ),
                          if (tabIndex == 1)
                            Divider(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                            ),
                          if (deliveryBoy != null &&
                              deliveryBoy['name'] != null &&
                              tabIndex == 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      Translations.of(context)
                                          .text('delivery_boy'),
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                      width: 0.6.sw,
                                      child: Text(
                                        deliveryBoy['name'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            '/OrderPoints',
                                            arguments: {
                                              "originLatitude": originlat,
                                              "originLongitude": originlang,
                                              "destLatitude": destlat,
                                              "destLongitude": destlang,
                                            });
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color.fromRGBO(
                                                      232, 14, 73, 1)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Color.fromRGBO(
                                                        232, 14, 73, 1),
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0)),
                                          )),
                                      child: Icon(
                                        Icons.navigation,
                                        color: Theme.of(context).buttonColor,
                                      )),
                                )
                              ],
                            ),
                          if (deliveryBoy != null &&
                              deliveryBoy['name'] != null &&
                              tabIndex == 1)
                            Divider(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                            ),
                          if (tabIndex == 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                  width: 0.5.sw - 40,
                                  child: RoundedButton(
                                    title: Translations.of(context)
                                        .text('cancel_order'),
                                    color: Color.fromRGBO(232, 14, 73, 1),
                                    onClick: () async {
                                      Map<String, dynamic> dataCancelOrder =
                                          await cancelOrderRequest(item['id']);

                                      if (dataCancelOrder['data']['success'] ==
                                          true)
                                        setState(() {
                                          update = !update;
                                        });
                                    },
                                    isFilled: false,
                                  ),
                                ),
                                if (deliveryBoy != null &&
                                    deliveryBoy['name'] != null &&
                                    deliveryBoy['phone'] != null &&
                                    tabIndex == 1)
                                  SizedBox(
                                    width: 0.5.sw - 40,
                                    child: RoundedButton(
                                      title:
                                          Translations.of(context).text('call'),
                                      color: Color.fromRGBO(33, 160, 54, 1),
                                      onClick: () async {
                                        String _url =
                                            "tel:${deliveryBoy['phone']}";
                                        await canLaunch(_url)
                                            ? await launch(_url)
                                            : throw '$_url';
                                      },
                                      isFilled: true,
                                    ),
                                  ),
                              ],
                            )
                        ],
                      ));
                }).toList());
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Container();
            }),
      ),
    );
  }
}
