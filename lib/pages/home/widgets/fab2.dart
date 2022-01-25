
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicare/constants/icons_constants.dart';
import 'package:medicare/constants/padding_constant.dart';
import 'package:medicare/constants/sizes_constants.dart';
import 'package:medicare/constants/theme.dart';
import 'package:medicare/models/data.dart';
import 'package:medicare/pages/home/widgets/examples.dart';
import 'package:medicare/pages/home/widgets/pdfMain.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';


class BuildFab2 extends StatefulWidget {
  const BuildFab2({Key? key}) : super(key: key);

  @override
  _BuildFab2State createState() => _BuildFab2State();
}

class _BuildFab2State extends State<BuildFab2> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> monthFilters;
  late Future<String> _counter;
  @override
  void initState() {
    super.initState();
    getTest();
    //running initialisation code; getting prefs etc.
  }



  Future<String?> getTest() async{
    final SharedPreferences prefs = await _prefs;
    final String?  counter = prefs.getString('monthFilter') ;
    print("Test : $counter");
    return prefs.getString('monthFilter');

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
                        "Save As",
                        style: TextStyle(
                            color: kBlack54,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),
                  SizedBox(height: PaddingConstant.kPadding,),
                  _buildCategory(
                      category: "PDF",
                      iconData: IconsConstants.instance.iconBook,
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
        IconsConstants.instance.iconPrint,
        color: kBlue,
      ),
    );
  }
  Future<void> _saveAsFile(
      BuildContext context,
      LayoutCallback build,
      PdfPageFormat pageFormat,
      ) async {
    final bytes = await build(pageFormat);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File(appDocPath + '/' + 'document.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }


  Widget _buildCategory({
    required String category,
    required IconData iconData,
    required Color color,
    required String  type,
    required BuildContext context

  }) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveAsFile,
        )
    ];
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: PaddingConstant.kPadding,
      ),
      child: InkWell(
        onTap: () {
            print("PDF");
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pdfMain()));
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
}
