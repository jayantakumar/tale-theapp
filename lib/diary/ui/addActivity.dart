import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tale/diary/model/activityobject.dart';
import 'package:tale/diary/model/dairy_items.dart';
import 'package:tale/floater.dart';
import 'package:intl/intl.dart';
import 'package:tale/diary/util/database_diary.dart';
import 'addEventUi.dart';
import 'dairyUi.dart';
/*
* This page contains all the code that handles the ADD ACTIVITY page
* Here at the bottom is the list that has all the activities Available
* need to add more activities
* */

class AddActivity extends StatefulWidget {
  @override
  _AddActivityState createState() => _AddActivityState();
  AddActivity(this.mood);
  final String mood;
}

class _AddActivityState extends State<AddActivity> {
  //some initialisations
  //
  Server server = new Server();
  //
  List<GridItemModel> items = [];
  //
  TextEditingController textEditingController = new TextEditingController();
  //
  String activityTitle = "All";
  //
  DataBaseHelper db = DataBaseHelper.internal();
  //
  ActivityObject selectedActivityObject;
  //
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //
  //init state handles animation , list that updates the grid etc..
  @override
  void initState() {
    initialAnimator();
    //the method that creates the latency as the user scrolls through the cupertino picker
    subject.stream.debounce(new Duration(milliseconds: 600)).listen(_onChanged);
    super.initState();
  }

  //the method that is responsible for the animations and the initial stage and also initialise the list of items.
  void initialAnimator() {
    Future.delayed(Duration(milliseconds: 650)).then((_) {
      setState(() {
        color = emotionColorMap.containsKey(widget.mood)
            ? emotionColorMap[widget.mood]
            : color;
        items = server.getGridList(server.activityList);
      });
    });
  }

  //dispose method disposing the text editing controller
  @override
  void dispose() {
    textEditingController?.dispose();
    subject.close();
    super.dispose();
  }

  //the rx_dart stuff that controls the change in cupertino picker
  final subject = new PublishSubject<int>();

  TopBar topBar = new TopBar();
  //the list of text inside cupertino picker

  List<String> textList = [
    "None selected",
    "All",
    "Food",
    "Games",
    "Travel",
    "Entertainment",
    "People",
    "Feeling",
    "Nature",
    "Objects",
    "Other"
  ];

  //the cupertino picker builder
  CupertinoPicker picker(BuildContext context) {
    return CupertinoPicker.builder(
        itemExtent: 40,
        useMagnifier: true,
        diameterRatio: 2,
        magnification: 1.5,
        backgroundColor: Colors.white,
        onSelectedItemChanged: (i) {
          subject.add(i);
        },
        childCount: textList.length,
        itemBuilder: (context, index) {
          return Text(
            textList[index],
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 15,
                decoration: TextDecoration.combine([])),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: Floater(
        icon: Icons.done,
        onPressed: () {
          onSubmit(textEditingController.text);
        },
        isAnimated: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      //bottomNavigationBar: new BottomBar(),
      body: Builder(
        builder: (BuildContext context) => SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  new TopBar(),
                  new AddNoteBloc(textEditingController: textEditingController),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Align(
                          child: IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => SizedBox(
                                          child: picker(context),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2.5,
                                        ));
                              }),
                          alignment: Alignment.centerLeft,
                        ),
                        Expanded(child: Container()),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            activityTitle.toString(),
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.combine(
                                    [TextDecoration.underline])),
                          ),
                        ),
                        Expanded(child: Container()),
                        Align(
                          child: IconButton(
                              icon: Icon(Icons.add), onPressed: () {}),
                          alignment: Alignment.centerRight,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      child: GridView.custom(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 100,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                        childrenDelegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return InkWell(
                              child: GridItem(items[index]),
                              splashColor: color.withOpacity(0.5),
                              onTap: () {
                                setState(() {
                                  items.forEach((i) => i.isSelected = false);
                                  items[index].isSelected = true;
                                  selectedActivityObject = items[index].obj;
                                });
                              },
                            );
                          },
                          childCount: items.length,
                        ),
                        physics: AlwaysScrollableScrollPhysics(),
                      ),
                      opacity: items.isEmpty ? 0 : 1,
                    ),
                  ),
                ],
              ),
              //physics: NeverScrollableScrollPhysics(),

              physics: BouncingScrollPhysics(),
            ),
      ),
    );
  }

  //the function that gets called as the user browses through or changes the values in cupertino picker
  void _onChanged(int i) {
    if (textList[i] != "None selected")
      setState(() {
        activityTitle = textList[i];
        items = server.getGridList(server.getActivityListByType(textList[i]));
      });
  }

  onSubmit(String text) async {
    if (text != "" && text != null && selectedActivityObject != null) {
      DiaryItem diaryItem = DiaryItem(
          text,
          topBar.date.day.toString(),
          selectedActivityObject.emoji,
          selectedActivityObject.activity,
          widget.mood,
          topBar.date.month.toString(),
          topBar.time.format(context),
          topBar.date.year.toString());
      int _saveId;
      _saveId = await db.saveItem(diaryItem);
      var addedItem = await db.getItem(_saveId);
      print(addedItem.emotion);
      Navigator.of(context)
          .pushReplacement(SlideRightRoute(widget: DiaryMainUI()));
    } else
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Write something or Select an activity"),
        duration: Duration(milliseconds: 1100),
      ));
  }
}

