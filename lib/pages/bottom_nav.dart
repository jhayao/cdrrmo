
import 'package:flutter/material.dart';
import 'package:medicare/icons/icons.dart';
import 'package:medicare/pages/profile_page.dart';

import 'accidents.dart';


import 'ambulance_location_page.dart';
import 'doctor_search.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'home/home_page.dart';
//this page contains a common bottom navigation bar for all the pages.
class BottomNav extends StatefulWidget {
  static final String bottomNav = '/bottom';
  BottomNav({this.currentIndex});
  int ? currentIndex;
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  //setting the current index at 0
  // int _currentIndex = 0;
  //the order of these widgets should be kept same as the bottom navigation bar
  final List<Widget> _tabs = [HomePage(), Accidents(), Events(), ProfilePage()];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Heelo");
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification!;
      AndroidNotification ? android = message.notification?.android;
      if (notification != null && android != null) {

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey.shade200,
      body: _tabs[widget.currentIndex!],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFE37C54),
        currentIndex: widget.currentIndex!,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: new Icon(
                MyFlutterApp.home,
                color: Colors.orange.shade50,
                size: 25.0,
              ),
            ),
            // ignore: deprecated_member_use
            title: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                'Map',
                style: TextStyle(
                  color: Colors.orange.shade50,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(
                MyFlutterApp.hospital,
                color: Colors.orange.shade50,
                size: 25.0,
              ),
            ),
            // ignore: deprecated_member_use
            title: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                "Accidents",
                style: TextStyle(
                  color: Colors.orange.shade50,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(
                MyFlutterApp.doctor,
                color: Colors.orange.shade50,
                size: 25.0,
              ),
            ),
            // ignore: deprecated_member_use
            title: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                "Updates",
                style: TextStyle(
                  color: Colors.orange.shade50,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(
                Icons.people,
                color: Colors.orange.shade50,
                size: 25.0,
              ),
            ),
            // ignore: deprecated_member_use
            title: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.orange.shade50,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
      ),
    );
  }
}
