
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicare/constants/icons_constants.dart';
import 'package:medicare/constants/padding_constant.dart';
import 'package:medicare/constants/sizes_constants.dart';
import 'package:medicare/constants/theme.dart';
import 'package:medicare/services/database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
class BuildFab extends StatefulWidget {
  const BuildFab({Key? key}) : super(key: key);

  @override
  _BuildFabState createState() => _BuildFabState();
}

class _BuildFabState extends State<BuildFab> {

  bool validLocation = false;
  Position ? _currentPosition;
  String ? _currentAddress;
  String ? City;
  String ? address;
  String ? userType,name,phone;
  late String UID;

   _getCurrentLocation() async {
     await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true).then((x) {
        setState(() {
          _currentPosition = x;
          validLocation = true;
        });
      });
  }

  _getAddressFromLatLng() async {
    try {

      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.country}  ";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getdata();
    _getCurrentLocation();
    //running initialisation code; getting prefs etc.
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Padding(
            padding: PaddingConstant.instance.kFabPadding,
            child: SingleChildScrollView(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Sizes.fabSizedBox,
                  ),
                  Text(
                    "Report Accident",
                    style: TextStyle(color: kBlack54),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Category",
                        style: TextStyle(
                            color: kBlack54,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),
                  SizedBox(height: PaddingConstant.kPadding,),
                  _buildCategory(
                    category: "Road Accident",
                    iconData: IconsConstants.instance.iconBook,
                    color: kBlue,
                    type: "road"
                  ),
                  _buildCategory(
                    category: "Fire Accident",
                    iconData: IconsConstants.instance.iconSportsEsports,
                    color: kDeepOrange,
                    type: "fire"
                  ),
                  _buildCategory(
                    category: "Natural Disaster",
                    iconData: IconsConstants.instance.iconMovie,
                    color: kBlue,
                      type: "natural"
                  ),
                  _buildCategory(
                    category: "Work Accidents",
                    iconData: IconsConstants.instance.iconStore,
                    color: kCyan,
                      type: "work"
                  ),
                  _buildCategory(
                    category: "Sports Accidents",
                    iconData: IconsConstants.instance.iconHealing,
                    color: kYellow.shade700,
                      type: "sports"
                  ),
                  _buildCategory(
                    category: "Other Accidents",
                    iconData: IconsConstants.instance.iconBasketball,
                    color: kRed,
                      type: "other"
                  ),
                  // 6 Categories
                  SizedBox(height: Sizes.fabSizedBox),
                ],
              )
            ),
          ),
        );
      },
      backgroundColor: Colors.white,
      child: Icon(
        IconsConstants.instance.iconList,
        color: kBlue,
      ),
    );
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
  void seekHelp(String type) async {

    try {
      validLocation = true;
      if (validLocation) {
        await DatabaseService(uid: UID).newAccident(
            name!, "8.49844119320666", "123.78687790044694", phone!, type);
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
      else {
        Fluttertoast.showToast(
            msg: "Can't locate your location\n Locating Please wait",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.transparent,
            textColor: Colors.black,
            fontSize: 16.0
        );
      }
    }
    on Exception catch(e){
      Fluttertoast.showToast(
          msg: "Can't locate your location ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.transparent,
          textColor: Colors.black,
          fontSize: 16.0
      );
    }
  }

  Widget _buildCategory({
    required String category,
    required IconData iconData,
    required Color color,
    required String  type,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: PaddingConstant.kPadding,
      ),
      child: InkWell(
        onTap: () async {
          seekHelp(type);
            
        },
        borderRadius: BorderRadius.circular(Sizes.borderMidRadius),
        child: Container(
          width: Sizes.infinity,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 2 * PaddingConstant.kPadding,
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(
                  iconData,
                  color: kWhiteColor,
                ),
              ),
              Text(
                category,
                style: categoryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
