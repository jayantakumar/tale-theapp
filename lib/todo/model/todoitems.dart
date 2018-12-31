import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  TodoItem(this._itemName, this._dateCreated, this._done);
  TodoItem.map(dynamic obj) {
    this._itemName = obj["itemName"];
    this._id = obj["id"];
    this._dateCreated = obj["dateCreated"];
    this._done = obj["done"];
  }
  String _itemName, _dateCreated, _done;
  int _id;

  String get itemName => _itemName;
  String get dateCreated => _dateCreated;
  int get id => _id;
  String get done => _done;
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["itemName"] = _itemName;
    map["dateCreated"] = _dateCreated;
    map["done"] = _done;
    if (_id != null) map["id"] = _id;
    return map;
  }

  TodoItem.fromMap(Map<String, dynamic> map) {
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];
    this._itemName = map["itemName"];
    this._done = map["done"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _itemName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Created on $_dateCreated",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
