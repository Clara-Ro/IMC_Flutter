import 'package:imc_flutter/database/database_interface.dart';
import 'package:imc_flutter/imcs.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLiteImpl implements Database{

  sql.Database? _database;

  Future<sql.Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<sql.Database> _initialize () async {
    var databasesPath = await sql.getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    return await sql.openDatabase(
      path,
      version: 1,
      singleInstance: true,
      onCreate: (sql.Database db, int version) async {
        await db.execute(
          'CREATE TABLE Imc (id INTEGER PRIMARY KEY, height REAL, weight REAL, IMC REAL, result TEXT)'
        );
      }
    );
  }

  @override
  Future<void> addIMC(IMCs imc) async{
    sql.Database db = await database;
    await db.rawInsert(
      'INSERT INTO Imc(height, weight, IMC, result) VALUES(?, ?, ?, ?)',
      [imc.height, imc.weight, imc.imc, imc.result]
    );
  }

  @override
  Future<List<IMCs>> getIMCs() async{
    sql.Database db = await database;
    List<Map> list = await db.rawQuery('SELECT * FROM Imc');
    return list.map((e) => IMCs(
      e['height'],
      e['weight'],
      e['IMC'],
      e['result']
    )).toList();
  }
}