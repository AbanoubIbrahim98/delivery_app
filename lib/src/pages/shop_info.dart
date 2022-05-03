import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/config/global_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/requests/delivery_times.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/src/widgets/shop_info_panel.dart';
import 'package:instamarket/translations.dart';

class ShopInfo extends StatefulWidget {
  final int activeTabIndex;
  final Shop shop;

  ShopInfo({this.activeTabIndex = 0, this.shop});

  @override
  ShopInfoState createState() => ShopInfoState();
}

class ShopInfoState extends State<ShopInfo> with TickerProviderStateMixin {
  TabController tabController;
  int tabIndex = 0;
  int timeUnit = 0;
  int dayId = 0;

  @override
  void initState() {
    super.initState();

    if (widget.activeTabIndex > 0)
      setState(() {
        tabIndex = widget.activeTabIndex;
        timeUnit = widget.shop.deliveryTimeId;
        dayId = widget.shop.deliveryDayId;
      });

    tabController =
        new TabController(length: 2, initialIndex: tabIndex, vsync: this);
    tabController.addListener(handleTabSelection);
  }

  Future<Map<String, dynamic>> getTimeUnits(int shopId) async {
    Map<String, dynamic> data = await deliveryTimesRequest(shopId);

    return data;
  }

  handleTabSelection() {
    if (tabController.indexIsChanging) {
      setState(() {
        tabIndex = tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List monthArray = [
      Translations.of(context).text('january'),
      Translations.of(context).text('february'),
      Translations.of(context).text('march'),
      Translations.of(context).text('april'),
      Translations.of(context).text('may'),
      Translations.of(context).text('june'),
      Translations.of(context).text('july'),
      Translations.of(context).text('august'),
      Translations.of(context).text('september'),
      Translations.of(context).text('november'),
      Translations.of(context).text('october'),
      Translations.of(context).text('december')
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: BackButton(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.circular(50)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  "$GLOBAL_URL${widget.shop.logoUrl}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Text(
                widget.shop.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            Container(
              width: 1.sw,
              margin: EdgeInsets.only(top: 20, bottom: 5),
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                indicatorColor: Color.fromRGBO(33, 160, 54, 1),
                tabs: [
                  Tab(
                    child: Text(Translations.of(context).text('info')),
                  ),
                  Tab(
                    child:
                        Text(Translations.of(context).text('delivery_times')),
                  ),
                ],
              ),
            ),
            Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
              ),
              child: [
                Container(
                  width: 1.sw,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ShopInfoPanel(
                          title: Translations.of(context).text('address'),
                          info: widget.shop.address),
                      ShopInfoPanel(
                          title: Translations.of(context).text('working_hours'),
                          info: widget.shop.openHour.substring(0, 5) +
                              " - " +
                              widget.shop.closeHour.substring(0, 5)),
                      ShopInfoPanel(
                          title: Translations.of(context).text('delivery_fee'),
                          info: widget.shop.deliveryPrice.toString()),
                      ShopInfoPanel(
                          title: Translations.of(context).text('delivery_type'),
                          info: widget.shop.deliveryType == 3
                              ? "#${Translations.of(context).text('delivery')} #${Translations.of(context).text('pickup')}"
                              : (widget.shop.deliveryType == 1
                                  ? "#${Translations.of(context).text('delivery')}"
                                  : "#${Translations.of(context).text('pickup')}")),
                      ShopInfoPanel(
                          title: Translations.of(context).text('address'),
                          info: widget.shop.address),
                      ShopInfoPanel(
                          title: Translations.of(context).text('description'),
                          info: widget.shop.description),
                      ShopInfoPanel(
                          title: Translations.of(context).text('info'),
                          info: widget.shop.info),
                    ],
                  ),
                ),
                FutureBuilder<Map<String, dynamic>>(
                  future: getTimeUnits(widget.shop.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Widget> widgets = [];
                      Map<String, dynamic> data = snapshot.data;
                      List timeUnits = data['data'];

                      DateTime now = DateTime.now();
                      DateTime tomorrow =
                          DateTime(now.year, now.month, now.day + 1);
                      DateTime afterTomorrow =
                          DateTime(now.year, now.month, now.day + 2);
                      String name =
                          "${Translations.of(context).text('today')}, ${now.day} ${monthArray[now.month - 1]}";
                      List names = [];
                      for (int i = 0; i < 3; i++) {
                        if (i == 1) {
                          name =
                              "${Translations.of(context).text('tomorrow')}, ${tomorrow.day} ${monthArray[tomorrow.month - 1]}";
                        } else if (i == 2) {
                          name =
                              "${afterTomorrow.day} ${monthArray[afterTomorrow.month - 1]}";
                        }

                        names.add(name);

                        widgets.add(Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            name,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w800),
                          ),
                        ));

                        for (int m = 0; m < timeUnits.length; m++) {
                          widgets.add(TextButton(
                            onPressed: () {
                              setState(() {
                                timeUnit = m;
                                dayId = i;
                              });

                              context.read<ShopNotifier>().setDeliveryTime(
                                  widget.shop.id,
                                  m,
                                  i,
                                  "${names[i]} ${timeUnits[m]["name"]}");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 0.5.sw,
                                  child: Text(
                                    timeUnits[m]["name"],
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.6),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                if (timeUnit == m && dayId == i)
                                  Icon(
                                    LineIcons.check,
                                    color: Color.fromRGBO(33, 160, 54, 1),
                                  )
                              ],
                            ),
                          ));
                        }
                      }

                      return Column(
                        children: widgets,
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Column(
                      children: <Widget>[],
                    );
                  },
                )
              ][tabIndex],
            ),
          ],
        ),
      ),
    );
  }
}
