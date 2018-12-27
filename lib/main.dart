import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tale/floater.dart';
import 'package:tale/home/Home_title.dart';
import 'package:tale/home/TopIcon.dart';
import 'package:tale/home/bottombary.dart';
import 'package:tale/home/cardy.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tale/login/logout.dart';
import 'package:tale/login/signup.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(MyApp());
}

FirebaseAuth auth = FirebaseAuth.instance;

var myTheme = ThemeData(
    primaryColor: Colors.yellow,
    fontFamily: "Courier",
    primaryTextTheme: TextTheme(
      title: TextStyle(
          fontFamily: "Courier",
          fontWeight: FontWeight.bold,
          color: Colors.black),
    ));

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _name = "Lyon";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      color: Colors.yellow,
      debugShowCheckedModeBanner: false,
      home: auth.currentUser() == null ? Login() : Home(name: _name),
      routes: <String, WidgetBuilder>{
        '/login': (_) => new Login(),
        '/home': (_) => Home(name: _name),
        '/signup': (_) => new Signup(),
      },
    );
  }
}

class Home extends StatelessWidget {
  Home({
    Key key,
    @required String name,
  })  : _name = name,
        super(key: key);

  final String _name;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar:
      floatingActionButton: new Floater(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                titleSpacing: 5.0,
                title: new HomeTitle(name: _name),
                leading: SafeArea(
                  child: TopIcon('assets/tales.svg'),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                    onPressed: () {
                      logOut(_auth, context);
                    },
                  )
                ],
              ),
              SliverStaggeredGrid.count(
                crossAxisCount: 8,
                staggeredTiles: tiles,
                children: i,
              ),
            ],
          )),
      bottomNavigationBar: new BottomBary(),
    );
  }
}

List<Widget> i = [
  Padding(
    padding: const EdgeInsets.only(bottom: 30.0),
    child: Cardy(
      title: "Stories",
      color: Colors.pink,
      subtitle: "Write your story",
    ),
  ),
  Cardy(
    justified: true,
    title: "Todo",
    color: Colors.purpleAccent,
    body: Icon(
      Icons.add,
      color: Colors.white,
      size: 80,
    ),
  ),
  Cardy(
    title: "",
    color: Colors.lightBlue,
    body: Icon(
      Icons.add,
      color: Colors.white,
      size: 80,
    ),
  ),
  Cardy(
    title: "",
    color: Colors.deepOrangeAccent,
    body: Icon(
      Icons.add,
      color: Colors.white,
      size: 80,
    ),
  ),
  Padding(
    padding: const EdgeInsets.only(top: 30.0),
    child: Cardy(
      title: "",
      color: Colors.teal,
      body: Text(
        "Today".toUpperCase(),
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
      ),
    ),
  ),
  Padding(
    padding: const EdgeInsets.only(top: 30.0),
    child: Cardy(
      title: "Goals",
      color: Colors.purpleAccent,
      body: Icon(
        Icons.add,
        color: Colors.white,
        size: 80,
      ),
    ),
  ),
  Cardy(
    title: "",
    color: Colors.pinkAccent,
    body: Text(
      "habits".toUpperCase(),
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
    ),
  ),
  Container(
    color: Colors.transparent,
  ),
];

List<StaggeredTile> tiles = [
  const StaggeredTile.count(8, 5),
  const StaggeredTile.count(4, 6),
  const StaggeredTile.count(4, 3),
  const StaggeredTile.count(4, 3),
  const StaggeredTile.count(4, 3),
  const StaggeredTile.count(4, 6),
  const StaggeredTile.count(4, 3),
  const StaggeredTile.count(8, 1),
];
