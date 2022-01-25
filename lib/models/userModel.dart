class userModel{

  late final String uid;

  userModel({required this.uid});

}

class UserData{
  final String name;
  final String address;
  final String email;
  final String phone;
  final String uid;
  final String userType;
  UserData(this.name, this.address, this.email, this.phone,this.uid,this.userType );

}