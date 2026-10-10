import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_selection_edit.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'account_persona_form_cubit.freezed.dart';
part 'account_persona_form_state.dart';

class AccountPersonaFormCubit extends Cubit<AccountPersonaFormState> {
  AccountPersonaFormCubit({
    required AccountPersonaCubit account,
    AccountRole? initialRole,
  }) : _account = account,
       super(
         AccountPersonaFormState(
           persona: account.state.persona,
           draft: AccountPersonaDraft(role: initialRole),
         ),
       ) {
    _subscription = account.stream.listen(_personaChanged);
  }

  final AccountPersonaCubit _account;
  late final StreamSubscription<AccountPersonaState> _subscription;

  void _personaChanged(AccountPersonaState account) {
    if (!isClosed) emit(state.copyWith(persona: account.persona));
  }

  void selectRole(AccountRole role) {
    if (isClosed || state.busy) return;
    emit(
      state.copyWith(
        draft: state.draft.copyWith(role: role),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void selectTeacher(Teacher teacher) =>
      _selectTeacher(TeacherSelectionEdit.select(teacher));

  void clearTeacher() => _selectTeacher(const TeacherSelectionEdit.clear());

  void _selectTeacher(TeacherSelectionEdit selection) {
    if (isClosed || state.busy) return;
    emit(
      state.copyWith(
        draft: state.draft.copyWith(selection: selection),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> save() async {
    if (isClosed || state.busy || !state.canSubmit || _account.isClosed) return;
    final role = state.role;
    final selection = state.draft.selection;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final saved = await _account.configure(
        role: role,
        teacher: switch (selection) {
          TeacherSelectionSelect(:final teacher) => teacher,
          _ => null,
        },
        clearTeacher: selection is TeacherSelectionClear,
      );
      if (isClosed) return;
      emit(
        state.copyWith(
          status: saved
              ? FormzSubmissionStatus.success
              : FormzSubmissionStatus.failure,
        ),
      );
    } on Exception {
      if (!isClosed) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
