import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:medicare/constants/color.dart';
import 'package:medicare/models/userModel.dart';
import 'package:medicare/pages/test2.dart';
import 'package:medicare/services/database.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'accidentMap.dart';
import 'ambulance_location_page.dart';
import 'doctor_search.dart';
import 'home/widgets/fab2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home/widgets/fab3.dart';

class AccidentDetailsPage extends StatefulWidget {
  AccidentDetailsPage(this.id,this.month);
  final String id;
  final String month;


  @override
  State<AccidentDetailsPage> createState() => _AccidentDetailsPageState();
}

class _AccidentDetailsPageState extends State<AccidentDetailsPage> {
  String ? status;
  String userTypes = 'user';
  String ? phone;
  String ? total,maleCount,femaleCount;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> ?  totals ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdmin();

  }
  Future<String> _getAddressFromLatLng(double lat, double lang) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          lat,
          lang
      );

      Placemark place = placemarks[0];

      return "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      return e.toString();
    }
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }
  Widget essentialInfo(String title, String subTitle) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
              fontFamily: "Roboto", fontSize: 18, color: Colors.black54),
        ),
        Text(
          subTitle,
          style: TextStyle(
            fontFamily: "Roboto",
            fontSize: 18,
          ),
        )
      ],
    );
  }


  getAdmin() async{
    final User? user = auth.currentUser;
    final uid = user!.uid;
    print("Admin ID $uid");
    return await FirebaseFirestore.instance.collection('userDetails').doc(uid).get().then((DocumentSnapshot document) {
      setState(() {
        userTypes = document['userType'];
      });
      return document['userType'];
    });

  }

  Future getVictims(String victimUID) async{
    return await FirebaseFirestore.instance.collection('victims').doc(victimUID).get().then((DocumentSnapshot document) {

      return document['total'];
    });

  }
  Future<String> getUserType(String uid) async{
   return await FirebaseFirestore.instance.collection('userDetails').doc(uid).get().then((DocumentSnapshot document) {
     setState(() {
       userTypes = document['userType'];
     });
      return document['userType'];
    });
  }

  @override
  Widget build(BuildContext context) {

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    CollectionReference accident = FirebaseFirestore.instance.collection('accident');
    late String lat,long;
    final user = Provider.of<userModel?>(context);
    // getUserType(user!.uid.toString());
    String docID = "";
    return Scaffold(
        appBar: NewGradientAppBar(
            title: Text('Accident Details'),
            gradient: LinearGradient(colors: [Colors.blue, Colors.purple, Colors.red])
        ),
      body: StreamBuilder(
          // future: accident.doc(id).get(),
          stream: FirebaseFirestore.instance.collection("accident").doc(widget.id).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                else {
                  if (snapshot.data == null) {
                    return Text('No data to show');
                  } else {
                    Map<String, dynamic> data = snapshot.data!.data() as Map<
                        String,
                        dynamic>;
                    lat = data['latitude'];
                    long = data['longitude'];
                    status = data['status'];

                    phone = data['phone'];
                    print("Snapshot ID: ${snapshot.data!.id}");
                    return Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Center(
                                child: CachedNetworkImage(
                                  imageUrl: data['image'],
                                  width: deviceWidth,
                                  fit: BoxFit.fitWidth,
                                  placeholder: (context,
                                      url) => new CircularProgressIndicator(),
                                  imageBuilder: (context, imageProvider) =>
                                      GFAvatar(
                                        backgroundImage: imageProvider,
                                        shape: GFAvatarShape.square,
                                        radius: 120,

                                      ),
                                )
                            ),
                            Container(
                              color: Color(0xFFFFE6E6),
                              height: deviceHeight /1.5,
                              width: double.infinity,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 10,
                                        left: 20.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        //Center Column contents vertically,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Accident ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),

                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: deviceHeight / 50,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: deviceWidth / 1.5),
                                      child: Text(
                                        "Reported by: ",
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black54),
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(top: 15.0),
                                      child: Container(
                                          width: deviceWidth / 1.1,
                                          child: Text(
                                            data['name'],
                                            style: TextStyle(
                                                fontFamily: "Roboto", fontSize: 18),
                                          )),
                                    ),
                                    SizedBox(
                                      height: deviceHeight / 50,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: deviceWidth / 1.5),
                                      child: Text(
                                        "Location:        ",
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black54),
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(top: 15.0),
                                      child: Container(
                                          width: deviceWidth / 1.1,
                                          child: FutureBuilder(
                                              future: _getAddressFromLatLng(double.parse(data["latitude"]),double.parse(data["longitude"])),
                                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                                switch (snapshot.connectionState) {
                                                  case ConnectionState.waiting: return Text('Loading....');
                                                  default:
                                                    if (snapshot.hasError)
                                                      return Text('Error: ${snapshot.error}');
                                                    else
                                                      return Text(' ${snapshot.data}',
                                                        style: TextStyle(
                                                            fontFamily: "Roboto", fontSize: 18),);
                                                }
                                              }
                                          )
                                      ),
                                    ),
                                    SizedBox(
                                      height: deviceHeight / 50,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: deviceWidth / 1.5),
                                      child: Text(
                                        "Status:            ",
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 15.0),
                                      child: Container(
                                          width: deviceWidth / 1.1,
                                          child: Text(
                                            data['status'],
                                            style: TextStyle(
                                                fontFamily: "Roboto", fontSize: 18),
                                          )),
                                    ),
                                    SizedBox(
                                      height: deviceHeight / 50,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: deviceWidth / 1.5),
                                      child: Text(
                                        "Phone Number:",
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 15.0),
                                      child: Container(
                                          width: deviceWidth / 1.1,
                                          child: data['phone'].toString().length >0 ? userTypes.toLowerCase() == 'admin' ? ElevatedButton.icon(
                                            icon: Icon(
                                              Icons.call,
                                              color: Colors.black,
                                              size: 24.0,
                                            ),
                                            label: Text(data['phone'],),
                                            onPressed: () async{
                                              await _makePhoneCall(data['phone']);
                                            },
                                          ) : Text(data['phone'].toString(),style: TextStyle(
                                              fontFamily: "Roboto", fontSize: 18),):  Text(
                                            'No phone number provided',
                                            style: TextStyle(
                                                fontFamily: "Roboto", fontSize: 18),
                                          )
                                      ),
                                    ),
                                    SizedBox(
                                      height: deviceHeight / 50,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: deviceWidth / 1.5),
                                      child: Text(
                                        "Number of victims:",
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 15.0),
                                      child: Container(
                                          width: deviceWidth / 1.1,
                                          child: StreamBuilder(
                                            stream: FirebaseFirestore.instance.collection('victims').doc(snapshot.data!.id).snapshots(),
                                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshots) {
                                              if(snapshots.hasData){
                                                if(snapshots.connectionState == ConnectionState.waiting){
                                                  return Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }else{
                                                  try{
                                                    Map<String, dynamic> data = snapshots.data!.data() as Map<
                                                        String,
                                                        dynamic>;
                                                    return Text(data['total'],style: TextStyle(
                                                        fontFamily: "Roboto", fontSize: 18),);

                                                  } catch(e)
                                                  {
                                                    return Text('no data',);
                                                  }
                                                  // );
                                                }
                                              }else if (snapshots.hasError){
                                                return Text('no data',);
                                              }
                                              return CircularProgressIndicator();
                                            },
                                          ),
                                    )),

                                    SizedBox(
                                      height: deviceHeight / 50,
                                    )

                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }
            }
          }),
      bottomNavigationBar: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                border:
                Border(right: BorderSide(color: Colors.black, width: 2.0))),
            width: deviceWidth / 2,
            height: deviceHeight / 17,
            child:RaisedButton(
              color: AppTheme.orange,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccidentMap(lat: lat!,long:long,title: 'Accident Map',)),
              ),
              child: Text(
                "Show Location",
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: deviceWidth / 2,
            height: deviceHeight / 17,
            child: RaisedButton(
              color: AppTheme.red,
              onPressed: () async{
                String userType =await getUserType(user!.uid);
                print("USER TYPE $userType");
                if (userType.toString().toLowerCase() == 'admin')
                {
                  await DatabaseService(uid: user!.uid.toString())
                      .editAccident(widget.id,phone!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyLocation(lat: lat!,long:long,docID : widget.id,phone: phone,)),
                  );
                }
                else
                  Fluttertoast.showToast(
                      msg: "Only admin can use this feature",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.transparent,
                      textColor: Colors.black,
                      fontSize: 16.0
                  );

              },
              child: Text(
                "Navigate",
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: userTypes.toLowerCase() == 'admin' ? BuildFab3(docID: widget.id,month: widget.month) : null
    );

  }
}
