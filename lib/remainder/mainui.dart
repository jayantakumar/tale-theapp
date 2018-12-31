import 'package:flutter/material.dart';
import 'package:tale/floater.dart';
import 'package:tale/home/bottombary.dart';
import 'package:tale/boldtextstyle.dart';

const List<Color> myColors = [
  Color(0xFFFF5169),
  Color(0xFF6651FF),
  Color(0xFF0086FF),
  Color(0xFF00D699),
  Color(0xFF3F51B5),
  Color(0xFF00BCD4),
];

Color looper(int a) {
  if (a > 5) {
    if (a < 10)
      a = a - 6;
    else
      a = a % 10 - 6;
    return myColors[a];
  } else
    return myColors[a];
}

class Reminder extends StatelessWidget {
  final int index;

  const Reminder({Key key, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        elevation: 10.0,
        //type: MaterialType.card,
        color: index == 0 ? Colors.deepOrangeAccent : looper(index),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(width: 3, color: Colors.black)),

        child: Container(
          height: 140,
          child: index == 0
              ? Icon(
                  Icons.add,
                  size: 50,
                  color: Colors.white,
                )
              : Stack(
                  children: <Widget>[
                    Positioned(
                        top: 8,
                        right: 8,
                        child: Text(
                          "21/2/19",
                          style: boldStyle(Colors.white, null),
                          textScaleFactor: 1.3,
                        )),
                    Positioned(
                      bottom: 50,
                      left: 10,
                      child: Text(
                        "35 Days",
                        style: boldStyle(Colors.white, null),
                        textScaleFactor: 1.485,
                      ),
                    ),
                    Positioned(
                      child: Container(
                        child: Text(
                          "George's Birthday",
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: boldStyle(Colors.white, null),
                          textScaleFactor: 1.5,
                        ),
                      ),
                      bottom: 20,
                      left: 10,
                    )
                  ],
                ),
        ),
        //       onPressed: () {},
      ),
    );
  }
}

class ReminderList extends StatefulWidget {
  @override
  ReminderListState createState() {
    return new ReminderListState();
  }
}

class ReminderListState extends State<ReminderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Floater(
        onPressed: () {},
        icon: Icons.arrow_back,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView.builder(
        reverse: false,
        padding: EdgeInsets.only(top: 20.0, bottom: 20, right: 5, left: 5),
        itemBuilder: (_, int index) => Reminder(
              index: index,
            ),
        itemCount: myColors.length,
      ),
      bottomNavigationBar: BottomBary(),
    );
  }
}
