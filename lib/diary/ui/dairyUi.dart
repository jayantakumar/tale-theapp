import 'package:flutter/material.dart';
import 'package:tale/diary/model/dairy_items.dart';
import 'package:tale/diary/ui/addEventUi.dart';
import 'package:tale/diary/util/database_diary.dart';

import 'dart:math';

import 'package:tale/floater.dart';

class DiaryMainUI extends StatefulWidget {
  @override
  _DiaryMainUIState createState() => _DiaryMainUIState();
}

class _DiaryMainUIState extends State<DiaryMainUI> {
  bool canShowMarkers = false;
  DataBaseHelper db = DataBaseHelper.internal();

  _delete(int id, int index) async {
    await db.deleteItem(id);
    setState(() {
      itemList.removeAt(index);
    });
  }

  _updateList() async {
    List items = await db.getItems();
    items.forEach((item) {
      setState(() {
        itemList.add(DiaryItem.map(item));
      });
    });
  }

  List<DiaryItem> itemList = [];

  @override
  void initState() {
    _updateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                canShowMarkers = !canShowMarkers;
              });
            },
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: myColors[3],
        title: Text(
          "STORIES",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
            child: Container(
              decoration: ShapeDecoration(shape: Border()),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height / 40)),
      ),
      floatingActionButton: Floater(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AddUI())),
        color: myColors[3],
        icon: Icons.add,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          Color cardItemColor = emotionsToColor[itemList[index].emotion];
          return GestureDetector(
            onTap: () {
              print(itemList[index].emotion);
            },
            child: Card(
              color: cardItemColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black87,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 10.0,
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    canShowMarkers
                        ? Positioned(
                            child: Listener(
                              child: Icon(Icons.remove_circle,
                                  color: Colors.white),
                              onPointerDown: (e) =>
                                  _delete(itemList[index].id, index),
                            ),
                            top: 10,
                            right: 10)
                        : Container(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          itemList[index].time,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        new SizedBox(height: 20),
                        Center(
                          child: itemList[index].itemName.length > 15
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      itemList[index].emoji,
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    new Text(
                                      itemList[index].itemName,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: <Widget>[
                                    new Text(
                                      itemList[index].emoji,
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: new Text(
                                        itemList[index].itemName,
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: itemList.length,
      ),
    );
  }

  static const List<Color> myColors = [
    Color(0xFFFF5169), //red,0
    Color(0xFF6651FF), //viole_ty blue,1
    Color(0xFF0086FF), //blue,2
    Color(0xFF00D699), //green,3
    Color(0xFF3F51B5), //pink,4
    Color(0xFF00BCD4), //blue,5
    Color(0xFF00CED1), //cool blue,6
    Color(0xFF88c7d6), //sad_ish blue,7
  ];
  Map<String, Color> emotionsToColor = {
    "Happy": myColors[3],
    "Angry": Colors.red,
    "Awful": Colors.black54,
    "Bored": myColors[2],
    "Cool": myColors[6],
    "Fear": Colors.black,
    "Amazed": myColors[5],
    "Laugh": myColors[3],
    "Love": Colors.pinkAccent,
    "Meh": myColors[1],
    "Nice": myColors[3],
    "Sad": myColors[7],
    "Shy": myColors[4],
    "Sleepy": myColors[2],
    "Wacky": Colors.deepOrange,
  };
}
