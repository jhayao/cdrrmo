
import 'package:flutter/material.dart';
import 'package:medicare/constants/padding_constant.dart';

List<Widget> buildHeader(String name,String url,String email) =>
    [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 2 * PaddingConstant.kPadding, top: PaddingConstant.kPadding ),
            child: Text("$name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 2 * PaddingConstant.kPadding),
            child: CircleAvatar(
              backgroundImage: NetworkImage(url),
            ),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 2 * PaddingConstant.kPadding, vertical: PaddingConstant.kPadding),
        child: Text("$email", style: TextStyle(color: Colors.black54),),
      ),
    ];