import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:medicare/drawer.dart';
import 'package:medicare/models/userModel.dart';
import 'package:medicare/pages/accident_detail.dart';
import 'package:medicare/pages/doctor_details.dart';
import 'package:medicare/pages/home/widgets/fab.dart';
import 'package:medicare/pages/home/widgets/fab2.dart';
import 'package:medicare/pages/home/widgets/navigation_bar.dart';
import 'package:medicare/pages/test2.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Accidents extends StatefulWidget {

  @override
  _AccidentsState createState() => _AccidentsState();
}

class _AccidentsState extends State<Accidents> {
  final ScrollController _scrollController = ScrollController();
  late String userType;
  late String docId;
  late Future<String> _counter;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<QueryDocumentSnapshot> documents = [];
  final LocalStorage storage = new LocalStorage('monthFilter');
  String monthFilter= "All";
  static const months = <String>[ "January", "February", 'March', 'April','May','June','July','August','September','October','November','December' ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _incrementCounter('All');
    _getdata();
  }

  Future<String?> _incrementCounter(String m) async {
    final SharedPreferences prefs = await _prefs;
    final String?  counter = prefs.getString('monthFilter') ;

    setState(() {
      _counter = prefs.setString('monthFilter', m).then((bool success) {
        return counter!;
      });

    });
    print("Testing ${prefs.getString('monthFilter')}");
  }

  _saveToStorage(String m) {
    storage.setItem('todos',m);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userModel?>(context);
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        // drawer: getDrawer(context),
        appBar: NewGradientAppBar(
            title: Text('Accidents'),
            gradient: LinearGradient(colors: [Colors.blue, Colors.purple, Colors.red])
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _section(deviceWidth),
              _section(deviceWidth),
              _section(deviceWidth),
              _section(deviceWidth),
              DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItems: true,
                  items: ["All", "January", "February", 'March', 'April','May','June','July','August','September','October','November','December'],
                  label: "Filter by Month",
                  hint: "filter accident according to months",
                  // popupItemDisabled: (String s) => s.startsWith('I'),
                  onChanged: (data) {
                    setState(() {
                      monthFilter = data!;
                      _incrementCounter(monthFilter);
                      _saveToStorage(monthFilter);
                      print("Storage: " + storage.getItem('todos'));
                    });
                  },
                  selectedItem: "All"),
              _section(deviceWidth),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("accident").orderBy("date_posted").snapshots(),
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
                            documents = snapshot.data!.docs;
                            print("Month Filter :" + monthFilter);
                            documents = documents.where((element) {
                              if(monthFilter.toLowerCase().contains('all'))
                                {
                                  print(true);
                                  return element.get('uid').toString().isNotEmpty;
                                }
                              else
                                {
                                  print(false);

                                  return element.get('month').toString().toLowerCase().contains(monthFilter.toLowerCase());
                                }

                            }).toList();
                            if(documents.length == 0)
                              {
                                print("True");
                               return  EmptyWidget(
                                  image: "lib/assets/images/emptyImage.png",
                                  title: 'No Accident',
                                  subTitle: 'No  accident available',
                                  titleTextStyle: TextStyle(
                                    fontSize: 22,
                                    color: Color(0xff9da9c7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  subtitleTextStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xffabb8d6),
                                  ),
                                );
                              }
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: documents.length,
                                itemBuilder: (context, i) {
                                  docId = documents[i].id;
                                  if (snapshot.hasData) {
                                    return _accident(i,documents[i]["type"],docId,
                                        deviceWidth, documents[i]["name"], documents[i]["image"],
                                        documents[i]["status"],documents[i]["date_posted"],documents[i]["latitude"],documents[i]["longitude"],userType,documents[i]["month"]);
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
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BuildFab2(),
      bottomNavigationBar: buildNavigationBar(context),
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

      });
    }
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
  Widget _accident(int counter,String type,String uid,double width,String name,String url,String status,String _date,String lat,String long,String userType,String month) {
    String msg = "$name reported an accident at $lat,$long";
    return Padding(
      padding: const EdgeInsets.only(
        left: 25.0,
        right: 25.0,
        top: 20.0,
        bottom: 10.0,
      ),
      child: InkWell(
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccidentDetailsPage(uid,month)));
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
                              '$type Accident ${counter+1}',
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

                              msg.length > 15 ? msg.substring(0, 15)+'...' : msg,
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
