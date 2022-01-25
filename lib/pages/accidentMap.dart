import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:medicare/main.dart';
import 'package:medicare/services/database.dart';
import 'package:medicare/services/notifcation.dart';
import 'package:provider/provider.dart';

import '../drawer.dart';





class AccidentMap extends StatefulWidget {
  AccidentMap({Key? key, required this.title, required this.lat, required this.long}) : super(key: key);
  final String title;
  final String lat;
  final String long;

  @override
  _AccidentMapState createState() => _AccidentMapState();
}

class _AccidentMapState extends State<AccidentMap> {
  late Marker marker;
  late Circle circle;
  late GoogleMapController _controller;
  late String userType;
  late String UID;
  late String name;
  late String phone;
  int _counter = 0;
  LatLng currentLocation = LatLng(8.492826583455019, 123.79811198204233);
  bool validLocation = false;
  CameraPosition initialLocation = CameraPosition(
    target: LatLng(8.492826583455019, 123.79811198204233),
    zoom: 14.4746,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  void initState() {
    super.initState();
    NotificationApi.init();
    marker = Marker(
        markerId: MarkerId("home"),
        position: LatLng(37.42796133580664, -122.085749655962),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
    circle = Circle(
        circleId: CircleId("car"),
        zIndex: 1,
        radius: 50,
        strokeColor: Colors.blue,
        center: LatLng(37.42796133580664, -122.085749655962),
        fillColor: Colors.blue.withAlpha(70));
    currentLocation = LatLng(double.parse(widget.lat),double.parse(widget.long));
    initialLocation = CameraPosition(
      target: currentLocation,
      zoom: 18,
    );
    marker = Marker(
        markerId: MarkerId("home"),
        position: currentLocation,

        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
  }



  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/img/cars.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List  imageData) {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    this.setState(() {
      validLocation=true;
      currentLocation = latlng;
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading!,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy!,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }



  @override
  void dispose() {

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE37C54),
        title: Text('Map'),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: initialLocation,
        markers: Set.of((marker != null) ? [marker] : []),
        circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      drawer: getDrawer(context),
    );
  }


}
