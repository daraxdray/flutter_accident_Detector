
// import 'package:accident_tracker/model/user.dart';
import 'package:accident_detector/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  DbProvider._();
  static final DbProvider db = DbProvider._();
  static const String  userTable = "User";
  static var _database;
  static var databasePath;
  Future<Database> get database async {
    _database = null;
    if(_database != null){
      return _database;
    }
  print("HERE2");
    _database = await initDB();
    return _database;
  }


  initDB() async {

      databasePath = await getDatabasesPath();
      var path =  join(databasePath,'user_db2');
      _database = await openDatabase(
          path,
          version: 1,
          onCreate: (Database db,int version) async{
            await db.execute('''
     CREATE TABLE $userTable ( uid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
     uName TEXT NOT NULL,
     uEmail TEXT NOT NULL,
     uAddress TEXT NOT NULL,
     uPhone TEXT NOT NULL,
     uPassword TEXT NOT NULL,
     dateCreated TEXT NOT NULL
     
    );
    ''');
          },
      );
      return _database;
    }

  Future<dynamic> insertDb(dynamic data, {table =  userTable}) async {
    Database db = await database;
    debugPrint(data.toDb().toString());
    data.id = await db.insert(table,data.toDb());
    return data;
  }


  Future<List<User>> getAllEvents() async {
    Database db = await database;

    List<Map> result;
    result = await db.query(userTable);
    // debugPrint(result);
    List<User> cr = result.isNotEmpty? result.map((e) => User.fromDb(e)).toList():[];
    return cr;
  }


  getEventById({id =0}) async  {
    Database db = await database;
    List<Map> result;
    if(id == 0){
      return  null;
    }else
    {
      result = await db.query(userTable,
          where: 'id = $id',
          whereArgs: [id]);
      if(result.length >0 ){
        return  User.fromJson(result.first);
      }
    }



  }
  getUserByEmail({email ="",password =""}) async  {
    Database db = await database;
    List<Map> result;
    if(email == ""){
      return  null;
    }else
    {
      result = await db.query(userTable,
          where: "uEmail = ? AND uPassword = ?",
          whereArgs: [email,password]);
      if(result.isNotEmpty ){
        return  User.fromJson(result.first);
      }
      return null;
    }



  }


  Future<int> deleteEvent(id) async {
    Database db = await database;
    return await  db.delete(userTable,where: 'id == $id',whereArgs: [id]);
  }

  Future update(User event) async {
    Database db = await database;
    var update = db.update(userTable, event.toJson(),where: 'id == ${event.id}', whereArgs: [event.id] );
    return update;
  }

  Future close() async => db.close();


}

