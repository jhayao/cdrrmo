

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicare/drawer.dart';
import 'package:medicare/models/directionsModel.dart';
import 'package:medicare/services/database.dart';
import 'package:medicare/services/direction.dart';

class MyLocation extends StatefulWidget {
  final String? lat;
  final String? long;
  final String? docID;
  final String? phone;

  const MyLocation({Key? key, this.lat, this.long,  this.docID, this.phone}) : super(key: key);

  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  Location location = new Location();
  late StreamSubscription _locationSubscription;
  LatLng myLocation = LatLng(8.486581156904204, 123.7740111350538);
  late GoogleMapController _googleMapController;
  LatLng currentLatLng = LatLng(8.490408, 123.797419);
  late BitmapDescriptor customIcon;
  bool validDestination = false;
  bool validLocation = false;
  Directions ? _info;
  String userType='user';
  late String UID;
  late String name;
  late String phone;
  bool near = false;
  late List<String> totalDistance;
  bool onLocation = false;
   Marker marker = Marker(
       markerId: MarkerId("cddrmo"),
       infoWindow:  InfoWindow(title: 'My Location'),
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
       position: LatLng(8.490408, 123.797419)
   );
  LatLng testLocation = LatLng(8.493122711023606, 123.7888861133422);
  Marker ? _destination ;


  @override
  void initState() {
    // TODO: implement initState
    // setCustomMarker();
    super.initState();
    setDestination();
    _getdata();
    locationPermission();
    getLocation();
    directions();
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/img/arrow.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List  imageData) async {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    this.setState(() {
      validLocation=true;
      currentLatLng = latlng;
      marker = Marker(
          markerId: MarkerId("cddrmo"),
          position: latlng,
          rotation: newLocalData.heading!,
          draggable: false,
          zIndex: 2,
          flat: false,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
    });
    if(validDestination){
      final directions = await DirectionService(dio: null)
          .getDirections(origin: marker.position, destination: testLocation);
      setState(() => _info = directions);
    }
  }
  void setDestination(){
    if(widget.lat != null && widget.long!=null)
      {
        validDestination = true;
        testLocation = LatLng(double.parse(widget.lat!),double.parse(widget.long!));
        _destination = Marker(
            markerId:  MarkerId('destination'),
            infoWindow:  InfoWindow(title: 'My Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: testLocation
        );
      }

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

  void seekHelp() async {

    if(validLocation){
      await DatabaseService(uid: UID).newAccident(name, currentLatLng.latitude.toString(),currentLatLng.longitude.toString(),phone,'');
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

  void directions() async{
    if(validDestination) {
      _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(new CameraPosition(
            // bearing: currentLatLng.heading!,
              target: LatLng(currentLatLng.latitude!, currentLatLng.longitude!),
              tilt: 80,
              zoom: 18.00)));
      final directions = await DirectionService(dio: null)
          .getDirections(origin: marker.position, destination: testLocation);
      setState(() => _info = directions);
    }
  }
  void getLocation() async
  {
      // print("Locatio")
      Uint8List imageData = await getMarker();
      var currentLocation = await location.getLocation();
      print("CURRENT LOCATION:" + currentLocation.toString());
      setState(() {
        currentLatLng = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        validLocation=true;
        marker = Marker(
            markerId: MarkerId("cddrmo"),
            position: currentLatLng,
            // rotation: currentLatLng.heading!,
            draggable: false,
            zIndex: 2,
            flat: false,
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
        _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(target: currentLatLng,zoom:18)));
        if(userType == 'admin' && validDestination)
        _locationSubscription = location.onLocationChanged.listen((newLocalData) async {
          if (_googleMapController != null) {
            _googleMapController.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
                bearing: newLocalData.heading!,
                target: LatLng(newLocalData.latitude!, newLocalData.longitude!),
                tilt: 80,
                zoom: 18.00)));
            updateMarkerAndCircle(newLocalData, imageData);
            totalDistance = _info!.totalDistance!.split(" ");
            print("Total Distance" + totalDistance!.toString());
            double distance = double.parse(totalDistance.first);
            String meter = totalDistance.last;
            if(((distance <= 500 && meter == "m") || (distance <= 0.5 && meter == "km")) && !near){
                print('near');
                near = true;
                await DatabaseService(uid: UID)
                  .editAccident2(widget.docID!,widget.phone!);
            }
            else if(((distance <= 100 && meter == "m") || (distance <= 0.1 && meter == "km")) && !onLocation ){
              onLocation =true;
              await DatabaseService(uid: UID)
                  .editAccident3(widget.docID!,widget.phone!);
            }
            else
              {
                print('on the way');
              }
            print("Distance: " + distance.toString());
            if(_info!.totalDuration == "5 min" && !near)
            {
              near = true;
              print("Near");
              // await DatabaseService(uid: UID)
              //     .editAccident2(widget.docID!);
            }
            if (_info!.totalDistance == "20 m" && !onLocation)
            {
              // await DatabaseService(uid: UID)
              //     .editAccident3(widget.docID!);

            }
          }
        });

      });
  }


  void locationPermission() async{
    var serviceEnable = await location.serviceEnabled();
    if(!serviceEnable){
      serviceEnable = await location.requestService();
      if(!serviceEnable){
        return;
      }
    }
    var _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied)
      {
        _permissionGranted = await location.requestPermission();
      }
    if(_permissionGranted == PermissionStatus.granted)
    {
      return;
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context)  {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE37C54),
        title: Text('Ambulance'),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            mapType: MapType.hybrid,
            zoomControlsEnabled: false,

              initialCameraPosition: CameraPosition(
                    target: currentLatLng,
                    zoom: 16
                  ),
            onMapCreated: (controller) => _googleMapController = controller,
            // cameraTargetBounds:  CameraTargetBounds(getCurrentBounds(currentLatLng, LatLng(double.parse(widget.lat!),double.parse(widget.long!)))),
            markers: Set.of((marker != null) ? [marker,if(validDestination)
                  _destination!] : []),
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            // onLongPress: _addMarker,
          ),
          if (_info != null)

            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          // if (_info != null)
            // Positioned(
            //   bottom: 20.0,
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(
            //       vertical: 6.0,
            //       horizontal: 12.0,
            //     ),
            //
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         primary: Colors.red, // background
            //         onPrimary: Colors.white, // foreground
            //       ),
            //       onPressed: () { },
            //       child: Text('Disable Camera Animation'),
            //     )
            //   ),
            // ),
        ],
      ),
      floatingActionButton:  SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0,
        children: [
          SpeedDialChild(
              child: Icon(Icons.center_focus_strong),
              label: "My Location",
              backgroundColor: Colors.blue,
              onTap: ()=> getLocation(),
          ),
          if(userType == 'user')
          SpeedDialChild(
            child: Icon(Icons.report),
            label: "Seek Help",
            backgroundColor: Colors.red,
            onTap: ()=> seekHelp(),
          ),
          // if(validDestination)
          // SpeedDialChild(
          //     child: Icon(Icons.report),
          //     label: "Directions",
          //     backgroundColor: Colors.red,
          //   onTap: () async{
          //
          //       if(validDestination){
          //         final directions = await DirectionService(dio: null)
          //             .getDirections(origin: _origin.position, destination: testLocation);
          //         setState(() => _info = directions);
          //       }
          //   }
          // )
        ],
      ),


      // drawer: getDrawer(context),

    );
  }

}
