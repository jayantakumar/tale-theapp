import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tale/floater.dart';
import 'package:tale/home/Home_title.dart';
import 'package:tale/home/TopIcon.dart';
import 'package:tale/home/bottombary.dart';
import 'package:tale/home/cardy.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nima/nima_actor.dart';
import 'login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tale/login/logout.dart';
import 'package:tale/login/signup.dart';
import 'package:tale/login/Signupmaster.dart';
import 'login/loginMaster.dart';
import 'package:tale/todo/todo.dart';
import 'package:tale/style/routeTransitionAnimation.dart';
import 'todo/ui/todomain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:tale/diary/ui/dairyUi.dart";
import 'package:tale/diary/ui/addEventUi.dart';

//LIST OF GLOBAL VARIABLES
PageController controller;
FirebaseAuth auth = FirebaseAuth.instance;
bool hasLoggedIn = false;
var myTheme = ThemeData(
    //buttonColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Courier",
    primaryTextTheme: TextTheme(
      title: TextStyle(
          fontFamily: "Courier",
          fontWeight: FontWeight.bold,
          color: Colors.black),
    ));
List<Widget> page = [
  Home(name: "Lyon"),
  ListOfTodo(controller),
  DiaryMainUI(controller),
];

//THE MAIN FUNCTION OF THE PACK

void main() {
  hasLoggedIn = auth.currentUser() == null;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    //check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      color: Colors.yellow,
      debugShowCheckedModeBanner: false,
      home: Pages(pageNo: 0),
      routes: <String, WidgetBuilder>{
        '/login': (_) => new Login(),
        '/diary': (_) => new Pages(pageNo: 2),
        '/home': (_) => Pages(pageNo: 0),
        '/signup': (_) => new Signup(),
        '/signupMaster': (_) => new SignUpMaster(),
        '/loginMaster': (_) => new LoginMaster(),
        '/todo': (_) => new Pages(pageNo: 1),
      },
    );
  }
}

class Pages extends StatefulWidget {
  final int pageNo;

  Pages({Key key, this.pageNo = 0}) : super(key: key);

  @override
  PagesState createState() {
    return new PagesState();
  }
}

class PagesState extends State<Pages> {
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.pageNo);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      pageSnapping: true,
      scrollDirection: Axis.horizontal,
      controller: controller,
      itemCount: page.length,
      itemBuilder: (BuildContext context, int index) {
        return page[index];
      },
    );
  }
}

class Home extends StatefulWidget {
  Home({
    Key key,
    @required String name,
  })  : _name = name,
        super(key: key);

  final String _name;

  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar:
      floatingActionButton: new Floater(icon: Icons.add),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(
                  "Home",
                  textScaleFactor: 1.55,
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: ""),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                titleSpacing: 30.0,
              ),
              SliverList(
                delegate: SliverChildListDelegate(listReturner(context)),
              ),
            ],
          )),
      bottomNavigationBar: new BottomBary(color: Colors.indigo),
    );
  }

  List<Widget> listReturner(BuildContext context) {
    double _height = 120;
    double _width = MediaQuery.of(context).size.width;
    return [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushAndRemoveUntil(
              SlideRoute(
                  widget: Pages(pageNo: 2), initialSlideOffset: Offset(1, 0)),
              (Route<dynamic> route) => false),
          child: Cardy(
            title: "Stories",
            height: _height,
            width: _width,
            color: Colors.pink,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushAndRemoveUntil(
              SlideRoute(
                  widget: Pages(pageNo: 1), initialSlideOffset: Offset(1, 0)),
              (Route<dynamic> route) => false),
          child: Cardy(
            height: _height,
            width: _width,
            title: "Todo",
            color: Colors.green,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Cardy(
          title: "Today",
          color: Colors.indigo,
          height: _height,
          width: _width,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Cardy(
          title: "Goals",
          color: Colors.redAccent,
          height: _height,
          width: _width,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Cardy(
          title: "HABITS",
          color: Colors.pinkAccent,
          height: _height,
          width: _width,
        ),
      ),
    ];
  }
}
