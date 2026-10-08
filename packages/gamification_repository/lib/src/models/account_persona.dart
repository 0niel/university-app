import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_persona.freezed.dart';
part 'account_persona.g.dart';

enum AccountRole { student, teacher }

@freezed
abstract class AccountPersona with _$AccountPersona {
  const factory AccountPersona({
    @Default(AccountRole.student) AccountRole role,
    String? teacherId,
    String? teacherName,
    @Default(false) bool teacherAvailable,
    @Default(0) int revision,
  }) = _AccountPersona;

  factory AccountPersona.fromJson(Map<String, Object?> json) =>
      _$AccountPersonaFromJson(json);

  static const empty = AccountPersona();
}
