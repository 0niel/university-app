import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher.freezed.dart';
part 'teacher.g.dart';

@freezed
abstract class Teacher with _$Teacher {
  const factory Teacher({
    required String name,
    String? uid,
    String? photoUrl,
    String? email,
    String? phone,
    String? post,
    String? department,
  }) = _Teacher;

  factory Teacher.fromJson(Map<String, dynamic> json) => _$TeacherFromJson({
    ...json,
    if (json['name'] case final String name) 'name': normalizeTeacherName(name),
  });
}

final _joinedCyrillicNameParts = RegExp('([а-яё])([А-ЯЁ])');
final _teacherNameWhitespace = RegExp(r'\s+');

String normalizeTeacherName(String name) => name
    .replaceAllMapped(
      _joinedCyrillicNameParts,
      (match) => '${match[1]} ${match[2]}',
    )
    .replaceAll(_teacherNameWhitespace, ' ')
    .trim();
