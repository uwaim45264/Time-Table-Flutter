import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/timetable.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('timetable.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE timetable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      subject TEXT,
      startTime TEXT,
      endTime TEXT,
      day TEXT,
      location TEXT,
      notes TEXT
    )
    ''');
  }

  Future<void> insertTimetable(Timetable timetable) async {
    final db = await database;
    await db.insert('timetable', timetable.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Timetable>> getTimetables() async {
    final db = await database;
    final maps = await db.query('timetable');
    return List.generate(maps.length, (i) => Timetable.fromMap(maps[i]));
  }

  Future<void> updateTimetable(Timetable timetable) async {
    final db = await database;
    await db.update('timetable', timetable.toMap(),
        where: 'id = ?', whereArgs: [timetable.id]);
  }

  Future<void> deleteTimetable(int id) async {
    final db = await database;
    await db.delete('timetable', where: 'id = ?', whereArgs: [id]);
  }
}