import 'package:flutter/material.dart';
import 'package:medicare/models/userModel.dart';
import 'package:medicare/services/database.dart';
import 'package:provider/provider.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({Key? key, required this.deviceWidth}) : super(key: key);
  final double deviceWidth;
  @override
  _PhoneFieldState createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  bool _isEditingPhoneNumber = false;
  String phone = "9999999999";
  late TextEditingController _nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController(text: phone);
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userModel?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid!).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            phone = userData!.phone;
            _nameController.text = phone;
            if (_isEditingPhoneNumber)
              return Container(
                width: widget.deviceWidth,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                  ),
                  onSubmitted: (newValue) async{
                    setState(() {
                      phone = newValue;
                      _isEditingPhoneNumber = false;
                    });
                    await DatabaseService(uid: user.uid.toString()).updateUserDataPhone(phone);
                  },
                  autofocus: true,
                  controller: _nameController,
                ),
              );
            return InkWell(
                onTap: () {
                  setState(() {
                    _isEditingPhoneNumber = true;
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
                    phone,
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
                  _isEditingPhoneNumber = true;
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
                  phone,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
              ));
        });
  }
}
