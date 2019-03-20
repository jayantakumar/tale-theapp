import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:tale/diary/ui/addActivity.dart';
import 'package:tale/home/bottombary.dart';
import 'package:tale/floater.dart';
import 'package:tale/style/routeTransitionAnimation.dart';
import 'dairyUi.dart';

const Color color = Color(0xFF00D67E);

class AddUI extends StatefulWidget {
  @override
  _AddUIState createState() => _AddUIState();
  AddUI(this.controller);
  final PageController controller;
}

class _AddUIState extends State<AddUI> {
  final subject = new PublishSubject<int>();
  @override
  void initState() {
    path = [];
    subject.stream.debounce(new Duration(milliseconds: 300)).listen(_onChanged);
    Future.delayed(Duration(milliseconds: 300)).then((a) => subject.add(1));
    super.initState();
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Floater(
        icon: Icons.close,
        onPressed: () {
          Navigator.of(context).pop();
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
                height: 80,
                color: Colors.pink,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Select your mood",
                    textScaleFactor: 1.5,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            Center(
              child: Container(
                  height: MediaQuery.of(context).size.height / 1.25,
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: AnimatedOpacity(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          //mainAxisSpacing: 10,
                        ),
                        itemCount: path.length,
                        itemBuilder: (context, int index) {
                          return InkWell(
                            onTap: () => Navigator.of(context).push(
                                  SlideRoute(
                                    initialSlideOffset: Offset(1, 0),
                                    widget: AddActivity(
                                        emotions[index], widget.controller),
                                  ),
                                ),
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
                      duration: Duration(milliseconds: 800),
                      opacity: path.isEmpty ? 0 : 1,
                    ),
                  )),
            )
          ],
        ),
      ),
      bottomNavigationBar: Hero(
        child: BottomBary(color: Colors.pink),
        tag: "BottomBar",
      ),
    );
  }

  void _onChanged(int event) {
    setState(() {
      path = [
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
    });
  }
}

List<String> path;
//emotions
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
