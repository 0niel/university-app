import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/account_persona_form_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_selection_edit.dart';
import 'package:schedule_repository/schedule_repository.dart';

class _Account extends MockCubit<AccountPersonaState>
    implements AccountPersonaCubit {}

const _teacher = Teacher(uid: 'teacher-a', name: 'Teacher A');
const _other = Teacher(uid: 'teacher-b', name: 'Teacher B');
const _bound = AccountPersonaState(
  persona: AccountPersona(
    role: AccountRole.teacher,
    teacherId: 'teacher-a',
    teacherName: 'Teacher A',
    teacherAvailable: true,
  ),
  loaded: true,
);

void main() {
  late _Account account;
  late AccountPersonaFormCubit form;
  late StreamController<AccountPersonaState> updates;

  setUpAll(() {
    registerFallbackValue(AccountRole.student);
    registerFallbackValue(_teacher);
  });

  setUp(() {
    account = _Account();
    updates = StreamController<AccountPersonaState>.broadcast(sync: true);
    when(() => account.state).thenReturn(_bound);
    when(() => account.stream).thenAnswer((_) => updates.stream);
    when(() => account.isClosed).thenReturn(false);
    when(
      () => account.configure(
        role: any(named: 'role'),
        teacher: any(named: 'teacher'),
        clearTeacher: any(named: 'clearTeacher'),
      ),
    ).thenAnswer((_) async => true);
    form = AccountPersonaFormCubit(account: account);
  });

  tearDown(() async {
    if (!form.isClosed) await form.close();
    await updates.close();
  });

  test(
    'role-only save preserves the existing teacher in one request',
    () async {
      expect(form.state.canSubmit, isFalse);
      await form.save();
      verifyNever(
        () => account.configure(
          role: any(named: 'role'),
          teacher: any(named: 'teacher'),
          clearTeacher: any(named: 'clearTeacher'),
        ),
      );
      form.selectRole(AccountRole.student);
      await form.save();
      verify(() => account.configure(role: AccountRole.student)).called(1);
      expect(form.state.draft.selection, const TeacherSelectionEdit.keep());
      expect(form.state.teacher, _teacher);
      expect(form.state.status, FormzSubmissionStatus.success);
    },
  );

  test('selection replaces a clear intent in one atomic save', () async {
    form.clearTeacher();
    expect(form.state.teacher, isNull);
    expect(form.state.draft.selection, const TeacherSelectionEdit.clear());
    form
      ..selectTeacher(_other)
      ..selectRole(AccountRole.student);
    await form.save();
    verify(
      () => account.configure(role: AccountRole.student, teacher: _other),
    ).called(1);
    expect(form.state.teacher, _other);
    expect(form.state.status, FormzSubmissionStatus.success);
  });

  test('disconnect replaces selection while preserving teacher role', () async {
    form
      ..selectTeacher(_other)
      ..clearTeacher();
    await form.save();
    verify(
      () => account.configure(role: AccountRole.teacher, clearTeacher: true),
    ).called(1);
    expect(form.state.teacher, isNull);
    expect(form.state.role, AccountRole.teacher);
  });

  test('late restore fills untouched role and binding', () async {
    await form.close();
    when(() => account.state).thenReturn(const AccountPersonaState());
    form = AccountPersonaFormCubit(account: account);
    updates.add(_bound);
    expect(form.state.role, AccountRole.teacher);
    expect(form.state.teacher, _teacher);
    expect(form.state.canSubmit, isFalse);
  });

  test('late restore preserves edited role and selected teacher', () async {
    form
      ..selectRole(AccountRole.student)
      ..selectTeacher(_other);
    updates.add(
      _bound.copyWith(
        persona: _bound.persona.copyWith(
          teacherId: 'remote',
          teacherName: 'Remote teacher',
        ),
      ),
    );
    expect(form.state.role, AccountRole.student);
    expect(form.state.teacher, _other);
    await form.save();
    verify(
      () => account.configure(role: AccountRole.student, teacher: _other),
    ).called(1);
  });

  test(
    'late restore preserves explicit clear and initial role intent',
    () async {
      await form.close();
      when(() => account.state).thenReturn(const AccountPersonaState());
      form = AccountPersonaFormCubit(
        account: account,
        initialRole: AccountRole.teacher,
      )..clearTeacher();
      updates.add(
        _bound.copyWith(
          persona: _bound.persona.copyWith(role: AccountRole.student),
        ),
      );
      expect(form.state.role, AccountRole.teacher);
      expect(form.state.teacher, isNull);
      await form.save();
      verify(
        () => account.configure(role: AccountRole.teacher, clearTeacher: true),
      ).called(1);
    },
  );

  test(
    'busy form locks edits and duplicate saves then permits retry',
    () async {
      final response = Completer<bool>();
      when(
        () => account.configure(role: AccountRole.student),
      ).thenAnswer((_) => response.future);
      form.selectRole(AccountRole.student);
      final saving = form.save();
      expect(form.state.busy, isTrue);
      form
        ..selectRole(AccountRole.teacher)
        ..selectTeacher(_other)
        ..clearTeacher();
      await form.save();
      expect(form.state.role, AccountRole.student);
      expect(form.state.draft.selection, const TeacherSelectionEdit.keep());
      verify(() => account.configure(role: AccountRole.student)).called(1);
      updates.add(
        _bound.copyWith(
          persona: _bound.persona.copyWith(role: AccountRole.student),
        ),
      );
      response.complete(false);
      await saving;
      expect(form.state.failed, isTrue);
      expect(form.state.canSubmit, isTrue);
      when(
        () => account.configure(role: AccountRole.student),
      ).thenAnswer((_) async => true);
      await form.save();
      verify(() => account.configure(role: AccountRole.student)).called(1);
      expect(form.state.status, FormzSubmissionStatus.success);
    },
  );

  test('configure exception keeps draft editable', () async {
    when(
      () => account.configure(role: AccountRole.student),
    ).thenThrow(Exception('Save failed'));
    form.selectRole(AccountRole.student);
    await form.save();
    expect(form.state.failed, isTrue);
    expect(form.state.busy, isFalse);
    expect(form.state.role, AccountRole.student);
    form.selectTeacher(_other);
    expect(form.state.failed, isFalse);
    expect(form.state.teacher, _other);
  });

  test('closing while saving ignores the late completion', () async {
    final response = Completer<bool>();
    when(
      () => account.configure(role: AccountRole.student),
    ).thenAnswer((_) => response.future);
    form.selectRole(AccountRole.student);
    final saving = form.save();
    await form.close();
    response.complete(true);
    await expectLater(saving, completes);
    expect(form.isClosed, isTrue);
    expect(form.state.status, FormzSubmissionStatus.inProgress);
  });

  test('only a kept unavailable teacher displays the availability warning', () {
    updates.add(
      _bound.copyWith(
        persona: _bound.persona.copyWith(teacherAvailable: false),
      ),
    );
    expect(form.state.teacherUnavailable, isTrue);
    form.selectTeacher(_other);
    expect(form.state.teacherUnavailable, isFalse);
    form.clearTeacher();
    expect(form.state.teacherUnavailable, isFalse);
  });
}
