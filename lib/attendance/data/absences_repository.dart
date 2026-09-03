import 'dart:convert';

import 'package:rtu_mirea_app/attendance/models/absence.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AbsencesRepository {
  Future<List<Absence>> load();

  Future<void> save(List<Absence> absences);
}

class LocalAbsencesRepository implements AbsencesRepository {
  const LocalAbsencesRepository({this.userId});

  final String? userId;
  String get _storageKey => userId == null
      ? storageKey
      : '$storageKey.${Uri.encodeComponent(userId!)}';

  static const storageKey = 'attendance.absences';

  @override
  Future<List<Absence>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return const [];
    final json = jsonDecode(raw);
    if (json is! List) throw const FormatException('Absences are invalid');
    return [
      for (final item in json)
        Absence.fromJson(Map<String, dynamic>.from(item as Map)),
    ];
  }

  @override
  Future<void> save(List<Absence> absences) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString(
      _storageKey,
      jsonEncode([for (final absence in absences) absence.toJson()]),
    );
    if (!saved) throw StateError('Absences were not saved');
  }
}
