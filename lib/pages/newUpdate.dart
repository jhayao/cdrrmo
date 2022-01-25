import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:medicare/models/userModel.dart';
import 'package:medicare/services/database.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../drawer.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';


class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  late String title;
  late String desc;
  late String datePicked;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool uploading = false;
  double val = 0;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;
  ImagePicker image = new ImagePicker();
  File? file;
  String url = "";
  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('imageURLs');
  }


  List<File> _image = [];
  final picker = ImagePicker();
  Widget _buildDescription() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Description'),
      maxLength: 100,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Title is Required';
        }

        return null;
      },
      onSaved: (String ? value) {
        desc = value!;
      },
    );

  }

  Widget _buildTitle(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 10,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Description is Required';
        }

        return null;
      },
      onSaved: (String ? value) {
        title = value!;
      },
    );
  }



  Widget _buildDatePicker(){
    return DateTimePicker(
      initialValue: '',
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      dateLabelText: 'Date',
      onChanged: (val) => print(val),
      validator: (String ? value) {
        if (value!.isEmpty) {
          return 'Date is Required';
        }

        return null;
      },
      onSaved: (String ? value) => datePicked = value!,
    );
  }

  getImage() async{
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userModel?>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE37C54),
        title: Text(
          "New Event/Update",
          style: TextStyle(
            fontFamily: "Roboto",
          ),
        ),
        centerTitle: true,
      ),
      drawer: getDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildDatePicker(),
                _buildTitle(),
                _buildDescription(),
                InkWell(
                  onTap: (){
                    getImage();
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: file==null ? AssetImage("assets/img/default.jpg") : FileImage(File(file!.path)) as ImageProvider,
                  ),
                ),
                // _imagePicker(),
                SizedBox(height: 100),
                RaisedButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () async{
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    _formKey.currentState!.save();
                    // await DatabaseService(uid: user!.uid.toString()).newUpdate(datePicked, title, desc);

                    //Send to API
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}