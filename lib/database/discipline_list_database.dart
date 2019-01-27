import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io';

import 'package:catalogue/objects/discipline.dart';

class DisciplineListDb {

  final String _databaseName = 'discipline.db';
  final String _tableName = 'discipline_table';
  final String _colId = 'id';
  final String _colName = 'name';

  static DisciplineListDb _disciplineListDb;
  static Database _database;

  DisciplineListDb._createInstance();

  factory DisciplineListDb() {
    if (_disciplineListDb == null)
      _disciplineListDb = DisciplineListDb._createInstance();

    return _disciplineListDb;
  }

  Future<Database> get database async {

    if (_database == null)
      _database = await initDatabase();

    return _database;
  }

  Future<Database> initDatabase() async {

    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + _databaseName;
    Database disciplineListDb = await openDatabase(path, version: 1, onCreate: _createDatabase);

    return disciplineListDb;
  }

  _createDatabase(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $_tableName ($_colId INTEGER PRIMARY KEY AUTOINCREMENT, $_colName TEXT)');
  }

  Future<List<Map<String, dynamic>>> getDisciplineMap() async {

    Database db = await this.database;
    return await db.query(_tableName);
  }

  Future<int> insertDiscipline(String name) async {

    Database db = await this.database;
    Discipline discipline = Discipline(null, name);

    return await db.insert(_tableName, discipline.toMap());
  }

  Future<int> updateDisciplineName(Discipline discipline) async {

    Database db = await this.database;
    return await db.update(_tableName, discipline.toMap(), where: '$_colId = ?', whereArgs: [discipline.id]);
  }

  Future<int> deleteDiscipline(int id) async {

    Database db = await this.database;
    return await db.delete(_tableName, where: '$_colId = ?', whereArgs: [id]);
  }

  Future<List<Discipline>> getDisciplineList() async {

    var disciplineMap = await getDisciplineMap();
    int count = disciplineMap.length;

    List disciplineList = List<Discipline>();
    for (int i = 0; i < count; i++)
      disciplineList.add(Discipline.fromMap(disciplineMap[i]));

    return disciplineList;
  }

}