/*
THIS CLASS DEALS WITH THE DIARY_ITEM,IT DEFINES THE DIARY_ITEM ITSELF
*/

class DiaryItem {
  // 1.default constructor that makes a todo_ item
  // 2.named constructor that makes a _todo item from an dynamic object
  // 3.named constructor to make a todo_item from a map

  DiaryItem(this._diaryItemName, this._date, this._emoji, this._emotion,
      this._month, this._time, this._year);
  DiaryItem.map(dynamic obj) {
    this._diaryItemName = obj["diaryItemName"];
    this._id = obj["id"];
    this._date = obj["date"];
    this._emoji = obj["emoji"];
    this._emotion = obj["emotion"];
    this._time = obj["time"];
    this._year = obj["year"];
    this._month = obj["month"];
  }
  DiaryItem.fromMap(Map<String, dynamic> map) {
    this._date = map["date"];
    this._id = map["id"];
    this._diaryItemName = map["diaryItemName"];
    this._emoji = map["emoji"];
    this._emotion = map["emotion"];
    this._time = map["time"];
    this._year = map["year"];
    this._month = map["month"];
  }

  //private variables DECLARED

  String _diaryItemName, _date, _time, _month, _year, _emoji, _emotion;
  int _id;

  //GETTERS for private variables

  String get itemName => _diaryItemName;
  String get date => _date;
  int get id => _id;
  String get emoji => _emoji;
  String get emotion => _emotion;
  String get time => _time;
  String get year => _year;
  String get month => _month;

  //user defined function that creates  a map from a DIARY_item

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["diaryItemName"] = _diaryItemName;
    map["date"] = _date;
    map["emoji"] = _emoji;
    map["emotion"] = _emotion;
    map["year"] = _year;
    map["month"] = _month;
    map["time"] = _time;

    if (_id != null) map["id"] = _id;
    return map;
  }
}
