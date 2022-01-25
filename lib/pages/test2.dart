import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicare/models/userModel.dart';
import 'package:medicare/services/database.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'bottom_nav.dart';
import 'home.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({Key ? key,required this.title}) : super(key: key);
  final String title;
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  bool circular = false;
  File? file;
  String url = "";
  final _globalkey = GlobalKey<FormState>();

  TextEditingController _date = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _about = TextEditingController();
  final ImagePicker _picker = ImagePicker();



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<userModel?>(context);
    String title,url;
    CollectionReference updates = FirebaseFirestore.instance.collection('updates');
    print("title:" + widget.title);
    return Scaffold(
      appBar: NewGradientAppBar(
          title: widget.title == 'testing nko ni' ? Text('NEW') : Text('EDIT'),
          gradient: LinearGradient(colors: [Colors.blue, Colors.purple, Colors.red])
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: updates.doc(widget.title).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              print(snapshot.data!.data());
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                return Form(
                  key: _globalkey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    children: <Widget>[
                      imageProfile('https://firebasestorage.googleapis.com/v0/b/cdrrmo-83dcf.appspot.com/o/event-default-img-med.png?alt=media&token=7936ae0a-c825-4722-a547-687a4f47b20b'),
                      SizedBox(
                        height: 20,
                      ),
                      titleTextField(),
                      SizedBox(
                        height: 20,
                      ),
                      aboutTextField(),
                      SizedBox(
                        height: 20,
                      ),
                      dobField(),
                      SizedBox(
                        height: 20,
                      ),

                      InkWell(
                        onTap: () async {
                          setState(() {
                            circular = true;
                          });
                          if (_globalkey.currentState!.validate()) {
                            Map<String, String> data = {

                              "DOB": _date.text,
                              "titleline": _title.text,
                              "about": _about.text,
                            };
                            await DatabaseService(uid: user!.uid.toString())
                                .newUpdate(
                                _date.text, _title.text, _about.text, file!=null ? file : file);
                            setState(() {
                              circular = false;
                            });
                            Navigator.pop(context);

                          }
                        },
                        child: Center(
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: circular
                                  ? CircularProgressIndicator()
                                  : Text(
                                "Submit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              else {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                  _date.text = data['date_posted'];
                  _title.text = data['title'];
                  _about.text = data['description'];
                  title =  _title.text;
                  url = data['image'];
                return Form(
                  key: _globalkey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    children: <Widget>[
                      imageProfile(data['image']),
                      SizedBox(
                        height: 20,
                      ),
                      titleTextField(),
                      SizedBox(
                        height: 20,
                      ),
                      aboutTextField(),
                      SizedBox(
                        height: 20,
                      ),
                      dobField(),
                      SizedBox(
                        height: 20,
                      ),

                      InkWell(
                        onTap: () async {
                          setState(() {
                            circular = true;
                          });
                          if (_globalkey.currentState!.validate()) {
                            Map<String, String> data = {

                              "DOB": _date.text,
                              "titleline": _title.text,
                              "about": _about.text,
                            };
                            await DatabaseService(uid: user!.uid.toString())
                                .editUpdate(
                                _date.text,title, _title.text, _about.text, file,url);
                            setState(() {
                              circular = false;
                            });
                            Navigator.pushReplacementNamed(context, '/event');
                          }
                        },
                        child: Center(
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: circular
                                  ? CircularProgressIndicator()
                                  : Text(
                                "Submit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          }
        }),
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
          bottom: 20.0,
          right: 20.0,
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
  }



  Widget dobField() {
    return TextFormField(
      controller: _date,
      validator: (value) {
        if (value!.isEmpty) return "Date can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Date Of Event",
        helperText: "Provide Event on dd/mm/yyyy",
        hintText: "01/01/2020",
      ),
    );
  }

  Widget titleTextField() {
    return TextFormField(
      controller: _title,
      validator: (value) {
        if (value!.isEmpty) return "Title can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Title",
        helperText: "It can't be empty",
        hintText: "Flutter Developer",
      ),
    );
  }

  Widget aboutTextField() {
    return TextFormField(
      controller: _about,
      validator: (value) {
        if (value!.isEmpty) return "About can't be empty";

        return null;
      },
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            )),
        labelText: "About",
        helperText: "Write about yourself",
        hintText: "I am Dev Stack",
      ),
    );
  }
}