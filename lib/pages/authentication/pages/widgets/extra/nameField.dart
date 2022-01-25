import 'package:flutter/material.dart';
import 'package:medicare/models/userModel.dart';
import 'package:medicare/services/database.dart';
import 'package:provider/provider.dart';

class NameField extends StatefulWidget {
  const NameField({Key? key, required this.deviceWidth}) : super(key: key);
  final double deviceWidth;

  @override
  _NameFieldState createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  bool _isEditingNameText = false;
  String name = "";
  late TextEditingController _nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController(text: name);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userModel?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid!).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            name= userData!.name;
            _nameController = TextEditingController(text: name);
            if (_isEditingNameText)
              return Container(
                width: widget.deviceWidth,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                  ),
                  onSubmitted: (newValue)async {
                    setState(() {
                      name = newValue;
                      _isEditingNameText = false;
                    });
                    await DatabaseService(uid: user.uid.toString()).updateUserDataName(name);
                  },
                  autofocus: true,
                  controller: _nameController,
                ),
              );
            return InkWell(
                onTap: () {
                  setState(() {
                    _isEditingNameText = true;
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
                    color: Colors.black, // Text colour here // Underline width
                  ))),
                  child: Text(
                    name,
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
                  _isEditingNameText = true;
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
                          color: Colors.black, // Text colour here // Underline width
                        ))),
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
              ));
        });

  }
}
