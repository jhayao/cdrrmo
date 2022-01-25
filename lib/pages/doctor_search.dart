import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:medicare/drawer.dart';
import 'package:medicare/models/userModel.dart';
import 'package:medicare/pages/doctor_details.dart';
import 'package:medicare/pages/test2.dart';
import 'package:provider/provider.dart';

class Events extends StatefulWidget {

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final ScrollController _scrollController = ScrollController();
  String ? image;
  String userType='user';
  late String UID;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userModel?>(context);
    return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('userDetails').doc(
                user!.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  else {
                    var userDocument = snapshot.data;
                    String userType = userDocument["userType"];
                    return listEvents(context, userType);
                  }
              }
            }
        );

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

  Widget listEvents(BuildContext context,String userType)
  {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // drawer: getDrawer(context),
      appBar: AppBar(
        backgroundColor: Color(0xFFE37C54),
        title: Text('Doctor'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _section(deviceWidth),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("updates").orderBy("date_posted").snapshots(),
                builder:  (context,AsyncSnapshot<QuerySnapshot> snapshot){
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        if (snapshot.data == null) {
                          return Text('No data to show');
                        } else {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                QueryDocumentSnapshot data = snapshot.data!
                                    .docs[i];
                                if (snapshot.hasData) {
                                  return _doctor(
                                      deviceWidth, data["title"], data["image"],
                                      data["description"],data["date_posted"],userType);
                                }
                                return Center(
                                  child: CircularProgressIndicator(),);
                              }
                          );
                        }
                      }
                  }

                })
          ],
        ),
      ),

        floatingActionButton: (userType == 'admin') ? FloatingActionButton(
          onPressed: () =>
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    CreateProfile(title: 'testing nko ni')),
              ) ,
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ): null
    );
  }
  Widget _section(double deviceWidth) {
    return Container(
      width: deviceWidth,
      margin: const EdgeInsets.only(bottom: 3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 3.0,
          ),
        ],
      ),

    );
  }

//Search Bar
  Widget _searchBar() {
    return TextField(
      decoration: new InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(end: 12.0),
            child: Icon(Icons.search),
          ),
          border: new OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          fillColor: Colors.cyan.shade100,
          filled: true,
          hintText: "Search by Name or Field.."),
    );
  }

//Doctor card
  Widget _doctor(double width,String title,String url,String description,String _date,String userType) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25.0,
        right: 25.0,
        top: 20.0,
        bottom: 10.0,
      ),
      child: InkWell(
        onTap: () {
          if(userType=='admin')
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateProfile(title: title)),
            );
          else
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorDetailsPage(title)),
            );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey.shade200,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 7.0),
                blurRadius: 5.0,
              ),
            ],
          ),
          width: width,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      child:CachedNetworkImage(
                        imageUrl: url,
                        placeholder: (context, url) => new CircularProgressIndicator(),
                        imageBuilder: (context, imageProvider) => GFAvatar(
                            backgroundImage:imageProvider,
                            shape: GFAvatarShape.standard,
                            radius: 50,

                        ),
                        errorWidget: (context, url, error) => GFAvatar(
                          backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/cdrrmo-83dcf.appspot.com/o/event-default-img-med.png?alt=media&token=7936ae0a-c825-4722-a547-687a4f47b20b'),
                          shape: GFAvatarShape.standard,
                          radius: 50,

                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            AutoSizeText(
                              description.length > 10 ? description.substring(0, 10)+'...' : description,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Date: ${_date}" ,
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 18.0,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

//book an appointment button


//Consult online button

}
