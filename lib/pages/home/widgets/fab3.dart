
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicare/constants/icons_constants.dart';
import 'package:medicare/constants/padding_constant.dart';
import 'package:medicare/constants/sizes_constants.dart';
import 'package:medicare/constants/theme.dart';
import 'package:medicare/services/database.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';


class BuildFab3 extends StatefulWidget {
  final String docID;
  final String month;
  const BuildFab3({Key? key, required this.docID, required this.month}) : super(key: key);

  @override
  _BuildFab3State createState() => _BuildFab3State();
}

class _BuildFab3State extends State<BuildFab3> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> monthFilters;
  File? file;
  bool circular = false;
  final ImagePicker _picker = ImagePicker();
  late String UID;
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();


  @override
  void initState() {
    super.initState();
    myController.text = '0';
    myController2.text = '0';
    myController3.text = '0';
    _getdata();
    //running initialisation code; getting prefs etc.
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
        UID = user.uid;
      });
    }
    );
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
                        "Option",
                        style: TextStyle(
                            color: kBlack54,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),
                  SizedBox(height: PaddingConstant.kPadding,),
                  _buildCategory(
                      category: "Mark as rescued",
                      iconData: IconsConstants.instance.iconHealth,
                      color: kBlue,
                      type: "road",
                      context: context
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
        IconsConstants.instance.iconHealth,
        color: kBlue,
      ),
    );
  }



  Widget _buildCategory({
    required String category,
    required IconData iconData,
    required Color color,
    required String  type,
    required BuildContext context

  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: PaddingConstant.kPadding,
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled:true,
              builder: (context) => buildSheet()
          );
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
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          isScrollControlled:true,
          builder: (context) => buildSheet()
      );
    });
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
  Widget buildSheet() => ListView(
    padding: const EdgeInsets.symmetric(
        horizontal: 20, vertical: 30),
    children: <Widget>[
      imageProfile('https://firebasestorage.googleapis.com/v0/b/cdrrmo-83dcf.appspot.com/o/event-default-img-med.png?alt=media&token=7936ae0a-c825-4722-a547-687a4f47b20b'),
      SizedBox(
        height: 20,
      ),
      TextField(
        keyboardType: TextInputType.number,
        controller: myController,
        onChanged: (text){
          print (text);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Number of accident victims',
          hintText: 'Number only',
        ),
      ),
      SizedBox(
        height: 20,
      ),
      TextField(
        keyboardType: TextInputType.number,
        controller: myController2,
        onChanged: (text){
          myController3.text = (int.parse(myController.text) - int.parse(myController2.text)).toString();
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Male Count',
            hintText: 'Male count'
        ),
      ),
      SizedBox(
        height: 20,
      ),
      TextField(
        keyboardType: TextInputType.number,
        controller: myController3,
        onChanged: (text){
          myController2.text = (int.parse(myController.text) - int.parse(myController3.text)).toString();
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Female count',
            hintText: 'Female count'
        ),
      ),
      SizedBox(
        height: 20,
      ),
      InkWell(
        onTap: () async {
          try {
            print("Equal " + (int.parse(myController.text) ==
                (int.parse(myController2.text) + int.parse(myController3.text)))
                .toString());
            if (int.parse(myController.text) ==
                int.parse(myController2.text) + int.parse(myController3.text)) {
              if (file == null) {
                Fluttertoast.showToast(
                    msg: "Prof image shall not be empty",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.transparent,
                    textColor: Colors.black,
                    fontSize: 16.0
                );
              }
              else {
                await DatabaseService(uid: UID).editAccidentRescued(
                    file, widget.docID);
                await DatabaseService(uid: UID).addVictim(myController.text,myController2.text,myController3.text,widget.docID,widget.month);
                Fluttertoast.showToast(
                    msg: "Rescued Successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.transparent,
                    textColor: Colors.black,
                    fontSize: 16.0
                );
              }
            }
            else {
              Fluttertoast.showToast(
                  msg: 'number of victims not matched',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.transparent,
                  textColor: Colors.black,
                  fontSize: 16.0
              );
            }
          }on FormatException catch(e)
          {
            Fluttertoast.showToast(
                msg: 'Invalid Number',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.transparent,
                textColor: Colors.black,
                fontSize: 16.0
            );
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
                "Submit Proof",
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
  );
}
