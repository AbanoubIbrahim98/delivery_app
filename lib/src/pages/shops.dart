import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart' as LocationLib;
import 'package:instamarket/src/requests/location_without_permission.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AddressNotifier.dart';
import 'package:instamarket/src/models/Address.dart';
import 'package:instamarket/src/widgets/shop_panel.dart';
import 'package:instamarket/src/requests/shops.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/translations.dart';
import 'package:instamarket/src/widgets/effects/shop_effect.dart';

class Shops extends StatefulWidget {
  final List<Address> addresses;

  Shops({this.addresses});

  @override
  ShopsState createState() => ShopsState();
}

class ShopsState extends State<Shops> {
  int tabIndex = 0;
  LocationLib.Location location = new LocationLib.Location();
  bool serviceEnabled;
  LocationLib.PermissionStatus permissionGranted;
  LocationLib.LocationData locationData;
  String address = "";
  double latitude;
  double longitude;
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    getAddresses();
  }

  void getAddresses() {
    int countAddress = widget.addresses != null ? widget.addresses.length : 0;

    if (countAddress == 0) {
      getLocationInfo();
    } else {
      int index =
          widget.addresses.indexWhere((element) => element.isDefault == true);

      setState(() {
        if (index > -1) {
          address = widget.addresses[index].address;
        } else {
          address = widget.addresses[0].address;
        }
      });
    }
  }

  void getLocationInfo() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        await locationWithoutPermission();
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == LocationLib.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != LocationLib.PermissionStatus.granted) {
        await locationWithoutPermission();
        return;
      }
    }

    locationData = await location.getLocation();
    double latitude = locationData.latitude;
    double longitude = locationData.longitude;
    String address = await getPlaceNames(latitude, longitude);

    context.read<AddressNotifier>().addAddress(address, latitude, longitude);
  }

  Future<String> getPlaceNames(double latitude, double longitude) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(
            latitude, longitude,
            localeIdentifier: 'en')
        .catchError((error) {
      print(error);
    });

    String placeName = "";
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];

      if (pos.subThoroughfare.length > 1)
        placeName = pos.subThoroughfare + ", ";
      if (pos.thoroughfare.length > 1)
        placeName = placeName + ", " + pos.thoroughfare;
      if (pos.subAdministrativeArea.length > 1)
        placeName = placeName + ", " + pos.subAdministrativeArea;
      if (pos.administrativeArea.length > 1)
        placeName = placeName + ", " + pos.administrativeArea;
      if (pos.subLocality.length > 1)
        placeName = placeName + ", " + pos.subLocality;
      if (pos.locality.length > 1) placeName = placeName + ", " + pos.locality;
    }

    if (mounted)
      setState(() {
        address = placeName;
      });

    return placeName;
  }

  Future<Map<String, dynamic>> getShops() async {
    Map<String, dynamic> shopsData = await shopsRequest(latitude, longitude);

    if (mounted)
      setState(() {
        data = shopsData['data'];
      });

    return shopsData['data'] != null ? shopsData['data'] : {};
  }

  Widget renderSavedShops() {
    List<Shop> shops = context.watch<ShopNotifier>().shops;

    return Container(
        child: Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 0.05.sw,
          ),
          child: Text(
            Translations.of(context).text('saved_shops'),
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
        Column(
            children: shops.map((item) {
          if (tabIndex == 0 && item.deliveryType == 2) return Container();
          if (tabIndex == 1 && item.deliveryType == 1) return Container();

          return ShopPanel(
            name: item.name,
            description: item.description,
            logoUrl: item.logoUrl,
            openHours: item.openHour,
            closeHours: item.closeHour,
            id: item.id,
            backImageUrl: item.backImageUrl,
            deliveryType: item.deliveryType,
            address: item.address,
            lat: item.lat,
            lng: item.lng,
            info: item.info,
            deliveryPrice: item.deliveryPrice,
            tax: item.tax,
          );
        }).toList())
      ],
    ));
  }

  Widget renderAllShops() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 0.05.sw,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Translations.of(context).text('all_shops'),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  if (data != null && data.length > 0)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/ShopsMap',
                            arguments: {
                              "data": tabIndex == 0
                                  ? data['deliveryShops']
                                  : data['pickupShops']
                            });
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(0)),
                      ),
                      child: Text(
                        Translations.of(context).text('view_on_map'),
                        style: TextStyle(
                            color: Color.fromRGBO(33, 160, 54, 1),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                ],
              )),
          FutureBuilder<Map<String, dynamic>>(
            future: getShops(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> shopData = snapshot.data ?? [];
                List deliveryShops = shopData['deliveryShops'];
                List pickupShops = shopData['pickupShops'];
                List data = tabIndex == 0 ? deliveryShops : pickupShops;

                return Column(
                    children: data.map((item) {
                  return ShopPanel(
                    name: item['lang'][0]['name'],
                    description: item['lang'][0]['description'],
                    logoUrl: item['logo_url'],
                    openHours: item['open_hour'],
                    closeHours: item['close_hour'],
                    id: item['id'],
                    backImageUrl: item['backimage_url'],
                    deliveryType: item['delivery_type'],
                    address: item['lang'][0]['address'],
                    lat: double.parse(item['latitude'].toString()),
                    lng: double.parse(item['longtitude'].toString()),
                    showType: item['show_type'],
                    info: item['lang'][0]['info'],
                    deliveryPrice:
                        double.parse(item['delivery_price'].toString()),
                    tax: double.parse(item['tax'].toString()),
                  );
                }).toList());
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Column(
                children: <Widget>[
                  ShopEffect(),
                  ShopEffect(),
                  ShopEffect(),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Shop> shops = context.watch<ShopNotifier>().shops;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(33, 160, 54, 1),
          title: Text(
            Translations.of(context).text('choose_shop'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              color: Theme.of(context).buttonColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: shops.length > 0
              ? TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    LineIcons.doorClosed,
                    size: 24.sp,
                    color: Theme.of(context).buttonColor,
                  ),
                )
              : null,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Container(
              width: 1.sw,
              decoration: BoxDecoration(
                color: Color.fromRGBO(33, 160, 54, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Translations.of(context).text('delivery_address'),
                    style: TextStyle(
                        color: Theme.of(context).buttonColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  Container(
                      width: 0.8.sw,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).buttonColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/UserLocationList', arguments: {
                          "onGoBack": () {
                            Address defaultAddress = context
                                .read<AddressNotifier>()
                                .getDefaultAddress();
                            setState(() {
                              address = defaultAddress.address;
                            });
                          }
                        });
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(0)),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).buttonColor,
                            )),
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              child: Icon(LineIcons.mapMarker,
                                  size: 16.sp,
                                  color: Theme.of(context).buttonColor),
                            ),
                            Text(
                              Translations.of(context).text('change'),
                              style: TextStyle(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[renderSavedShops(), renderAllShops()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).buttonColor,
          unselectedItemColor: Theme.of(context).buttonColor.withOpacity(0.5),
          backgroundColor: Color.fromRGBO(33, 160, 54, 1),
          currentIndex: tabIndex,
          onTap: (int index) {
            setState(() {
              tabIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.delivery_dining,
                size: 30.sp,
              ),
              label: Translations.of(context).text('delivery'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_basket,
                size: 30.sp,
              ),
              label: Translations.of(context).text('pickup'),
            )
          ]),
    );
  }
}
