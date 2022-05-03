import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/theme/map_dark_theme.dart';
import 'package:instamarket/theme/map_light_theme.dart';
import 'package:instamarket/src/config/global_config.dart';
import 'package:instamarket/src/notifier/SettingsNotifier.dart';
import 'package:instamarket/translations.dart';

class ShopsMap extends StatefulWidget {
  final List data;

  ShopsMap({this.data});

  @override
  ShopsMapState createState() => ShopsMapState();
}

class ShopsMapState extends State<ShopsMap> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  double latitude = 37.42796133580664;
  double longitude = -122.085749655962;
  BitmapDescriptor pinLocationIcon;

  Future _setMapStyle(int mode) async {
    final controller = await _controller.future;
    if (mode == 1)
      controller.setMapStyle(json.encode(MAP_DARK_THEME));
    else
      controller.setMapStyle(json.encode(MAP_LIGHT_THEME));
  }

  @override
  void initState() {
    super.initState();

    setCustomMapPin();

    if (widget.data.length > 0 && mounted)
      setState(() {
        latitude = double.parse(widget.data[0]['latitude'].toString());
        longitude = double.parse(widget.data[0]['longtitude'].toString());
      });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'lib/assets/images/store.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            Translations.of(context).text('shops_in_map'),
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 16.sp),
          ),
          backgroundColor: Theme.of(context).buttonColor,
        ),
        extendBody: true,
        body: Stack(children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            compassEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 14,
            ),
            markers: Set<Marker>.of(_markers.values),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              if (widget.data.length > 0)
                for (int i = 0; i < widget.data.length; i++) {
                  Map<String, dynamic> item = widget.data[i];
                  MarkerId _markerId = MarkerId('marker_id_${item["id"]}');
                  Marker _marker = Marker(
                      markerId: _markerId,
                      position: LatLng(
                          double.parse(item['latitude'].toString()),
                          double.parse(item['longtitude'].toString())),
                      draggable: false,
                      infoWindow: InfoWindow(
                        title: item['lang'][0]['name'],
                        snippet: item['lang'][0]['address'],
                      ),
                      icon: pinLocationIcon);

                  setState(() {
                    _markers[_markerId] = _marker;
                  });
                }

              int mode =
                  Provider.of<SettingsNotifier>(context, listen: false).mode;
              this._setMapStyle(mode);
            },
            zoomControlsEnabled: false,
          ),
          Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                  height: 240,
                  width: 1.sw,
                  child: new ListView.builder(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 10, top: 10, bottom: 10),
                    itemCount: widget.data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctxt, int index) {
                      Map<String, dynamic> item = widget.data[index];
                      print(item);

                      return InkWell(
                        onTap: () {},
                        child: Container(
                          width: 180,
                          height: 200,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(1, 1),
                                )
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).buttonColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 180,
                                height: 80,
                                child: Image.network(
                                  "$GLOBAL_URL${item['logo_url']}",
                                ),
                              ),
                              Container(
                                width: 170,
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  item['lang'][0]['name'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                width: 170,
                                child: Text(
                                  item['delivery_type'] == 3
                                      ? "#${Translations.of(context).text('delivery')} #${Translations.of(context).text('pickup')}"
                                      : (item['delivery_type'] == 1
                                          ? "#${Translations.of(context).text('delivery')}"
                                          : "#${Translations.of(context).text('pickup')}"),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 248, 132, 98)),
                                ),
                              ),
                              Container(
                                width: 170,
                                child: Text(
                                  item['lang'][0]['address'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.6)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )))
        ]));
  }
}
