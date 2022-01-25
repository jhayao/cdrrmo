
import 'package:flutter/material.dart';
import 'package:medicare/constants/icons_constants.dart';
import 'package:medicare/constants/padding_constant.dart';
import 'package:medicare/constants/sizes_constants.dart';
import 'package:medicare/constants/theme.dart';

Widget buildSearchBar() => Padding(
      padding: EdgeInsets.all(2 * PaddingConstant.kPadding),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Bir kitap arayın",
          fillColor: kBlack.withOpacity(0.1),
          filled: true,
          prefixIcon: IconsConstants.instance.iconSearch,
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: PaddingConstant.kPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.searchRadius),
            borderSide: BorderSide.none
          ),
        ),
      ),
    );
