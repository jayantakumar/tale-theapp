import 'package:flutter/material.dart';
import 'package:tale/diary/ui/addActivity.dart';
import 'package:tale/home/bottombary.dart';
import 'package:tale/floater.dart';
import 'dairyUi.dart';

const Color color = Color(0xFF00D67E);

class AddUI extends StatefulWidget {
  @override
  _AddUIState createState() => _AddUIState();
}

class _AddUIState extends State<AddUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Floater(
        icon: Icons.close,
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/diary');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Hero(
              tag: "AppBar",
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 8,
                color: color,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "SELECT YOUR MOOD",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ),
                alignment: Alignment.centerLeft,
                foregroundDecoration: ShapeDecoration(
                    shape: Border(
                        bottom: BorderSide(width: 4, color: Colors.black))),
              ),
            ),
            Center(
              child: Container(
                  height: MediaQuery.of(context).size.height / 1.25,
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        //mainAxisSpacing: 10,
                      ),
                      itemCount: path.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              SlideRightRoute(
                                  widget: AddActivity(emotions[index]))),
                          child: Center(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    path[index],
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                                  Text(
                                    emotions[index],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15),
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )),
            )
          ],
        ),
      ),
      bottomNavigationBar: Hero(
        child: BottomBary(color: color),
        tag: "BottomBar",
      ),
    );
  }
}

const List<String> path = [
  "assets/emotions/happy.png",
  "assets/emotions/angry.png",
  "assets/emotions/awful.png",
  "assets/emotions/bored.png",
  "assets/emotions/cool.png",
  "assets/emotions/fear.png",
  "assets/emotions/amazed.png",
  "assets/emotions/laugh.png",
  "assets/emotions/love.png",
  "assets/emotions/meh.png",
  "assets/emotions/pleasent.png",
  "assets/emotions/sad.png",
  "assets/emotions/shy.png",
  "assets/emotions/sleepy.png",
  "assets/emotions/tounge.png",
];

const List<String> emotions = [
  "Happy",
  "Angry",
  "Awful",
  "Bored",
  "Cool",
  "Fear",
  "Amazed",
  "Laugh",
  "Love",
  "Meh",
  "Nice",
  "Sad",
  "Shy",
  "Sleepy",
  "Wacky",
];

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new FadeTransition(
            opacity: new Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(parent: animation, curve: Curves.decelerate)),
            child: child,
          );
        });
}
