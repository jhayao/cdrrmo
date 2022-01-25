import 'package:flutter/material.dart';
import 'package:medicare/models/userModel.dart';
import 'package:medicare/services/database.dart';
import 'package:provider/provider.dart';

class AddressField extends StatefulWidget {
  const AddressField({Key? key, required this.deviceWidth}) : super(key: key);
  final double deviceWidth;
  @override
  _AddressFieldState createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {
  bool _isEditingAddressText = false;
  String address = "";
  late TextEditingController _nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController(text: address);
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userModel?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid!).userData,
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    UserData? userData = snapshot.data;
    address = userData!.address;
    _nameController.text = address;
    if (_isEditingAddressText)
      return Container(
        width: widget.deviceWidth,
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0.0),
          ),
          onSubmitted: (newValue) async{
            setState(() {
              address = newValue;
              _isEditingAddressText = false;
            });
            await DatabaseService(uid: user.uid.toString()).updateUserDataAddress(address);
          },
          autofocus: true,
          controller: _nameController,
        ),
      );
    return InkWell(
        onTap: () {
          setState(() {
            _isEditingAddressText = true;
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
            address,
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
            _isEditingAddressText = true;
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
            address,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
        ));
    }
  );

    }

}
