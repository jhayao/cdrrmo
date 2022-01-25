
import 'package:flutter/material.dart';
import 'package:medicare/constants/padding_constant.dart';
import 'package:medicare/constants/sizes_constants.dart';
import 'package:medicare/constants/theme.dart';
import 'package:medicare/models/book_model.dart';


List<Widget> buildDescription({required BookModel book}) => [
  Expanded(
    child: Padding(
      padding: EdgeInsets.all(PaddingConstant.kPadding),
      child: SingleChildScrollView(
        child: Text(
          book.description,
          textAlign: TextAlign.justify,
        ),
      ),
    ),
  ),
  Padding(
    padding: EdgeInsets.all(PaddingConstant.kPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Paylaş"),
        TextButton(
          onPressed: () {},
          child: Text("  Kolayca Satın Al  "),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
                vertical: 4.0, horizontal: PaddingConstant.kPadding),
            minimumSize: Size(5, 5),
            backgroundColor: kDeepOrange,
            primary: kWhiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Sizes.borderButtonRadius,
              ),
            ),
          ),
        ),
      ],
    ),
  )
];
