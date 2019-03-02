import 'package:flutter/material.dart';
import 'package:tale/diary/model/dairy_items.dart';
import 'package:tale/diary/ui/addEventUi.dart';
import 'package:tale/diary/util/database_diary.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class DiaryMainUI extends StatefulWidget {
  @override
  _DiaryMainUIState createState() => _DiaryMainUIState();
}

const List<Color> myColors = [
  Color(0xFFFF5169),
  Color(0xFF6651FF),
  Color(0xFF0086FF),
  Color(0xFF00D699),
  Color(0xFF3F51B5),
  Color(0xFF00BCD4),
];

class _DiaryMainUIState extends State<DiaryMainUI> {
  DataBaseHelper db = DataBaseHelper.internal();

  delete(int index) async {
    while (index < 1) {
      await db.deleteItem(index);
      index--;
    }
    setState(() {
      itemList.removeAt(index);
    });
  }

  updateList() async {
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
    updateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed("/home"),
            icon: Icon(Icons.arrow_back),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => AddUI())),
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: myColors[Random().nextInt(6)],
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 10.0,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
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
            ),
          );
        },
        itemCount: itemList.length,
      ),
    );
  }
}