//the bloc that gets users text i.e the add note bloc

class AddNoteBloc extends StatelessWidget {
  const AddNoteBloc({
    Key key,
    @required this.textEditingController,
  }) : super(key: key);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      decoration: ShapeDecoration(color: color, shape: Border()),
      height: 140,
      width: MediaQuery.of(context).size.width,
      curve: Curves.easeIn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: inputDec("Add Note", null),
              maxLength: 150,
              controller: textEditingController,
            ),
          ),
        ],
      ),
    );
  }
}

//the bar at the top of the screen

class TopBar extends StatelessWidget {
  TopBar({
    Key key,
  }) : super(key: key);

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));
    if (picked != null && picked != _date) {
      _date = picked;
      print(_date.toIso8601String());
    }
  }

  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != _time) {
      _time = picked;
      print(_time.format(context));
    }
  }

  TimeOfDay get time => _time;
  DateTime get date => _date;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 500),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 8,
      color: color,
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "ADD ENTRY",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
          Expanded(child: Container()),
          IconButton(
            icon: Icon(
              Icons.access_time,
              color: Colors.white,
            ),
            onPressed: () {
              selectTime(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
            onPressed: () {
              selectDate(context);
            },
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      foregroundDecoration: ShapeDecoration(shape: Border()),
    );
  }
}

//the bar at the bottom of the screen

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "BottomBar",
      child: AnimatedContainer(
        curve: Curves.easeIn,
        decoration: ShapeDecoration(
            shape: Border(top: BorderSide(color: Colors.black, width: 4)),
            color: color),
        duration: Duration(milliseconds: 500),
        height: MediaQuery.of(context).size.height / 11,
      ),
    );
  }
}

//grid items :

class GridItem extends StatelessWidget {
  final GridItemModel model;
  GridItem(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: model.isSelected ? color.withOpacity(0.2) : Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            model.obj.emoji,
            textScaleFactor: 2,
          ),
          SizedBox(height: 10),
          Text(
            model.obj.activity,
            textAlign: TextAlign.center,
            //maxLines: 2,
            //textScaleFactor: 1.5,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            overflow: TextOverflow.clip,
          ),
          //SizedBox(height: 10),
        ],
      ),
    );
  }
}

//the map that maps the emotion to its appropriate color

Map<String, Color> emotionColorMap = {
  "Happy": color,
  "Sad": Colors.blueAccent,
  "Angry": Colors.redAccent,
  "Fear": Colors.black,
  "Shy": Colors.pink,
  "Love": Colors.pinkAccent,
};

//default color

Color color = Color(0xFF00D67E);

//input dec for the text field

InputDecoration inputDec(String label, AsyncSnapshot snapshot) {
  return InputDecoration(
    errorText: snapshot == null ? null : snapshot.error,
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.red, width: 3),
    ),
    labelStyle: TextStyle(
      color: Colors.black,
      fontSize: 15,
    ),
    counterStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 3),
      borderRadius: BorderRadius.circular(5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.black54, width: 3),
    ),
    filled: true,
    fillColor: Colors.white,
    hintText: label,
  );
}
