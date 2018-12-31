import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:tale/floater.dart';
import 'package:tale/home/bottombary.dart';
import 'package:tale/home/cardy.dart';
import 'package:tale/boldtextstyle.dart';
import 'package:tale/todo/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tale/style/pagetransition.dart';
import 'dart:io';
import 'package:tale/main.dart';

import 'package:tale/todo/util/databaseClient.dart';

//List of colors add more when needed but change the looper function also

const List<Color> myColors = [
  Color(0xFFFF5169),
  Color(0xFF6651FF),
  Color(0xFF0086FF),
  Color(0xFF00D699),
  Color(0xFF3F51B5),
  Color(0xFF00BCD4),
];

//function that initialises the list of titles and store it using shared preferences;

Future<List<String>> getList() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (preferences.getStringList("todo") == null) {
    preferences.setStringList("todo", ["0"]);
    return preferences.getStringList("todo");
  } else
    return preferences.getStringList("todo");
}

class ListOfTodo extends StatefulWidget {
  @override
  _ListOfTodoState createState() => _ListOfTodoState();
}

class _ListOfTodoState extends State<ListOfTodo>
    with SingleTickerProviderStateMixin {
  List<String> _title = [];

  //looper function loops through colors list and gives out the correct list
  //change this if you changed colors list.

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

  //Animation controller for Animated icon
  AnimationController controller;

  void deleteData(String title) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path =
        join(documentDirectory.path, "${title.replaceAll(" ", "_")}_db.db");
    var db = new DataBaseHelper.internal(title);
    db.deleteDb();
  }

  //init state method
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    getList().then(updateList);
    super.initState();
  }

  //dispose method to dispose animation controller

  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  //canShow bool controls the visibility of remove icon in the title list

  bool canShow = false;

  @override
  Widget build(BuildContext context) {
    //Function that controls the working of the floating action button and its animations
    void floatingOnPressed() {
      if (canShow) {
        setState(() {
          canShow = false;
          controller.reverse();
        });
      } else
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => Pages(
                  pageNo: 0,
                )));
    }

    //function that takes care of long pressing the card
    void longPress(int index) {
      // print("hel");
      if (index != 0) {
        controller.forward();
        setState(() {
          canShow = true;
        });
      }
    }

    return Scaffold(
      floatingActionButton: new Floater(
        isAnimated: true,
        animatedIcon:
            AnimatedIcon(icon: AnimatedIcons.menu_close, progress: controller),
        onPressed: () => floatingOnPressed(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
          BottomBary(color: canShow ? Colors.red : Colors.yellow),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                //function that takes care of what happens when we click the card and the first + element

                if (!canShow) {
                  if (index != 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TodoMain(
                                title: _title[index],
                                color: looper(index),
                              ),
                        ));
                  } else
                    showBottomSheet(
                        context: context, builder: buildBottomSheet);
                }
              },
              onLongPress: () {
                longPress(index);
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    Cardy(
                      bottomTitle: index == 0 ? false : true,
                      titleSize: 40,
                      height: 180,

                      color: index == 0 ? Colors.deepOrange : looper(index),
                      title: index == 0 ? "" : _title[index],
                      //subtitle: "hello",
                      body: index == 0
                          ? Icon(
                              Icons.add,
                              size: 80,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    index != 0
                        ? Positioned(
                            top: 10,
                            right: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: canShow
                                  ? Listener(
                                      child: new Icon(
                                        Icons.remove_circle,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPointerDown: (e) {
                                        setState(() {
                                          remove(index);
                                        });
                                      })
                                  : Container(),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
        itemCount: _title.length,
      ),
    );
  }

  //Todo change the widget that takes in the title and creates a new database
  //this is the bottom sheet that arrives as you click the + sign

  Widget buildBottomSheet(BuildContext context) {
    TextEditingController _controller = new TextEditingController();

    void createTodo() async {
      if (_controller.text.isNotEmpty &&
          _controller.text != null &&
          !(_title.contains(_controller.text))) {
        //create an instance of shared preferences
        SharedPreferences pref = await SharedPreferences.getInstance();

        //get the list and add the text in controller

        pref.getStringList("todo").add(_controller.text);

        //set the new list
        pref.setStringList("todo", pref.getStringList("todo"));

        //Navigate to the todo_ page
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TodoMain(
            title: _controller.text,
            color: looper(pref.getStringList('todo').length - 1),
          );
        }));
      } else if (_title.contains(_controller.text) &&
          !(_controller.text.isNotEmpty && _controller.text != null)) {
        final SnackBar snackBar =
            SnackBar(content: Text('Two items cannot have the same title'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 60,
        ),
        Center(
            child: Text(
          "Title",
          textScaleFactor: 2.5,
          style: boldStyle(Colors.black, TextDecoration.none),
        )),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: TextField(
            decoration: inputDec("Title", null),
            autofocus: true,
            autocorrect: true,
            controller: _controller,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FlatButton(
          onPressed: () => createTodo(),
          color: Colors.red,
          child: new Icon(Icons.add),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  //the function that updates the list

  void updateList(List<String> list) {
    setState(() {
      _title = list;
    });
  }

  //the logic behind removing the title
  //todo make the function remove the database itself

  remove(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List m = preferences.getStringList('todo');
    await deleteData(m[index]);
    m.removeAt(index);
    preferences.setStringList('todo', m);

    setState(() {
      _title = preferences.getStringList('todo');
    });
  }
}

//input decoration for the text fields in the bottom sheet

InputDecoration inputDec(String label, AsyncSnapshot snapshot) {
  return InputDecoration(
    //errorText: snapshot == null ? "Error" : snapshot.error,
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.red, width: 4),
    ),
    labelStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 4),
      borderRadius: BorderRadius.circular(0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.black54, width: 4),
    ),
    labelText: label,
  );
}
