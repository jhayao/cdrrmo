
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:medicare/constants/padding_constant.dart';
import 'package:medicare/constants/sizes_constants.dart';
import 'package:medicare/constants/theme.dart';
import 'package:medicare/models/book_model.dart';
import 'package:medicare/pages/book/accident_page.dart';

import '../../doctor_details.dart';

final List<BookModel> books = BookModel.book;

class UpdateList extends StatefulWidget {
  const UpdateList({Key? key}) : super(key: key);

  @override
  State<UpdateList> createState() => _UpdateListState();
}

class _UpdateListState extends State<UpdateList> {

  StreamBuilder ? _widget;
  // TODO your stream
  var myStream = FirebaseFirestore.instance.collection("accident").orderBy("date_posted").snapshots();


  @override
  void initState() {
    super.initState();

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
                  "Updates",
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
                    stream: FirebaseFirestore.instance.collection("updates").orderBy("date_posted").snapshots(),
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
                                                      MaterialPageRoute(builder: (context) => DoctorDetailsPage(docId)));
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
                                              child: Text(data["title"]),
                                            ),
                                            Container(
                                              width: Sizes.containerSize,
                                              child: Text(
                                                (data["description"].length < 10) ? data["description"] : data["description"].substring(0,10) + "..." ,
                                                style:
                                                TextStyle(fontSize: 10, color: kBlueGrey),
                                              ),
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
