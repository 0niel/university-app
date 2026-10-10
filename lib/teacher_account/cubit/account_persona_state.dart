part of 'account_persona_cubit.dart';

enum AccountPersonaOperation { idle, restoring, saving, failed }

enum AccountPersonaEdit { roleOnly, teacherSelection }

@freezed
abstract class AccountPersonaState with _$AccountPersonaState {
  const factory AccountPersonaState({
    @Default(AccountPersona.empty) AccountPersona persona,
    @Default(false) bool loaded,
    @Default(AccountPersonaOperation.idle) AccountPersonaOperation operation,
    AccountPersonaEdit? pendingEdit,
    @Default(false) bool entryRequested,
  }) = _AccountPersonaState;

  const AccountPersonaState._();

  bool get loading => operation == AccountPersonaOperation.restoring;

  bool get saving => operation == AccountPersonaOperation.saving;

  bool get syncError => operation == AccountPersonaOperation.failed;

  bool get pendingSync => pendingEdit != null;

  bool get teacherSelectionPending =>
      pendingEdit == AccountPersonaEdit.teacherSelection;

  bool get isTeacher => persona.role == AccountRole.teacher;

  Teacher? get teacher {
    final id = persona.teacherId;
    final name = persona.teacherName;
    if (id == null || id.isEmpty || name == null || name.isEmpty) return null;
    return Teacher(uid: id, name: name);
  }
}
