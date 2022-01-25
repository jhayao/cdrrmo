import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicare/constants/padding_constant.dart';
import 'package:medicare/pages/home/widgets/app_bar.dart';
import 'package:medicare/pages/home/widgets/aciddent_list.dart';
import 'package:medicare/pages/home/widgets/barChart.dart';
import 'package:medicare/pages/home/widgets/fab.dart';
import 'package:medicare/pages/home/widgets/header.dart';
import 'package:medicare/pages/home/widgets/icon_list.dart';
import 'package:medicare/pages/home/widgets/navigation_bar.dart';
import 'package:medicare/pages/home/widgets/new_book.dart';
import 'package:medicare/pages/home/widgets/pieChart.dart';
import 'package:medicare/pages/home/widgets/search_bar.dart';
import 'package:medicare/pages/home/widgets/updates_list.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  String ? name = "";
  String ? image = "";
  String ? email = "";
  String ? UID = "";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
    _incrementCounter();
  }
  Future<String?> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final String?  counter = prefs.getString('monthFilter') ;
    print("Testingsss ${prefs.getString('monthFilter')}");
    return counter;
  }

  void _getdata() async {
    User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(user.uid)
        .snapshots()
        .listen((userData) {
      // print("USERDATA" + userData['userType']);
      setState(() {
        UID = user.uid;
        image = userData['image']!;
        name = userData['name']!;
        email = userData['email']!;
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
          title: Text('HOME'),
          gradient: LinearGradient(colors: [Colors.blue, Colors.purple, Colors.red])
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            top: PaddingConstant.kPadding ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ...buildHeader(name!,image!,email!),
            //
            // buildIconList(),
            BarChartSample1(),
            PieChartSample2(),
            AccidentList(),
            UpdateList(),
            SizedBox(
              height:90,
            )
            // BuildNewBook(),
          ],
        ),
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BuildFab(),
      bottomNavigationBar: buildNavigationBar(context),
    );
  }
}
