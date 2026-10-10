part of 'account_persona_form_cubit.dart';

@freezed
abstract class AccountPersonaDraft with _$AccountPersonaDraft {
  const factory AccountPersonaDraft({
    AccountRole? role,
    @Default(TeacherSelectionEdit.keep()) TeacherSelectionEdit selection,
  }) = _AccountPersonaDraft;
}

@freezed
abstract class AccountPersonaFormState with _$AccountPersonaFormState {
  const factory AccountPersonaFormState({
    required AccountPersona persona,
    @Default(AccountPersonaDraft()) AccountPersonaDraft draft,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
  }) = _AccountPersonaFormState;

  const AccountPersonaFormState._();

  AccountRole get role => draft.role ?? persona.role;

  bool get busy => status == FormzSubmissionStatus.inProgress;

  bool get failed => status == FormzSubmissionStatus.failure;

  bool get canSubmit =>
      failed ||
      role != persona.role ||
      draft.selection is! TeacherSelectionKeep;

  Teacher? get teacher => switch (draft.selection) {
    TeacherSelectionSelect(:final teacher) => teacher,
    TeacherSelectionClear() => null,
    TeacherSelectionKeep() => switch ((
      persona.teacherId,
      persona.teacherName,
    )) {
      (final String id, final String name)
          when id.isNotEmpty && name.isNotEmpty =>
        Teacher(uid: id, name: name),
      _ => null,
    },
  };

  bool get teacherUnavailable =>
      draft.selection is TeacherSelectionKeep &&
      persona.teacherId != null &&
      teacher?.uid == persona.teacherId &&
      !persona.teacherAvailable;
}
