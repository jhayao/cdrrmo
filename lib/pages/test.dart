import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {

  ImagePicker image = new ImagePicker();
  File? file;
  String url = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  uploadFile() async{
    String _basename = basename(file!.path);
    var imageFile = FirebaseStorage.instance.ref().child("path").child(_basename);
    UploadTask task = imageFile.putFile(file!);
    TaskSnapshot snapshot = await task;

    url = await snapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection("images").doc().set({"imageURL":url});
    print(url);
  }

  getImage() async{
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                getImage();
              },
              child: CircleAvatar(
                radius: 80,
                backgroundImage: file==null ? AssetImage("assets/img/default.jpg") : FileImage(File(file!.path)) as ImageProvider,
              ),
            ),
            ElevatedButton(
                onPressed: () {uploadFile();},
                child: Text("Upload to Firebase")),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("images").snapshots(),
                builder:  (context,AsyncSnapshot<QuerySnapshot> snapshot){
                  return GridView.builder(
                      physics: ScrollPhysics(),
                      primary: true,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,crossAxisSpacing: 6,mainAxisSpacing: 3,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,i){
                        QueryDocumentSnapshot x =snapshot.data!.docs[i];
                        if (snapshot.hasData){
                            return Card(
                              child: Image.network(x["imageURL"]),
                            );
                        }
                        return Center(child: CircularProgressIndicator(),);
                      });
                })
          ],
        ),
      ),
    );
  }
}
