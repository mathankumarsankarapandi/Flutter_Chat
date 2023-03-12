import 'package:chat/CommonFiles/CommonWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServices extends ChangeNotifier{

  final FirebaseAuth firebaseAuth;


  FirebaseAuthServices(this.firebaseAuth);

  Stream<User?> get authStateChanges => firebaseAuth.idTokenChanges();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future<String> googleLogIn() async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) {
      return "Unable Sign in";
    }

    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
    await firebaseAuth.signInWithCredential(credential);

    await firebaseFirestore.collection('users').doc(_user!.id).set(
        {
          'name': _user!.displayName!,
          'email': _user!.email,
          'followStatus': "follow",
          'status': "UnAvailable",
          'userId': _user!.id,
          'photoUrl': _user!.photoUrl!
        });
   return "Sign";
  }

  Future logout() async{
    try {
      await googleSignIn.disconnect();
    } catch (e,s) {
      CommonWidgets().printLog("Exception${e.toString()}");
      CommonWidgets().printLog("Exception${s.toString()}");
    }
    FirebaseAuth.instance.signOut();
  }

  Future<String> login(String email, String password,BuildContext context) async {
    try {
      final authResult =
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    if (authResult.user != null) {
      return "LogIn";

    } else {
      return "Wrong user";
    }

    } catch (e,s) {
      CommonWidgets().printLog("Exception${e.toString()}");
      CommonWidgets().printLog("Exception${s.toString()}");
      return e.toString();
    }
  }

  Future<String> signIn(String email, String password,BuildContext context,String name) async {
    try {
      final authResult =
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    if (authResult.user != null) {
      await firebaseFirestore.collection('users').doc(firebaseAuth.currentUser!.uid).set(
          {
            'name': name,
            'email': email,
            'followStatus': "follow",
            'status': "UnAvailable",
            'userId': firebaseAuth.currentUser!.uid,
            'photoUrl': firebaseAuth.currentUser!.photoURL
          });
      return "signIn";
    } else {
      return "Wrong user";
    }

    } catch (e,s) {
     CommonWidgets().printLog("Exception${e.toString()}");
     CommonWidgets().printLog("Exception${s.toString()}");
      return e.toString();
    }
  }

}