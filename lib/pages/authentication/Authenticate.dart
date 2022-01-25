import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicare/pages/authentication/pages/login_page.dart';




class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TheGorgeousLogin',
      home: LoginPage(),
    );
  }
}
