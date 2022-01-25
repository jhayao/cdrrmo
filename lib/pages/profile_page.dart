import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicare/drawer.dart';
import 'package:medicare/models/userDetails.dart';
import 'package:medicare/pages/authentication/pages/widgets/extra/addressField.dart';
import 'package:medicare/pages/authentication/pages/widgets/extra/emailField.dart';
import 'package:medicare/pages/authentication/pages/widgets/extra/nameField.dart';
import 'package:medicare/pages/authentication/pages/widgets/extra/phoneField.dart';
import 'package:medicare/services/Auth.dart';
import 'package:medicare/services/database.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  final ImagePicker _picker = ImagePicker();
  String name = "John Doe";
  String email = "John.doe@gmail.com";
  String phone = "9999999999";
  String address = "15, Yemen road, Yemen";
  final AuthService _auth = AuthService();
  File? file;
  String ? image;
  String userType='user';
  late String UID;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: name);
    _emailController = TextEditingController(text: email);
    _phoneController = TextEditingController(text: phone);
    _addressController = TextEditingController(text: address);
    _getdata();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Widget _saveButton() {
    return SizedBox(
      width: 100.0,
      child: RaisedButton(
          onPressed: () => print("Information Updated"),
          color: Colors.cyan.shade200,
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Text(
            "Save",
            style: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.bold),
          )),
    );
  }

  Widget _cancelButton() {
    return SizedBox(
      width: 100.0,
      child: RaisedButton(
          onPressed: () => print("Cancelled"),
          color: Colors.cyan.shade200,
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Text(
            "Cancel",
            style: TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.bold),
          )),
    );
  }

  Widget recentPurchases() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (BuildContext context, int i) => Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6.0,
            color: Colors.grey.shade200,
            child: Container(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset('assets/images/med.svg'),
                  Text(
                    "Name",
                    style: TextStyle(
                        fontFamily: "Roboto", fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget frequentlyContacted() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (BuildContext context, int i) => Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6.0,
            color: Colors.grey.shade200,
            child: Container(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset('assets/images/doc.svg'),
                  Text(
                    "Dr. Sharma",
                    style: TextStyle(
                        fontFamily: "Roboto", fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget hospitals() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (BuildContext context, int i) => Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6.0,
            color: Colors.grey.shade200,
            child: Container(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset('assets/images/hospital.svg'),
                  Text(
                    "General Hospital",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Roboto", fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFE37C54),
          title: Text(
            "Profile",
            style: TextStyle(
              fontFamily: "Roboto",
            ),
          ),
          centerTitle: true,
        ),
        // drawer: getDrawer(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.red.shade100,
                        child: imageProfile(image!=null ? image! : 'https://firebasestorage.googleapis.com/v0/b/cdrrmo-83dcf.appspot.com/o/iStock-476085198.jpg?alt=media&token=335ef46d-26aa-4bda-8254-0853f7e37392'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight / 25, left: deviceWidth / 10),
                        child: Row(
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: deviceWidth / 4.6,
                            ),
                            // _editNameTextField(deviceWidth / 2),
                            NameField(deviceWidth: deviceWidth / 2),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight / 25, left: deviceWidth / 10),
                        child: Row(
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: deviceWidth / 4.6,
                            ),
                            // _editEmailTextField(deviceWidth / 2),
                            EmailField(deviceWidth: deviceWidth/2)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight / 25, left: deviceWidth / 10),
                        child: Row(
                          children: [
                            Text(
                              "Phone",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: deviceWidth / 5,
                            ),
                            // _editPhoneTextField(deviceWidth / 2),
                            PhoneField(deviceWidth: deviceWidth/2)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight / 25, left: deviceWidth / 10),
                        child: Row(
                          children: [
                            Text(
                              "Address",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: deviceWidth / 6.2,
                            ),
                            // _editAddressTextField(deviceWidth / 2),
                            AddressField(deviceWidth: deviceWidth/2)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight / 25, left: deviceWidth / 7),

                      ),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          splashColor: Colors.purple,
                          color: Colors.blue[100],
                          onPressed: () async{
                            await _auth.signOut();
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(fontFamily: 'Roboto', fontSize: 20.0),
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Container(
                  color: Color(0xFFFFE6E6),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: deviceWidth / 2),
                        child: Text(
                          "Recent Accidents",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: recentPurchases(),
                      ),


                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  }
  Widget imageProfile(String  url) {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: file==null  ? NetworkImage(url)
              :  FileImage(File(file!.path)) as ImageProvider,
          // backgroundImage: file == null ? AssetImage("assets/profile.jpeg")  : FileImage(File(file!.path) as ImageProvider),
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }
  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      file = File(pickedFile!.path);
    });

    if (file!=null)
      {
        await DatabaseService(uid: UID).updateImage(file!);
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
        image = userData['image']!;
      });
    }
    );
  }
}
