import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:medicare/services/database.dart';
import 'package:medicare/services/notifcation.dart';
import 'package:provider/provider.dart';

import 'drawer.dart';
import 'models/userModel.dart';



class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, this.lat,this.long}) : super(key: key);
  final String title;
  final String? lat;
  final String? long;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  late Marker marker;
  late Circle circle;
  late GoogleMapController _controller;
  late String userType;
  late String UID;
  late String name;
  late String phone;
  List<LatLng> polylineCoordinates = [];
  LatLng currentLocation = LatLng(8.492826583455019, 123.79811198204233);
  bool validLocation = false;
  late PolylinePoints polylinePoints;
  Set<Polyline> _polylines = Set<Polyline>();
  final Set<Marker> markers = new Set(); //markers for google map
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(8.492826583455019, 123.79811198204233),
    zoom: 14.4746,
  );
  void initState() {
    _getdata();
    super.initState();
    polylinePoints = PolylinePoints();


  }
  void setPolylines() async {
    if (widget.lat!=null && widget.long!=null)
      {
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
            "AIzaSyAGBP-BhJHeX5mj_uJD3qLp1R3V9uIh7q4",
            PointLatLng(
                currentLocation.latitude,
                currentLocation.longitude
            ),
            PointLatLng(
                double.parse(widget.lat!),
                double.parse(widget.long!)
            )
        );

        if (result.status == 'OK') {
          result.points.forEach((PointLatLng point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });

          setState(() {
            _polylines.add(
                Polyline(
                    width: 10,
                    polylineId: PolylineId('polyLine'),
                    color: Color(0xFF08A5CB),
                    points: polylineCoordinates
                )
            );
          });
        }
      }

  }
  Set<Marker> getmarkers() { //markers to place on map
    setState(() {
      markers.add(Marker(
          markerId: MarkerId("cddrmo"),
          position: currentLocation,
          draggable: false,
          zIndex: 2,
          // flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
      if(widget.lat!=null && widget.long!=null){
        markers.add(Marker( //add second marker
          markerId: MarkerId('accident'),
          position: LatLng(double.parse(widget.lat!), double.parse(widget.long!)), //position of marker
          infoWindow: InfoWindow( //popup info
            title: 'Marker Title Second ',
            snippet: 'My Custom Subtitle',
          ),
          icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        ));
      }//add more markers here
    });

    return markers;
  }
  void _getdata() async {
    User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('userDetails')
        .doc(user.uid)
        .snapshots()
        .listen((userData) {
        // print("USERDATA" + userData['userType']);
        setState(() {
          userType = userData['userType'];
          UID = user.uid;
          name = userData['name'];
          phone = userData['phone'];
        });
    }
    );
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
          markerId: MarkerId("cddrmo"),
          position: latlng,
          rotation: newLocalData.heading!,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));

    });
  }

  void getCurrentLocation() async {
    try {

      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      updateMarkerAndCircle(location, imageData);
      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(newLocalData.latitude!, newLocalData.longitude!),
            tilt: 0,
            zoom: 18.00)));
        updateMarkerAndCircle(newLocalData, imageData);
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void seekHelp() async {

    if(validLocation){
      await DatabaseService(uid: UID).newAccident(name, currentLocation.latitude.toString(),currentLocation.longitude.toString(),phone,'');
      Fluttertoast.showToast(
          msg: "Officials have been notified",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.transparent,
          textColor: Colors.black,
          fontSize: 16.0
      );
    }
    else{
      Fluttertoast.showToast(
          msg: "Can't locate your location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
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
        markers: getmarkers(),
        // circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: userType!='admin'? SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0,
        children: [
          SpeedDialChild(
            child: Icon(Icons.center_focus_strong),
            label: "My Location",
            backgroundColor: Colors.blue,
            onTap: ()=> getCurrentLocation(),
          ),
          SpeedDialChild(
            child: Icon(Icons.report),
            label: "Seek Help",
            backgroundColor: Colors.red,
            onTap: ()=> seekHelp(),
          ),

        ],
      ):  FloatingActionButton(
        onPressed: ()=> getCurrentLocation(),
        child: const Icon(Icons.zoom_out_map),
        backgroundColor: Colors.green,
      ),
      drawer: getDrawer(context),
    );
  }


}
