import 'package:flutter/material.dart';
import 'package:medicare/models/userModel.dart';
import 'package:medicare/services/database.dart';
import 'package:provider/provider.dart';

class EmailField extends StatefulWidget {
  const EmailField({Key? key, required this.deviceWidth}) : super(key: key);
  final double deviceWidth;
  @override
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  bool _isEditingEmailText = false;
  String email = "John.doe@gmail.com";
  late TextEditingController _nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController(text: email);
  }
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<userModel?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid!).userData,
        builder: (context, snapshot) {
    if (snapshot.hasData) {
      UserData? userData = snapshot.data;
      email = userData!.email;

      _nameController = TextEditingController(text: email);

      if (_isEditingEmailText)
        return Container(
          width: widget.deviceWidth,
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0.0),
            ),
            onSubmitted: (newValue) async {
              setState(() {
                email = newValue;
                _isEditingEmailText = false;
              });
              await DatabaseService(uid: user.uid.toString()).updateUserDataEmail(email);
            },
            autofocus: true,
            controller: _nameController,
          ),
        );
      return InkWell(
          onTap: () {
            setState(() {
              _isEditingEmailText = true;
            });
          },
          child: Container(
            width: widget.deviceWidth,
            padding: EdgeInsets.only(
                bottom: 3, left: 4 // space between underline and text
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: Colors
                          .black, // Text colour here // Underline width
                    ))),
            child: Text(
              email,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ));
    }
    return InkWell(
        onTap: () {
          setState(() {
            _isEditingEmailText = true;
          });
        },
        child: Container(
          width: widget.deviceWidth,
          padding: EdgeInsets.only(
              bottom: 3, left: 4 // space between underline and text
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color: Colors
                        .black, // Text colour here // Underline width
                  ))),
          child: Text(
            email,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
        ));
  });
  }
}
