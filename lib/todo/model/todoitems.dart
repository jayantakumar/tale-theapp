import 'package:flutter/material.dart';

/*
THIS CLASS DEALS WITH THE TODO_ITEM,IT DEFINES THE TODO_ITEM ITSELF
*/

class TodoItem {
  // 1.default constructor that makes a todo_ item
  // 2.named constructor that makes a _todo item from an dynamic object
  // 3.named constructor to make a todo_item from a map

  TodoItem(this._itemName, this._dateCreated, this._done);
  TodoItem.map(dynamic obj) {
    this._itemName = obj["itemName"];
    this._id = obj["id"];
    this._dateCreated = obj["dateCreated"];
    this._done = obj["done"];
  }
  TodoItem.fromMap(Map<String, dynamic> map) {
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];
    this._itemName = map["itemName"];
    this._done = map["done"];
  }

  //private variables DECLARED

  String _itemName, _dateCreated, _done;
  int _id;

  //GETTERS for private variables

  String get itemName => _itemName;
  String get dateCreated => _dateCreated;
  int get id => _id;
  String get done => _done;

  //user defined function that creates  a map from a todo_item

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["itemName"] = _itemName;
    map["dateCreated"] = _dateCreated;
    map["done"] = _done;

    if (_id != null) map["id"] = _id;
    return map;
  }
}
