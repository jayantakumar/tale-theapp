import 'package:flutter/material.dart';
import 'package:tale/floater.dart';
import 'package:tale/home/bottombary.dart';

class AddActivity extends StatefulWidget {
  @override
  _AddActivityState createState() => _AddActivityState();
  AddActivity(this.mood);
  final String mood;
}

class _AddActivityState extends State<AddActivity> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      setState(() {
        color = emotionColorMap.containsKey(widget.mood)
            ? emotionColorMap[widget.mood]
            : color;
      });
    });
    super.initState();
  }

  TextEditingController textEditingController = new TextEditingController();
  @override
  void dispose() {
    textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Floater(
        icon: Icons.done,
        onPressed: () => {},
        isAnimated: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Hero(
        tag: "BottomBar",
        child: AnimatedContainer(
          curve: Curves.easeIn,
          decoration: ShapeDecoration(
              shape: Border(top: BorderSide(color: Colors.black, width: 4)),
              color: color),
          duration: Duration(milliseconds: 500),
          height: MediaQuery.of(context).size.height / 11,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AnimatedContainer(
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              alignment: Alignment.centerLeft,
              foregroundDecoration: ShapeDecoration(
                  shape: Border(
                      bottom: BorderSide(width: 4, color: Colors.black))),
            ),
            SizedBox(
              height: 20,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: ShapeDecoration(
                  color: color.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.black, width: 4))),
              height: 140,
              width: 0.95 * MediaQuery.of(context).size.width,
              curve: Curves.easeIn,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      decoration: inputDec("Add Note", null),
                      maxLength: 150,
                      controller: textEditingController,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.white,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (context, index) => GridItem(index),
                  itemCount: activityList.length,
                ),
              ),
            ),
          ],
        ),
        //physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final int _index;
  GridItem(this._index);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          activityList[_index]._activityEmoji,
          textScaleFactor: 2.5,
        ),
        SizedBox(height: 10),
        Text(
          activityList[_index]._activityName,
          textAlign: TextAlign.center,
          maxLines: 2,
          //textScaleFactor: 1.5,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          overflow: TextOverflow.clip,
        ),
      ],
    );
  }
}

Map<String, Color> emotionColorMap = {
  "Happy": color,
  "Sad": Colors.blueAccent,
  "Angry": Colors.redAccent,
  "Fear": Colors.black
};

Color color = Color(0xFF00D67E);

InputDecoration inputDec(String label, AsyncSnapshot snapshot) {
  return InputDecoration(
    errorText: snapshot == null ? null : snapshot.error,
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.red, width: 4),
    ),
    labelStyle: TextStyle(
      color: Colors.black,
      fontSize: 15,
    ),
    counterStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 4),
      borderRadius: BorderRadius.circular(5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.black, width: 4),
    ),
    filled: true,
    fillColor: Colors.white,
    hintText: label,
  );
}

class ActivityObject {
  String _activityName;
  String _activityEmoji;
  String _activityType;

  ActivityObject(this._activityName, this._activityEmoji, this._activityType);
  ActivityObject.fromMap(Map map) {
    this._activityEmoji = map["emoji"];
    this._activityName = map["name"];
  }

  String get activity => _activityName;
  String get emoji => _activityEmoji;
  String get type => _activityType;
}

List<ActivityObject> activityList = [
  ActivityObject("Movies", "🎫", "Entertainment"),
  ActivityObject("Video games", "🎮", "Entertainment"),
  ActivityObject("Spacy", "🛰️", "Other"),
  ActivityObject("Flying", "🚁", ""),
  ActivityObject("Healthy Food", "🍎"),
  ActivityObject("Junk Food", "🍟"),
  ActivityObject("Flying", "🚁"),
];
