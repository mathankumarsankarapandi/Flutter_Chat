import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthServices {

  final FirebaseAuth firebaseAuth;

  FirebaseAuthServices(this.firebaseAuth);

  Stream<User?> get authStateChanges => firebaseAuth.idTokenChanges();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

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
      print("Exception${e.toString()}");
      print("Exception${s.toString()}");
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
            'userId': firebaseAuth.currentUser!.uid
          });
      return "signIn";
    } else {
      return "Wrong user";
    }

    } catch (e,s) {
      print("Exception${e.toString()}");
      print("Exception${s.toString()}");
      return e.toString();
    }
  }
}