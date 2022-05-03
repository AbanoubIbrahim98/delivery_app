import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/theme/map_dark_theme.dart';
import 'package:instamarket/theme/map_light_theme.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AddressNotifier.dart';
import 'package:instamarket/src/notifier/SettingsNotifier.dart';
import 'package:instamarket/translations.dart';

class UserLocation extends StatefulWidget {
  final String address;
  final double latitude;
  final double longitude;
  final Function onGoBack;

  UserLocation({this.address, this.latitude, this.longitude, this.onGoBack});

  @override
  UserLocationState createState() => UserLocationState();
}

class UserLocationState extends State<UserLocation> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  bool isConfirmed = false;
  String address = "";
  double latitude = 37.42796133580664;
  double longitude = -122.085749655962;
  bool isCurrentPosSearch = false;

  @override
  void initState() {
    super.initState();

    if (widget.address != null)
      setState(() {
        address = widget.address;
        latitude = widget.latitude;
        longitude = widget.longitude;
      });
  }

  void changeLocation(String placeName) async {
    List<Location> location =
        await locationFromAddress(placeName, localeIdentifier: 'en');
    double lat = location[0].latitude;
    double long = location[0].longitude;

    MarkerId _markerId = MarkerId('marker_id_0');
    Marker _marker = Marker(
      markerId: _markerId,
      position: LatLng(lat, long),
      draggable: false,
    );

    setState(() {
      isCurrentPosSearch = true;
      _markers[_markerId] = _marker;
      latitude = lat;
      longitude = long;
    });

    getPlaceNames(latitude, longitude);
    goNewPosition(latitude, longitude);
  }

  Future<void> getPlaceNames(double latitude, double longitude) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude, longitude,
        localeIdentifier: 'en');

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];

      List<String> addressList = [];
      addressList.add(pos.locality);
      addressList.add(pos.subLocality);
      addressList.add(pos.thoroughfare);
      addressList.add(pos.name);

      String placeName = addressList.join(", ");

      if (mounted)
        setState(() {
          address = placeName;
        });
    }
  }

  Future<void> goNewPosition(double lat, double lon) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lon), zoom: 14)));
  }

  Future _setMapStyle(int mode) async {
    final controller = await _controller.future;
    if (mode == 1)
      controller.setMapStyle(json.encode(MAP_DARK_THEME));
    else
      controller.setMapStyle(json.encode(MAP_LIGHT_THEME));
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
              Translations.of(context).text('search_location'),
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16.sp),
            ),
            bottom: isConfirmed
                ? PreferredSize(
                    preferredSize: Size.fromHeight(0),
                    child: Container(),
                  )
                : PreferredSize(
                    preferredSize: Size.fromHeight(60),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/UserLocationSearch', arguments: {
                          "onComplete": (text) {
                            changeLocation(text);
                          }
                        });
                      },
                      child: Container(
                          width: 0.8.sw,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1)),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  LineIcons.search,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5),
                                  size: 20.sp,
                                ),
                              ),
                              Text(
                                Translations.of(context).text('type_something'),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5)),
                              )
                            ],
                          )),
                    )),
            elevation: 0,
            backgroundColor: Theme.of(context).buttonColor),
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
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            padding: EdgeInsets.only(top: 0.6.sh),
            onCameraIdle: () {
              if (isCurrentPosSearch)
                setState(() {
                  isCurrentPosSearch = false;
                });
            },
            onTap: (LatLng point) {
              MarkerId _markerId = MarkerId('marker_id_0');
              Marker _marker = _markers[_markerId];
              Marker _updatedMarker = _marker.copyWith(
                positionParam: point,
              );

              setState(() {
                _markers[_markerId] = _updatedMarker;
                latitude = point.latitude;
                longitude = point.longitude;
              });

              getPlaceNames(point.latitude, point.longitude);
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              if (!isCurrentPosSearch) {
                MarkerId _markerId = MarkerId('marker_id_0');
                Marker _marker = Marker(
                  markerId: _markerId,
                  position: LatLng(latitude, longitude),
                  draggable: false,
                );

                setState(() {
                  _markers[_markerId] = _marker;
                });
              }

              int mode =
                  Provider.of<SettingsNotifier>(context, listen: false).mode;
              this._setMapStyle(mode);
            },
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: 1.sw,
                padding:
                    EdgeInsets.only(left: 40, right: 40, bottom: 60, top: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Theme.of(context).buttonColor,
                        Theme.of(context).buttonColor.withOpacity(0.0),
                      ],
                      stops: [
                        0.3,
                        0.8
                      ]),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        address,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isConfirmed = false;
                          });
                        },
                        child: Text(
                          Translations.of(context).text('change'),
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
          Positioned(
            bottom: 20,
            left: 0.1.sw,
            right: 0.1.sw,
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    Translations.of(context)
                        .text('to_map_to_select_new_location'),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 12.sp),
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                ),
                CustomButton(
                  title: Translations.of(context).text('comfirm_location'),
                  onClick: () async {
                    print(address);
                    print(latitude);
                    print(longitude);
                    context
                        .read<AddressNotifier>()
                        .addAddress(address, latitude, longitude);
                    widget.onGoBack();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          )
        ]));
  }
}
