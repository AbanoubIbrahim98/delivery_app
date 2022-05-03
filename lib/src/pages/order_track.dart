import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderTrack extends StatefulWidget {
  final double originLatitude;
  final double originLongitude;
  final double destLatitude;
  final double destLongitude;

  OrderTrack(
      {this.originLatitude,
      this.destLatitude,
      this.originLongitude,
      this.destLongitude});

  @override
  OrderTrackState createState() => OrderTrackState();
}

class OrderTrackState extends State<OrderTrack> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double distance = 0;

  double _originLatitude = 37.32796133580664,
      _originLongitude = -122.015749655962;
  double _destLatitude = 37.28796133580664, _destLongitude = -121.825749655962;

  @override
  void initState() {
    super.initState();

    setState(() {
      _originLatitude = widget.originLatitude;
      _originLongitude = widget.originLongitude;
      _destLatitude = widget.destLatitude;
      _destLongitude = widget.destLongitude;
    });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.green, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyAIZAHqq0Gpw0yNcq6LgsQd9EAGpee5sMg",
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        int index = result.points.indexWhere((element) => element == point);
        if (index + 1 < result.points.length) {
          double d = distance;
          PointLatLng nextPoint = result.points[index + 1];
          double nd = calcCrow(point.latitude, point.longitude,
              nextPoint.latitude, nextPoint.longitude);
          d = d + nd;
          setState(() {
            distance = d;
          });
        }
      });
    }
    _addPolyLine();
  }

  double calcCrow(
      double latitude1, double lon1, double latitude2, double lon2) {
    double R = 6371;
    double dLat = toRad((latitude2 - latitude1));
    double dLon = toRad(lon2 - lon1);
    double lat1 = toRad(latitude1);
    double lat2 = toRad(latitude2);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) *
            math.sin(dLon / 2) *
            math.cos(lat1) *
            math.cos(lat2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double d = R * c;
    return d;
  }

  double toRad(double value) {
    return value * math.pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(_originLatitude, _originLongitude),
              zoom: 10,
            ),
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            zoomGesturesEnabled: true,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (GoogleMapController controller) {
              _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
                  BitmapDescriptor.defaultMarker);
              _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
                  BitmapDescriptor.defaultMarkerWithHue(90));
              _getPolyline();

              _controller.complete(controller);
            }),
        Positioned(
          top: 40,
          left: 30,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 3,
                      spreadRadius: 0,
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      offset: Offset(0, 0))
                ],
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(25)),
            child: BackButton(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 30,
          child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        blurRadius: 3,
                        spreadRadius: 0,
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        offset: Offset(0, 0))
                  ],
                  color: Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.circular(25)),
              child: IconButton(
                onPressed: () async {
                  String url =
                      'https://www.google.com/maps/dir/?api=1&origin=$_originLatitude,$_originLongitude&destination=$_destLatitude,$_destLongitude&travelmode=car';
                  await canLaunch(url)
                      ? await launch(url)
                      : throw 'Could not launch $url';
                },
                icon: Icon(
                  Icons.directions_car,
                  color: Theme.of(context).primaryColor,
                ),
              )),
        )
      ]),
      extendBody: true,
      bottomNavigationBar: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "${distance.toStringAsFixed(2)} KM",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
