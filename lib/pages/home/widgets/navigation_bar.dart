
import 'package:flutter/material.dart';
import 'package:medicare/constants/icons_constants.dart';
import 'package:medicare/constants/padding_constant.dart';
import 'package:medicare/icons/icons.dart';
import 'package:medicare/pages/home/home_page.dart';

import '../accident_page.dart';
import '../event_page.dart';
import '../profile_page.dart';


Widget buildNavigationBar(BuildContext context) {


  return BottomAppBar(
  shape: CircularNotchedRectangle(),
  notchMargin: 8.0,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: PaddingConstant.instance.kLeftPadding/3,
        child: IconButton(onPressed: (){
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
          var newRouteName = "/home";
          bool isNewRouteSameAsCurrent = false;
          Navigator.popUntil(context, (route) {
            print("Test Route " + route.settings.name.toString());

            if (route.settings.name == newRouteName) {
              isNewRouteSameAsCurrent = true;
            }
            print("New Router : $isNewRouteSameAsCurrent");
            return true;
          });
          if (!isNewRouteSameAsCurrent) {

            Navigator.pushReplacementNamed(context, newRouteName);
          }
          // Navigator.pushReplacementNamed(context, '/home');
        }, icon: Icon(
          MyFlutterApp.home,
        )),
      ),
      Padding(
        padding: PaddingConstant.instance.kRightPadding/2,
        child: IconButton(onPressed: (){
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Accidents()));
          // Navigator.pushReplacementNamed(context, '/accident');
          var newRouteName = "/accident";
          bool isNewRouteSameAsCurrent = false;
          Navigator.popUntil(context, (route) {
            print("Test Route" + route.settings.name.toString());
            if (route.settings.name == newRouteName) {
              isNewRouteSameAsCurrent = true;
            }
            print("New Router : $isNewRouteSameAsCurrent");
            return true;
          });
          if (!isNewRouteSameAsCurrent) {

            Navigator.pushReplacementNamed(context, newRouteName);
          }
        }, icon: Icon(
          MyFlutterApp.hospital,
        )),
      ),
      Padding(
        padding: PaddingConstant.instance.kLeftPadding/2,
        child: IconButton(onPressed: (){
          bool isNewRouteSameAsCurrent = false;
          var newRouteName = "/event";
          Navigator.popUntil(context, (route) {
            if (route.settings.name == newRouteName) {
              isNewRouteSameAsCurrent = true;
            }
            print("New Router : $isNewRouteSameAsCurrent");
            return true;
          });
          if (!isNewRouteSameAsCurrent) {
            isNewRouteSameAsCurrent = !isNewRouteSameAsCurrent ;
            Navigator.pushReplacementNamed(context, newRouteName);
          }
          print("New Router : $isNewRouteSameAsCurrent");
        }, icon: Icon(
          MyFlutterApp.doctor,
        )),
      ),
      Padding(
        padding: PaddingConstant.instance.kRightPadding/3,
        child: IconButton(onPressed: (){
          bool isNewRouteSameAsCurrent = false;
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
          // Navigator.pushReplacementNamed(context, '/profile');
          var newRouteName = "/profile";
          Navigator.popUntil(context, (route) {
            print("Test Route" + route.settings.name.toString());
            if (route.settings.name == newRouteName) {
              isNewRouteSameAsCurrent = true;
            }
            print("New Router : $isNewRouteSameAsCurrent");

            return true;
          });
          if (!isNewRouteSameAsCurrent) {

            Navigator.pushReplacementNamed(context, newRouteName);
          }
        }, icon: Icon(
          Icons.people,
        )),
      ),
    ],
  ),
);
}