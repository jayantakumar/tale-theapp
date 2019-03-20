import 'package:flutter/material.dart';
import 'package:tale/diary/model/dairy_items.dart';

class FullScreenInteractivePage extends StatelessWidget {
  final DiaryItem item;
  final int index;
  final Color color;

  final TextStyle style = TextStyle(fontSize: 50);
  final TextStyle contentStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  final TextStyle timeStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  FullScreenInteractivePage({this.item, this.index, this.color});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Hero(
        tag: index.toString() + "H",
        child: Card(
            elevation: 0,
            color: color,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  SizedBox(height: 40),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          item.date + "\/" + item.month + "\/" + item.year,
                          style: timeStyle,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(height: 80),
                  Center(
                    child: Text(
                      item.emoji,
                      style: style,
                    ),
                  ),
                  SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                        child: Text(
                      item.itemName,
                      style: contentStyle,
                      maxLines: 100,
                      textScaleFactor: 2,
                      textAlign: TextAlign.start,
                    )),
                  ),
                ]),
              ),
            )),
      ),
    );
  }
}
