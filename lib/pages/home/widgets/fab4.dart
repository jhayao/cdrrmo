
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

import '../../test2.dart';
class BuildFab4 extends StatefulWidget {
  const BuildFab4({Key? key}) : super(key: key);

  @override
  _BuildFab4State createState() => _BuildFab4State();
}

class _BuildFab4State extends State<BuildFab4> {

  bool validLocation = false;
  Position ? _currentPosition;
  String ? _currentAddress;
  String ? City;
  String ? address;
  String ? userType,name,phone;
  late String UID;





  @override
  void initState() {
    super.initState();

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Sizes.fabSizedBox,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "New Event",
                        style: TextStyle(
                            color: kBlack54,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),
                  SizedBox(height: PaddingConstant.kPadding,),
                  _buildCategory(
                      category: "New Event",
                      iconData: IconsConstants.instance.iconAdd,
                      color: kBlue,
                      type: "road"
                  ),

                  // 6 Categories
                  SizedBox(height: Sizes.fabSizedBox),
                ],
              ),
            ),
          ),
        );
      },
      backgroundColor: Colors.white,
      child: Icon(
        IconsConstants.instance.iconAdd,
        color: kBlue,
      ),
    );
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                CreateProfile(title: 'testing nko ni')),
          ) ;
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
