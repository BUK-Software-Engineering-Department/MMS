import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mms/models/medicine.dart';


class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'medicines';

  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint("not null db");
      return;
    }
    try {
      String path = '${await getDatabasesPath()}medicines.db';
      debugPrint("in database path");
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          debugPrint("creating a new one");
          return db.execute(
              "CREATE TABLE $_tableName("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title STRING, note TEXT, date STRING, "
              "startTime STRING, endTime STRING, "
              "remind INTEGER, repeat STRING, "
              "color INTEGER, "
              "dosage STRING, "  // Add the new column for dosage
              "isCompleted INTEGER)"
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Medicine medicine) async {
    print("insert function called");
    return await _db!.insert(_tableName, medicine.toJson());
  }
 
  static Future<int> delete(Medicine medicine) async =>
      await _db!.delete(_tableName, where: 'id = ?', whereArgs: [medicine.id]);

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return _db!.query(_tableName);
  }

  static Future<int> update(int? id) async {
    print("update function called");
    return await _db!.rawUpdate('''
    UPDATE medicines   
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }
}