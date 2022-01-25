
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:medicare/constants/padding_constant.dart';
import 'package:medicare/constants/sizes_constants.dart';
import 'package:medicare/constants/theme.dart';
import 'package:medicare/models/book_model.dart';
import 'package:medicare/pages/book/accident_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../accident_detail.dart';

final List<BookModel> books = BookModel.book;

class AccidentList extends StatefulWidget {
  const AccidentList({Key? key}) : super(key: key);

  @override
  State<AccidentList> createState() => _AccidentListState();
}

class _AccidentListState extends State<AccidentList> {

  StreamBuilder ? _widget;
  // TODO your stream
  var myStream = FirebaseFirestore.instance.collection("accident").orderBy("date_posted").snapshots();
  GoogleGeocoding ? googleGeocoding;

  @override
  void initState() {
    super.initState();
    getAddress();

  }



  Future getAddress() async {
    var client = http.Client();
    try {
      var response = await client.post(
          Uri.https('example.com', 'whatsit/create'),
          body: {'name': 'doodle', 'color': 'blue'});
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      var uri = Uri.parse(decodedResponse['uri'] as String);
      print("URI: ");
      print(await client.get(uri));
    } finally {
    client.close();
    }
  }
  Future<String> _getAddress(double? lat, double? lang) async {
    if (lat == null || lang == null) return "";
    GeoCode geoCode = GeoCode();
    Address address =
    await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
    return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
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


  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.infinity,
      color: kBlack.withOpacity(0.1),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: PaddingConstant.kPadding,
                horizontal: PaddingConstant.kPadding * 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Accidents",
                  style: subTitle.copyWith(color: kBlack),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("  Latest  "),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: PaddingConstant.kPadding),
                    backgroundColor: kDeepOrange,
                    primary: kWhiteColor,
                    minimumSize: Size(5, 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.borderButtonRadius),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("accident").orderBy("date_posted").snapshots(),
                    builder:  (context,AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(snapshot.data!.docs.length > 5 ? 5 : snapshot.data!.docs.length,(index) {

                                  QueryDocumentSnapshot data = snapshot.data!
                                      .docs[index];

                                  String docId = data.id;
                                  if (snapshot.hasData) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: PaddingConstant.kPadding * 2,
                                        right: PaddingConstant.kPadding,
                                        left: index == 0 ? PaddingConstant.kPadding : 0,
                                      ),
                                      child: Column(
                                          children: [
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(Sizes.borderRadius),
                                              ),
                                              elevation: 4,
                                              child: InkWell(
                                                onTap:() {
                                                  print("CLICK $docId");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => AccidentDetailsPage(docId,data["month"])));
                                                },
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                                                  child: CachedNetworkImage(
                                                    imageUrl: data["image"],
                                                    placeholder: (context, url) => new CircularProgressIndicator(),
                                                    imageBuilder: (context, imageProvider) => GFAvatar(
                                                      backgroundImage:imageProvider,
                                                      shape: GFAvatarShape.standard,
                                                      radius: 70,

                                                    ),
                                                    errorWidget: (context, url, error) => GFAvatar(
                                                      backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/cdrrmo-83dcf.appspot.com/o/event-default-img-med.png?alt=media&token=7936ae0a-c825-4722-a547-687a4f47b20b'),
                                                      shape: GFAvatarShape.standard,
                                                      radius: 70,

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            Container(
                                              width: Sizes.containerSize,
                                              child: Text("New Accident"),
                                            ),
                                            Container(
                                              width: Sizes.containerSize,
                                              child: FutureBuilder(
                                                future: _getAddressFromLatLng(double.parse(data["latitude"]),double.parse(data["longitude"])),
                                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                                  switch (snapshot.connectionState) {
                                                    case ConnectionState.waiting: return Text('Loading....');
                                                    default:
                                                      if (snapshot.hasError)
                                                        return Text('Error: ${snapshot.error}');
                                                      else
                                                        return Text('Reported by : ${data["name"]} at ${snapshot.data}');
                                                  }
                                                }
                                              )
                                            ),
                                          ],
                                        ),

                                    );
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(),);
                                },
                                ),
                              );
                            }
                          }
                      }
                    }
                )
              ]
            ),
          ),
        ],
      ),
    );
  }
}
