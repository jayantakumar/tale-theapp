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
import 'package:tale/login/Signupmaster.dart';
import 'login/loginMaster.dart';
import 'package:tale/todo/todo.dart';
import 'todo/ui/todomain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tale/remainder/mainui.dart';

FirebaseAuth auth = FirebaseAuth.instance;
bool hasloggedin = false;

void main() {
  hasloggedin = auth.currentUser() == null;
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(MyApp());
}

var myTheme = ThemeData(
    //buttonColor: Colors.white,
    primaryColor: Colors.yellow,
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
  ListOfTodo(),
];

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _name = "Lyon";

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
      home: ReminderList(),
      // home: hasloggedin ? LoginMaster() : Home(name: _name),
      routes: <String, WidgetBuilder>{
        '/login': (_) => new Login(),
        'pages': (_) => new Pages(),
        '/home': (_) => Home(name: _name),
        '/signup': (_) => new Signup(),
        '/signupMaster': (_) => new SignUpMaster(),
        '/loginMaster': (_) => new LoginMaster(),
        '/todo': (_) => new ListOfTodo(),
        '/reminder': (_) => new ReminderList(),
      },
    );
  }
}

class Pages extends StatefulWidget {
  int pageNo;

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

  PageController controller;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      pageSnapping: true,
      scrollDirection: Axis.horizontal,
      controller: controller,
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
                backgroundColor: Colors.white,
                elevation: 0,
                titleSpacing: 5.0,
                title: new HomeTitle(name: widget._name),
                leading: SafeArea(
                  child: TopIcon('assets/tales.svg'),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                    onPressed: () async {
                      logOut(_auth, context);
                    },
                  )
                ],
              ),
              SliverStaggeredGrid.count(
                crossAxisCount: 8,
                staggeredTiles: tiles,
                children: listReturner(context),
              ),
            ],
          )),
      bottomNavigationBar: new BottomBary(),
    );
  }

  List<Widget> listReturner(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Cardy(
          title: "Stories",
          color: Colors.pink,
          subtitle: "Write your story",
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/todo');
        },
        child: Cardy(
            justified: true,
            title: "Todo",
            color: Colors.purpleAccent,
            body: Icon(
              Icons.add,
              color: Colors.white,
              size: 80,
            )),
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
  }

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
}
