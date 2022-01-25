import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:medicare/constants/color.dart';
import 'package:medicare/models/userModel.dart';
import 'package:medicare/pages/test2.dart';
import 'package:medicare/services/database.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'doctor_search.dart';

class DoctorDetailsPage extends StatelessWidget {
  DoctorDetailsPage(this.title);
  final String title;
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



  Future getUserType(String uid) async{
    await FirebaseFirestore.instance.collection('userDetails').doc(uid).get().then((DocumentSnapshot document) {
      print("x value: $document['userType']");
    });
  }

  @override
  Widget build(BuildContext context) {


    final user = Provider.of<userModel?>(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('userDetails').doc(user!.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            else{
              var userDocument = snapshot.data;
              if (userDocument["userType"]=='admin')
                return newForm(context,true,user!.uid);
              return newForm(context,false,user!.uid);
            }
        }
      }
    );

  }

  Widget newForm(BuildContext context, bool admin, String uid){
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    CollectionReference updates = FirebaseFirestore.instance.collection('updates');
    return Scaffold(
      appBar: NewGradientAppBar(
          title: Text('EVENT'),
          gradient: LinearGradient(colors: [Colors.blue, Colors.purple, Colors.red])
      ),

      body: FutureBuilder<DocumentSnapshot>(
          future: updates.doc(title).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }
                else{
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      Center(
                          child: CachedNetworkImage(
                            imageUrl: data['image'],
                            width: deviceWidth,
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) => new CircularProgressIndicator(),
                            imageBuilder: (context, imageProvider) => GFAvatar(
                              backgroundImage:imageProvider,
                              shape: GFAvatarShape.square,
                              radius: 120,

                            ),
                          )
                      ),
                      Container(
                        color: Color(0xFFFFE6E6),
                        height: deviceHeight / 1.85,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                left: 20.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    data['title']  ,
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
                              padding: EdgeInsets.only(right: deviceWidth / 1.5),
                              child: Text(
                                "Description",
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
                                    data['description'],
                                    style: TextStyle(
                                        fontFamily: "Roboto", fontSize: 18),
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  );
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
            child: RaisedButton(
              color: AppTheme.orange,
              onPressed: () {
                if (admin)
                  Navigator.push(context,MaterialPageRoute(builder: (context) => CreateProfile(title: title)));
                else
                  Fluttertoast.showToast(
                      msg: "Only admin can edit this event",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.transparent,
                      textColor: Colors.black,
                      fontSize: 16.0
                  );
                  },
              child: Text(
                "Edit",
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
              onPressed: () async {
                if (admin)
                 {
                   await DatabaseService(uid: uid.toString())
                       .deleteUpdate(title);
                   Navigator.pushReplacementNamed(context, '/event');
                 }
                else
                  Fluttertoast.showToast(
                      msg: "Only admin can delete this event",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.transparent,
                      textColor: Colors.black,
                      fontSize: 16.0
                  );

              },
              child: Text(
                "Delete",
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
