import 'package:flutter/material.dart';
import 'package:tale/floater.dart';
import 'package:tale/home/bottombary.dart';
import 'package:tale/todo/model/todoitems.dart';
import 'package:tale/todo/util/databaseClient.dart';
import 'package:tale/boldtextstyle.dart';
import 'package:tale/textboxstyle.dart';

//the ui inside every major todo_title , contains code to update,delete,add todo_items from ui

class TodoMain extends StatefulWidget {
  TodoMain({@required this.title, this.color});
  final String title;
  final Color color;
  @override
  _TodoMainState createState() => _TodoMainState(title, color);
}

class _TodoMainState extends State<TodoMain> with TickerProviderStateMixin {
  _TodoMainState(this.title, this.color);

  Color color;

  //creating an instance of database to use it

  DataBaseHelper db(String text) {
    var db = new DataBaseHelper.internal(text);
    return db;
  }

  AnimationController controller;

  final List<TodoItem> itemList = [];
  final String title;
  Animation<double> containerAnim, textAnim;

  //animations and list initialisation takes place here..

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    containerAnim = new Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.decelerate))
          ..addListener(() {
            setState(() {});
          });
    textAnim = new Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 1, curve: Curves.easeInOut)))
      ..addListener(() {
        setState(() {});
      });
    readTodoList();
  }

  //disposing animation controller..

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  bool canShow = false, isEditing = false;

  TextDecoration decoration = TextDecoration.none;
  double height = 100;

  FocusNode node = new FocusNode();

  @override
  Widget build(BuildContext context) {
    //function that kicks of on press of floating action button..

    void adder() {
      if (isEditing) {
        add();
      }
      setState(() {
        isEditing = !isEditing;
      });
      isEditing ? controller.forward() : controller.reverse();
    }

    //return statement

    return Scaffold(
      body: new Column(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              Material(
                shape:
                    Border(bottom: BorderSide(color: Colors.black, width: 4)),
                child: AnimatedContainer(
                  height: 100 + 130 * containerAnim.value,
                  color: canShow ? Colors.red : color,
                  duration: Duration(milliseconds: 200),
                  // decoration: BoxDecoration(),
                ),
              ),
              Positioned(
                bottom: 10 + 90 * containerAnim.value,
                left: 20.0 + 10 * containerAnim.value,
                child: Text(
                  title.toUpperCase(),
                  style: boldStyle(Colors.white, TextDecoration.none),
                  textScaleFactor: 2.5,
                ),
              ),
              Positioned(
                  right: 10,
                  top: 5,
                  child: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        print("tap");

                        if (canShow == false)
                          setState(() {
                            canShow = true;
                            print("true");
                          });
                        else {
                          setState(() {
                            canShow = false;
                          });
                        }
                      })),
              isEditing
                  ? Positioned(
                      bottom: 65,
                      left: 30,
                      child: SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: TextField(
                          autofocus: true,
                          autocorrect: true,
                          decoration: inputDecoration,
                          controller: _controller,
                          //focusNode: node,
                          maxLength: 100,
                          textAlign: TextAlign.justify,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: "Courier",
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                  : Container(),
            ],
          ),
          new Flexible(
              child: ListView.builder(
            padding: EdgeInsets.all(15),
            reverse: false,
            itemCount: itemList.length,
            itemBuilder: (_, int index) {
              return Material(
                  type: MaterialType.card,
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onHorizontalDragUpdate: (d) {
                        canShow ? null : _updateDone(itemList[index], index);
                      },
                      onLongPress: () {
                        _showUpdateUI(itemList[index], index);
                      },
                      child: Row(
                        children: <Widget>[
                          canShow
                              ? Listener(
                                  key: new Key(itemList[index].itemName),
                                  child: new Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                  onPointerDown: (pointerEvent) =>
                                      _delete(itemList[index].id, index),
                                )
                              : Container(),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Center(
                              child: Text(
                                itemList[index].itemName,
                                style: boldStyle(
                                    Colors.black,
                                    itemList[index].done == "True"
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                textScaleFactor: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          ))
        ],
      ),
      bottomNavigationBar: BottomBary(
        color: canShow ? Colors.red : color,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Floater(
        onPressed: canShow
            ? () {
                setState(() {
                  canShow = false;
                });
              }
            : adder,
        icon: isEditing ? Icons.done : (canShow ? Icons.close : Icons.add),
      ),
    );
  }

  //text_editing controller

  var _controller = new TextEditingController();

  //add the todo_item

  void add() {
    _handleSubmit(_controller.text);
    _controller.clear();
  }

  //the function that handles on submit function,CREATES A NEW TODO_ITEM FOR THE GIVEN VALUE

  void _handleSubmit(String text) async {
    _controller.clear();
    if (text != "") {
      TodoItem item =
          new TodoItem(text, DateTime.now().toIso8601String(), "False");
      int _saveId;
      _saveId = await db(title).saveItem(item);
      var addedItem = await db(title).getItem(_saveId);
      setState(() {
        itemList.insert(0, addedItem);
      });
      print("item saved $_saveId");
    }
  }

  //the function that reads the list and updates the UI IF ANY CHANGE HAPPENS

  readTodoList() async {
    List items = await db(title).getItems();
    items.forEach((item) {
      //TodoItem todoItem = TodoItem.map(item);
      setState(() {
        itemList.add(TodoItem.map(item));
      });

      //print("Db items : ${todoItem.itemName}");
    });
  }

  //function to delete the item

  _delete(int id, int index) async {
    await db(title).deleteItem(id);
    setState(() {
      itemList.removeAt(index);
    });
  }

  //function to update when we swipe to cross the task

  _updateDone(TodoItem item, int index) async {
    String bool;
    if (item.done == "False")
      bool = "True";
    else
      bool = "False";
    var updateItem = new TodoItem.fromMap({
      "itemName": item.itemName,
      "dateCreated": item.dateCreated,
      "id": item.id,
      "done": bool,
    });
    _onUpdate(itemList[index], index);
    await db(title).updateItem(updateItem);
    setState(() {
      readTodoList();
    });
  }

  //todo update  the ui for updating the todo item

  _showUpdateUI(TodoItem item, int index) {
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Item",
                hintText: "Buy Socks",
                icon: Icon(Icons.update),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            Navigator.pop(context);
            var updatedItem = new TodoItem.fromMap({
              "itemName": _controller.text,
              "dateCreated": DateTime.now().toIso8601String(),
              "id": item.id,
              "done": "False",
            });
            _onUpdate(itemList[index], index);
            await db(title).updateItem(updatedItem);
            setState(() {
              readTodoList();
            });
          },
          child: Text("Update"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

//handles the update facility of the note

  void _onUpdate(TodoItem item, int index) {
    setState(() {
      itemList
          .removeWhere((element) => itemList[index].itemName == item.itemName);
    });
  }
}

//controls the decoration of the input box

var inputDecoration = InputDecoration(
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.red, width: 4),
    ),
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: 15,
    ),
    //suffixIcon: Icon(Icons.add),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 4),
      borderRadius: BorderRadius.circular(0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.white, width: 4),
    ),
    hintText: "Ex: Buy Socks",
    hintStyle: TextStyle(
      color: Colors.white,
      fontSize: 15,
    ));
