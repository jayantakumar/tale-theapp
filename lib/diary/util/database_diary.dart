import 'dart:async';
import 'dart:io';
import 'package:tale/diary/model/dairy_items.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//THE CLASS THAT MAINTAINS AND HELPS THE CREATION AND USAGE OF DATABASES

class DataBaseHelper {
  //FACTORY CONSTRUCTOR

  static DataBaseHelper _instance() => new DataBaseHelper.internal();
  factory DataBaseHelper() => _instance();

  //CONTENTS AND TITLE OF THE DATABASE TABLE BEING DECLARED

  final String tableName = "diaryTbl";
  final String columnId = "id";
  final String columnItemName = "diaryItemName";
  final String year = "year";
  final String month = "month";
  final String date = "date";
  final String time = "time";
  final String emoji = "emoji";
  final String emotion = "emotion";
  final String activity = "activity";

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DataBaseHelper.internal();

  //THE FUNCTION THAT INITIALIZES THE DATABASE

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "dairy1234_db.db");
    var ourDb = await openDatabase(path, onCreate: _onCreate, version: 1);
    return ourDb;
  }

  //THE FUNCTION THAT DELETES THE DATABASE ITSELF

  Future<void> deleteDb() async {
    var dbClient = await db;
    await dbClient.delete(tableName);
    _db = null;
  }

  //THE FUNCTION THAT CREATES THE APPROPRIATE TABLE FOR THE DATABASE

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, $columnItemName TEXT,$year TEXT,$month TEXT,$date TEXT,$time TEXT,$emoji TEXT,$activity,$emotion TEXT) ");
  }

  //FUNCTION THAT SAVES THE ITEM BEING PASSED ON IN THE DATABASE

  Future<int> saveItem(DiaryItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", item.toMap());
    print(res.toString());
    return res;
  }

  //FUNCTION THAT RETURNS THE LIST OF ITEMS IN THE DATABASE

  Future<List> getItems() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName ORDER BY $columnItemName ASC");
    return result.toList();
  }

  //FUNCTION THAT RETURNS THE COUNT OF ITEMS IN THE DATABASE

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
      await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName "),
    );
  }

  //FUNCTION THAT RETURNS THE  ITEM THAT MATCHES THE ID BEING PASSED ON TO THE DATABASE

  Future<DiaryItem> getItem(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return new DiaryItem.fromMap(result.first);
  }

  //THE FUNCTION THAT DELETES THE ITEM WHICH MATCHES THE ITEM ID

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: "$columnId=?", whereArgs: [id]);
  }

  //FUNCTION THAT UPDATES THE ITEM_VALUE IN THE DATABASE

  Future<int> updateItem(DiaryItem item) async {
    var dbClient = await db;
    return await dbClient.update(tableName, item.toMap(),
        where: "$columnId=?", whereArgs: [item.id]);
  }

  //FUNCTION THAT CLOSES THE DATABASE

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
