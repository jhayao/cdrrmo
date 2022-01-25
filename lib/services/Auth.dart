import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medicare/models/userModel.dart';
import 'package:medicare/models/loginModel.dart';
import 'package:medicare/services/database.dart';
class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  userModel? _userDetails(User? user){
    return user != null ? userModel(uid: user.uid) : null;
  }

  loginModel? errors(String message, bool err,User? user)
  {
    return user != null ? loginModel(message: message, error: err,uid:user.uid) : loginModel(message: message, error: err,uid:"");
    // return errorModel(message: message, error: error);
  }
  Stream<userModel?> get user{
    return _auth.authStateChanges().
    map((User? user) => user!.emailVerified ? _userDetails(user)! : null ) ;
    // map(_userDetails);
  }

  Future signInWithFacebook() async{
    final facebookLoginResult = await FacebookAuth.instance.login();
    final userData = await FacebookAuth.instance.getUserData();

    final facebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
    try{
      UserCredential result =  await _auth.signInWithCredential(facebookAuthCredential);
      User? user = result.user;
      await DatabaseService(uid: user!.uid.toString()).updateUserData(userData['name'], "","",userData['email']);
      return _userDetails(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signInWithFacebook2() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if(result.status == LoginStatus.success){
      // Create a credential from the access token
      final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
      try{
        UserCredential result =  await _auth.signInWithCredential(credential);
        User? user = result.user;
        print("User Name: ${user!.displayName}");
        print("User Email ${user.email}");
        await DatabaseService(uid: user!.uid.toString()).updateUserData(user.displayName! , "","",user.email!);
        return _userDetails(user!);
      }catch(e){
        print(e.toString());
        return null;
      }
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    return null;
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance.signInWithCredential(credential);
    try{

      UserCredential result =  await _auth.signInWithCredential(credential);
      User? user = result.user;
      print("User Name: ${user!.displayName}");
      print("User Email ${user.email}");
      await DatabaseService(uid: user!.uid.toString()).updateUserData(user.displayName! , "","",user.email!);
       _userDetails(user!);
      return errors('Succesfully Login', false, user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign in anon




  //sign in with email and password

  Future signInEmailPassword(String email, String password) async{
    String errorMessage;
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if(user!.emailVerified)
        return errors('Succesfully Login', false, user);
      else
        return errors("Email not verified", true, null);
    }catch(e){
      return errors(e.toString(), true, null);
      // return null;
    }
  }
  //register with email and password

  Future registerWithEmailPassword(String email, String password,String name) async{
    String errorMessage;
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      user!.sendEmailVerification();
      // return _userDetails(user)?.uid;
      await DatabaseService(uid: user!.uid.toString()).updateUserData(name, "","",email);

      return errors('Succesfully Login', false, user);
    }catch(e){

      return errors(e.toString(), true, null);
      // return null;
    }
  }

  //sign out

  Future signOut() async{
    try{

      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}