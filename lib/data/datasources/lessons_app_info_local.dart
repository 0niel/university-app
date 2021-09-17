import 'package:rtu_mirea_app/domain/entities/lesson.dart';
import 'package:rtu_mirea_app/domain/entities/lesson_app_info.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class LessonsAppInfoLocalData {
  Future<List<LessonAppInfo>> getLessonsAppInfoFromStorage();
  Future<void> writeAppInfoToStorage(LessonAppInfo lessonsInfo);
}

class LessonsAppInfoLocalDataImpl extends LessonsAppInfoLocalData {

  LessonsAppInfoLocalDataImpl() {
    database = _getDbConnection();
  }

  late Future<Database> database;

  Future<Database> _getDbConnection() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'ninja.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMARY KEY, lessonCode TEXT, note TEXT);''',
        );
      },
    );
    return database;
  }

  @override
  Future<List<LessonAppInfo>> getLessonsAppInfoFromStorage() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('notes');

    return List.generate(maps.length, (i) {
      return LessonAppInfo(
        id: maps[i]['id'],
        lessonCode: maps[i]['lessonCode'],
        note: maps[i]['note'],
      );
    });
  }

  @override
  Future<void> writeAppInfoToStorage(LessonAppInfo lessonInfo) async {
    final db = await database;

    await db.insert(
      "notes",
      lessonInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}