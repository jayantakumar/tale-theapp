import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'animatedwave.dart';
import 'authnavigator.dart';
import 'blocs/bloc.dart';

class Login extends StatelessWidget {
  //initial declaration of variables
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _email, _password;
  Bloc bloc = new Bloc();

  //email and pass handler

  Future<FirebaseUser> emailHandler() async {
    bloc.password.listen((password) => _password = password);
    print(_password);
    bloc.email.listen((email) => _email = email);
    print(_email);
    //bloc._password = preferences.get("password");

    FirebaseUser user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password);
    print(user);
    return user;
  }

  //google sign in handler to handle log in using google

  Future<FirebaseUser> googleSignInHandler() async {
    //google initialisers

    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    //creating firebase

    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    print("signed in " + user.displayName);

    return user;
  }

  //focus nodes to handle focusing of cursor

  final FocusNode mailFocus = new FocusNode();
  final FocusNode passFocus = new FocusNode();

  //widget builder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  color: Colors.pink,
                  width: double.infinity,
                  height: 220,
                ),
                Positioned(
                  bottom: 0.0,
                  child: Container(
                    child: Wave(
                      size: Size(
                        MediaQuery.of(context).size.width,
                        100,
                      ),
                      xOffset: 400,
                      yOffset: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 20),
                    child: SafeArea(
                      child: SvgPicture.asset(
                        "assets/tales.svg",
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 20, right: 25),
              child: Column(
                //mainAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "LogIn",
                    textScaleFactor: 3.0,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  StreamBuilder<String>(
                    stream: bloc.email,
                    builder: (context, snapshot) => TextField(
                          onSubmitted: (s) =>
                              FocusScope.of(context).requestFocus(passFocus),
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.pink,
                          obscureText: false,
                          onChanged: (s) {
                            bloc.emailChanged(s);
                            _email = s;
                          },
                          decoration: inputDec("Email", snapshot),
                        ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  StreamBuilder<String>(
                    stream: bloc.password,
                    builder: (context, snapshot) => TextField(
                          focusNode: passFocus,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.pink,
                          obscureText: true,
                          onChanged: (s) {
                            bloc.passwordChanged(s);
                            _password = s;
                          },
                          decoration: inputDec("Password", snapshot),
                        ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () => (context) {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                      child: Text(
                        "Forget Password?",
                        textScaleFactor: 1.1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: StreamBuilder<bool>(
                      stream: bloc.canSubmit,
                      builder: (context, snapshot) => FloatingActionButton(
                            onPressed: () {
                              snapshot.hasData ? loginWithEmail(context) : null;
                            },
                            child: Icon(
                              Icons.check,
                              size: 30,
                            ),
                            shape: CircleBorder(
                              side: BorderSide(color: Colors.black, width: 2.0),
                            ),
                            elevation: 0.0,
                            highlightElevation: 0.0,
                            backgroundColor: Colors.pink,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //functions related to login , logout etc...

  //LOGIN with google

  void loginWithGoogle(BuildContext context) async {
    googleSignInHandler().then((FirebaseUser user) {
      print(user);
      var nav = AuthNavigator();
      nav.StoreUser(user, context);
    }).catchError((e) => print(e));
  }

  //LOGIN with email

  void loginWithEmail(BuildContext context) async {
    emailHandler().then((FirebaseUser user) {
      print(user);
      var nav = AuthNavigator();
      nav.StoreUser(user, context);
    }).catchError((e) => print(e));
  }
}

InputDecoration inputDec(String label, AsyncSnapshot snapshot) {
  return InputDecoration(
    errorText: snapshot.error,
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.red, width: 4),
    ),
    labelStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 4),
      borderRadius: BorderRadius.circular(0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.black54, width: 4),
    ),
    labelText: label,
  );
}
/*
Widget googleWidget(BuildContext context) {
  return FlatButton(
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide(color: Colors.black, width: 4.0),
      ),
      onPressed: () => loginWithGoogle(context),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          SvgPicture.asset(
            "assets/google.svg",
            height: 30.0,
            width: 30.0,
          ),
          SizedBox(
            width: 24,
          ),
          Text(
            "Sign in".toUpperCase(),
            style: TextStyle(fontSize: 30),
          ),
        ],
      ));*/
