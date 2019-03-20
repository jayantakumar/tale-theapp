import 'package:flutter/material.dart';
import 'package:tale/diary/model/dairy_items.dart';
import 'package:tale/diary/ui/addEventUi.dart';
import 'package:tale/diary/ui/fullScreenInteractivePage.dart';
import 'package:tale/diary/util/database_diary.dart';
import 'package:tale/floater.dart';
import 'package:tale/home/bottombary.dart';
import 'package:tale/style/routeTransitionAnimation.dart';

class DiaryMainUI extends StatefulWidget {
  @override
  _DiaryMainUIState createState() => _DiaryMainUIState();
  final PageController controller;
  DiaryMainUI(this.controller);
}

class _DiaryMainUIState extends State<DiaryMainUI>
    with TickerProviderStateMixin {
  bool canShowMarkers = false;
  DataBaseHelper db = DataBaseHelper.internal();
  List<DiaryItem> itemList = [];
  sortMyList(List<DiaryItem> itemList) {
    itemList.sort((a, b) {
      int minutesOfA = int.parse(a.time.split(":")[1].split(" ")[0]);
      int minutesOfB = int.parse(b.time.split(":")[1].split(" ")[0]);
      if (minutesOfA == minutesOfB) return (a.id.compareTo(b.id));
      return minutesOfA.compareTo(minutesOfB);
    });
    itemList.sort((a, b) {
      //they are strings
      String timeOfA = a.time;
      String timeOfB = b.time;
      int hoursOfA = int.parse(timeOfA.split(":")[0]) != 12
          ? (timeOfA.contains("AM")
              ? int.parse(timeOfA.split(":")[0])
              : (int.parse(timeOfA.split(":")[0]) + 12))
          : 12;
      if (hoursOfA == 12) hoursOfA = timeOfA.contains("AM") ? 0 : 12;
      int hoursOfB = int.parse(timeOfB.split(":")[0]) != 12
          ? timeOfB.contains("AM")
              ? int.parse(timeOfB.split(":")[0])
              : (int.parse(timeOfB.split(":")[0]) + 12)
          : 12;
      if (hoursOfB == 12) hoursOfB = timeOfB.contains("AM") ? 0 : 12;

      return hoursOfA.compareTo(hoursOfB);
    });
    //sorting by date
    itemList.sort((a, b) => int.parse(a.date).compareTo(int.parse(b.date)));
    //by month
    itemList.sort((a, b) => int.parse(a.month).compareTo(int.parse(b.month)));
    //by year
    itemList.sort((a, b) => int.parse(a.year).compareTo(int.parse(b.year)));
  }

  //update ui list view according to changes
  _updateList() async {
    //getting list of stored values from database
    List items = await db.getItems();

    //adding the received values to the ui list_view
    items.forEach((item) {
      itemList.add(DiaryItem.map(item));
    });
    //sorting the List
    sortMyList(itemList);
    //updating the ui
    setState(() {
      itemList = itemList.reversed.toList();
    });

    //debug statements
    itemList.forEach((i) => print(i.time));
  }

  AnimationController _controller;
  Animation scaleTween, borderRadiusTween;
  double elevation = 5;
  int temp;
  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    _updateList();
    super.initState();
  }

  _delete(int id, int index) async {
    await db.deleteItem(id);
    setState(() {
      itemList.removeAt(index);
    });
  }

  static const List<Color> myColors = [
    Color(0xFFFF0800), //red,0
    Color(0xFF6651FF), //viole_ty blue,1
    Color(0xFF0086FF), //blue,2
    Color(0xFF00D699), //green,3
    Color(0xFF3F51B5), //pink,4
    Color(0xFF00BCD4), //blue,5
    Color(0xFF00CED1), //cool blue,6
    Color(0xFF88c7d6), //sad_ish blue,7
    Color(0xFFC3782B), // ugly green,8
  ];
  Map<String, Color> emotionsToColor = {
    "Happy": myColors[3],
    "Angry": myColors[0],
    "Awful": myColors[8],
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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(),
      child: Scaffold(
        bottomNavigationBar: BottomBary(
          color: canShowMarkers ? Colors.red : Colors.indigo,
        ),
        floatingActionButton: Floater(
          onPressed: () {
            if (canShowMarkers)
              setState(() {
                canShowMarkers = false;
              });
            else
              Navigator.of(context).push(
                SlideRoute(
                  initialSlideOffset: Offset(1, 0),
                  widget: AddUI(widget.controller),
                ),
              );
          },
          color: Colors.pink,
          icon: canShowMarkers ? Icons.close : Icons.add,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 70,
                titleSpacing: 30,
                title: Text(
                  "Today",
                  textScaleFactor: 1.55,
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: ""),
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          canShowMarkers = !canShowMarkers;
                        });
                      })
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Color cardItemColor =
                        emotionsToColor[itemList[index].emotion];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 14),
                      child: GestureDetector(
                        onTap: () {
                          if (canShowMarkers == true) return;
                          Future.delayed(Duration(milliseconds: 300)).then((n) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => FullScreenInteractivePage(
                                      color: cardItemColor,
                                      index: index,
                                      item: itemList[index],
                                    )));
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            canShowMarkers = !canShowMarkers;
                          });
                        },
                        child: Hero(
                          tag: index.toString() + "H",
                          child: Card(
                            color: cardItemColor.withOpacity(1),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: cardItemColor.withOpacity(0.92),
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: temp == index ? elevation : 5,
                            margin: EdgeInsets.all(10),
                            child: Container(
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
                                              onPointerDown: (e) => _delete(
                                                  itemList[index].id, index),
                                            ),
                                            top: 10,
                                            right: 10)
                                        : Container(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          child: itemList[index]
                                                      .itemName
                                                      .length >
                                                  15
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Text(
                                                      itemList[index].emoji,
                                                      style: TextStyle(
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    new Text(
                                                      itemList[index].itemName,
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: new Text(
                                                        itemList[index]
                                                            .itemName,
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
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
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: itemList.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onBackButtonPressed() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }
}
