
import 'package:flutter/material.dart';
import 'package:medicare/constants/icons_constants.dart';
import 'package:medicare/constants/padding_constant.dart';
import 'package:medicare/constants/sizes_constants.dart';
import 'package:medicare/constants/theme.dart';
import 'package:medicare/models/book_model.dart';
import 'package:medicare/pages/book/widgets/book_display.dart';
import 'package:medicare/pages/book/widgets/description.dart';

class BookPage extends StatefulWidget {
  BookPage({required this.book});

  final BookModel book;

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: IconsConstants.instance.iconArrowLeft,
          color: kBlack87,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(PaddingConstant.kPadding),
            child: IconButton(
              onPressed: (){
                setState(() {
                  widget.book.favorite = !widget.book.favorite;
                });
              },
              icon: widget.book.favorite ? IconsConstants.instance.iconFavorite : IconsConstants.instance.iconFavoriteBorder,
              color: kRed,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: Sizes.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: PaddingConstant.kPadding * 4,
            ),
            child: Column(
              children: [
                ...buildBookDisplay(book: widget.book),
                ...buildDescription(book: widget.book),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
