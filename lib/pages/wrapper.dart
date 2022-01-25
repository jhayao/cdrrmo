import 'package:flutter/material.dart';
import 'package:medicare/pages/bottom_nav.dart';
import 'authentication/Authenticate.dart';
import 'package:medicare/models/userModel.dart';
import 'package:provider/provider.dart';

import 'home/home_page.dart';
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userModel?>(context);
    print(user);
    if(user == null)
      {
        return Authenticate();
      }
    else
      {
        return HomePage();
      }
  }
}
