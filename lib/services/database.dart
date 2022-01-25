import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:medicare/models/updateModel.dart';
import 'package:medicare/models/userDetails.dart';
import 'package:medicare/models/userModel.dart';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;
import 'package:geocode/geocode.dart';


class DatabaseService{
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('userDetails');
  final CollectionReference updateCollection = FirebaseFirestore.instance.collection('updates');
  final CollectionReference accidentCollection = FirebaseFirestore.instance.collection('accident');
  final CollectionReference victimCollection = FirebaseFirestore.instance.collection('victims');

  final String uid;
  String url = "";
  DatabaseService({  this.uid = ''});

  Future updateUserData(String name, String address,String phone,String email) async
  {
    return await userCollection.doc(uid).set({
      'name': name,
      'address' : address,
      'email' : email,
      'phone' : phone,
      'userType': 'user',
      'image' : 'https://firebasestorage.googleapis.com/v0/b/cdrrmo-83dcf.appspot.com/o/iStock-476085198.jpg?alt=media&token=335ef46d-26aa-4bda-8254-0853f7e37392'
    });
  }

  Future updateUserDataEmail(String email) async
  {
    return await userCollection.doc(uid).update({
      'email' : email,
    });
  }
  Future updateUserDataName(String name) async
  {
    return await userCollection.doc(uid).update({
      'name' : name,
    });
  }
  Future updateUserDataPhone(String phone) async
  {
    return await userCollection.doc(uid).update({
      'phone' : phone,
    });
  }
  Future updateImage(File file) async{
    return await userCollection.doc(uid).update({
      'image' : await uploadFile(file)
    });
  }
  Future updateUserDataAddress(String address) async
  {
    return await userCollection.doc(uid).update({
      'address' : address,
    });
  }


  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData( snapshot['name'], snapshot['address'],snapshot['email'], snapshot['phone'],uid,snapshot['userType']);
  }


  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }
  Future newUpdate(String date,String title,String desc, File ? file) async{
    // String _url = uploadFile(file);
    if (file!=null)
      return await updateCollection.doc(title).set({
        'date_posted': date,
        'title' : title,
        'description' : desc,
        'image' : await uploadFile(file)
      });
    return await updateCollection.doc(title).set({
      'date_posted': date,
      'title' : title,
      'description' : desc,
      'image' : 'https://firebasestorage.googleapis.com/v0/b/cdrrmo-83dcf.appspot.com/o/event-default-img-med.png?alt=media&token=7936ae0a-c825-4722-a547-687a4f47b20b'
    });
  }
  Future editUpdate(String date,String ? oldTitle,String title,String desc, File ? file,String ? url) async{
    if (file!=null)
      return await updateCollection.doc(oldTitle).update({
        'date_posted': date,
        'title' : title,
        'description' : desc,
        'image' : await uploadFile(file)
      });
    return await updateCollection.doc(oldTitle).set({
      'date_posted': date,
      'title' : title,
      'description' : desc,
      'image' : url,
    });
  }

  Future editAccidentRescued(File? file,String ? docId) async{
    if (file!=null)
      return await accidentCollection.doc(docId).update({
        'status' : 'Rescued',
        'image' : await uploadFile(file)
      });
  }

  Future addVictim(String total,String male,String female,String ? docId,String ? month) async{

      return await victimCollection.doc(docId).set({
        'female' : female,
        'male' : male,
        'total' : total,
        'month' : month
      });
  }

  Future deleteUpdate(String ? oldTitle) async{
      return await updateCollection.doc(oldTitle).delete().then((value) => print('Deleted')).catchError((error) => print('Delete failed: $error'));
  }


  Future<String> uploadFile(File? file) async{
    String _basename = Path.basename(file!.path);
    var imageFile = FirebaseStorage.instance.ref().child("path").child(_basename);
    UploadTask task = imageFile.putFile(file);
    TaskSnapshot snapshot = await task;

    url = await snapshot.ref.getDownloadURL();
    return url;
  }
  UpdateModel _updateDataFromSnapshot(DocumentSnapshot snapshot){
    return UpdateModel( snapshot['date_posted'], snapshot['title'],snapshot['description'],uid);
  }
  Stream<UpdateModel> get updateData{
    return userCollection.doc(uid).snapshots()
        .map(_updateDataFromSnapshot);
  }

  Future newAccident(String name, String latitude, String longitude,String phone, String type) async
  {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    var months = new DateFormat('MMMM');
    String formattedDate = formatter.format(now);
    String monthName = months.format(now);
    // print(monthname); // 2016-01-25

    // postData('','');
    return await accidentCollection.doc().set({
      'name': name,
      'latitude' : latitude,
      'longitude' : longitude,
      'phone' : phone,
      'type' : type,
      'uid' : uid,
      'date_posted' : formattedDate,
      'status' : 'pending',
      'month' : monthName,
      'image' : 'https://firebasestorage.googleapis.com/v0/b/cdrrmo-83dcf.appspot.com/o/accident.jpg?alt=media&token=435e3c29-6799-442a-89e3-c0c1893d1937'
    });
  }

  postData(String number,String message) async{
    String apiCode = "TR-JAYMA228560_GQFTU";
    String passwd = "w{cfgpl%m}";
    var response = await http.post(Uri.parse("https://www.itexmo.com/php_api/api.php"),body: {
      '1' : number,
      '2' : message,
      '3' : apiCode,
      'passwd' : passwd
    });
    print("Response : ${response.body}");
  }

  Future editAccident(String id,String number) async
  {
    String msg = "Rescuer is on the way";
    if (number.toString().length>0)
      postData(number,msg);
    return await accidentCollection.doc(id).update({
      'status': 'on the way'
    });
  }

  Future editAccident2(String id,String number) async
  {
    String msg = "Rescuer is near";
    if (number.toString().length>0)
      postData(number,msg);
    return await accidentCollection.doc(id).update({
      'status': 'Rescuer is near'
    });
  }
  Future editAccident3(String id,String number) async
  {
    String msg = "Rescuer is on the location";
    if (number.toString().length>0)
      postData(number,msg);
    return await accidentCollection.doc(id).update({
      'status': 'Rescuer is on the location'
    });
  }


}

