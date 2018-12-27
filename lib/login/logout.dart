import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
//LOGOUT

void logOut(FirebaseAuth auth, BuildContext context) {
  if (auth.currentUser() != null)
    auth.signOut().then((val) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/login');
    }).catchError((e) => print(e));
}
