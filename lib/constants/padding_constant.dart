import 'package:flutter/material.dart';

class PaddingConstant {
  static PaddingConstant instance = PaddingConstant._init();
  PaddingConstant._init();

  static double kPadding = 8.0;
  final kDefaultPadding = EdgeInsets.symmetric(horizontal: 30);
  final kFabPadding =  EdgeInsets.symmetric(horizontal: 40);
  final kLeftPadding =  EdgeInsets.only(left: 50.0);
  final kRightPadding =  EdgeInsets.only(right: 50.0);
  final kResetTopPadding = EdgeInsets.only(top: 20.0);
}