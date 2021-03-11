import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test1/model/game_model.dart';
import 'package:test1/model/score_model.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'gameDB.db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE gamelist (id INTEGER PRIMARY KEY, name TEXT)');
    await db
        .execute('CREATE TABLE scorelist (id INTEGER PRIMARY KEY, gamename TEXT,username TEXT,score INTEGER)');
  }
  Future<ScoreModel> addScore(ScoreModel scoreModel) async {
    var dbClient = await db;
    scoreModel.id = await dbClient.insert('scorelist', scoreModel.toMap());
    return scoreModel;
  }
  Future<GameModel> add(GameModel gameModel) async {
    var dbClient = await db;
    gameModel.id = await dbClient.insert('gamelist', gameModel.toMap());
    return gameModel;
  }

  Future<List<GameModel>> getGame() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('gamelist', columns: ['id', 'name']);
    List<GameModel> students = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        students.add(GameModel.fromMap(maps[i]));
      }
    }
    return students;
  }
  Future<List<ScoreModel>> getScore() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('scorelist', columns: ['id', 'gamename','username','score']);
    List<ScoreModel> scoreModel = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        scoreModel.add(ScoreModel.fromMap(maps[i]));
      }
    }
    return scoreModel;
  }

  Future<int> deleteGameList() async {
    var dbClient = await db;
    return await dbClient.delete("gamelist");
  }

  Future<int> update(GameModel student) async {
    var dbClient = await db;
    return await dbClient.update(
      'student',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}