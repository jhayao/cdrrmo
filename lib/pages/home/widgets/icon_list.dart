
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicare/constants/padding_constant.dart';
import 'package:medicare/models/icon_model.dart';

final List<IconModel> headerImage = IconModel.icons;

Widget buildIconList() => Padding(
      padding: EdgeInsets.only(bottom: PaddingConstant.kPadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              headerImage.length,
                  (index) => Container(
                    width: 100,
                    child: Column(
                      children: [
                        Image.asset(headerImage[index].icon, height: 50, width: 50,),
                        SizedBox(height: 10,),
                        Text(headerImage[index].title, textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
            )

        ),
      ),
    );
