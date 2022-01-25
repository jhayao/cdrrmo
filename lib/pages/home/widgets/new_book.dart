
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:medicare/constants/icons_constants.dart';
import 'package:medicare/constants/padding_constant.dart';
import 'package:medicare/constants/sizes_constants.dart';
import 'package:medicare/constants/theme.dart';
import 'package:medicare/models/book_model.dart';
import 'package:medicare/pages/book/accident_page.dart';

class BuildNewBook extends StatelessWidget {
   BuildNewBook({Key? key}) : super(key: key);

  final newBook = BookModel.newBook;
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
   GoogleMapController ? _controller;
   Location _location = Location();

   void _onMapCreated(GoogleMapController _cntlr)
   {
     _controller = _cntlr;
     _location.onLocationChanged.listen((l) {
       _controller!.animateCamera(
         CameraUpdate.newCameraPosition(
           CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 15),
         ),
       );
     });
   }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 2 * PaddingConstant.kPadding, vertical: PaddingConstant.kPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Map",
                style: subTitle.copyWith(color: kBlack),
              ),
              IconsConstants.instance.iconArrowRight,
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BookPage(book: newBook,)));
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: PaddingConstant.kPadding),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.newBookRadius),
                  ),
                  elevation: 10,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: _initialcameraposition),
                    mapType: MapType.normal,
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                  ),
                ),
              ),

            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom,)
      ],
    );
  }
}
