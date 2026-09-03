import 'dart:convert';

import 'package:rtu_mirea_app/grades/models/grades_book.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class GradesRepository {
  Future<GradesBook> load();

  Future<void> save(GradesBook book);
}

class LocalGradesRepository implements GradesRepository {
  const LocalGradesRepository({this.userId});

  final String? userId;
  String get _storageKey => userId == null
      ? storageKey
      : '$storageKey.${Uri.encodeComponent(userId!)}';

  static const storageKey = 'grades.book';

  @override
  Future<GradesBook> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return const GradesBook();
    final json = jsonDecode(raw);
    if (json is! Map) throw const FormatException('Grades book is invalid');
    return GradesBook.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Future<void> save(GradesBook book) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString(_storageKey, jsonEncode(book.toJson()));
    if (!saved) throw StateError('Grades were not saved');
  }
}
