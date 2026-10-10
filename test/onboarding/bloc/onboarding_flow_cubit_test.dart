import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/onboarding/bloc/onboarding_flow_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

class _Repository extends Mock implements GamificationRepository {}

class _Persona extends Mock implements AccountPersonaCubit {}

const _teacher = Teacher(uid: 'chosen-teacher', name: 'Chosen Teacher');
const _group = Group(name: 'CHOSEN-01');
const _profile = ProfileOverview(
  academic: AcademicProfile(
    fullName: 'Saved Student',
    handle: 'saved_student',
    group: 'SAVED-01',
  ),
);

void main() {
  late _Repository repository;
  late _Persona persona;
  late String currentUser;
  late OnboardingFlowCubit flow;

  setUpAll(() {
    registerFallbackValue(AccountRole.student);
    registerFallbackValue(_teacher);
  });

  setUp(() {
    currentUser = 'current';
    repository = _Repository();
    persona = _Persona();
    when(() => persona.state).thenReturn(const AccountPersonaState());
    when(persona.restore).thenAnswer((_) async {});
    when(
      () => persona.configure(
        role: any(named: 'role'),
        teacher: any(named: 'teacher'),
        clearTeacher: any(named: 'clearTeacher'),
      ),
    ).thenAnswer((_) async => true);
    when(
      () => repository.ensureAcademicProfile(
        any(),
        academicGroup: any(named: 'academicGroup'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => repository.getProfileOverview(any()),
    ).thenAnswer((_) async => _profile);
    flow = OnboardingFlowCubit(
      repository: repository,
      organizationId: 'university',
      currentUserId: () => currentUser,
      isGuest: () => false,
      selectedGroup: () => null,
      persona: persona,
    );
  });

  tearDown(() async {
    if (!flow.isClosed) await flow.close();
  });

  test(
    'late restoration preserves teacher intent and skips saved identity',
    () async {
      final pending = Completer<ProfileOverview>();
      when(
        () => repository.getProfileOverview(any()),
      ).thenAnswer((_) => pending.future);
      final restored = flow.restore(onboardingShown: false);
      flow
        ..startTeacher()
        ..selectTeacher(_teacher);
      pending.complete(_profile);
      expect(await restored, isFalse);
      expect(flow.state.role, AccountRole.teacher);
      expect(flow.state.teacher, _teacher);
      expect(flow.state.stage, OnboardingStage.teacher);
      expect(flow.state.totalSteps, 3);
      flow.afterSelection();
      expect(flow.state.stage, OnboardingStage.settings);
    },
  );

  test(
    'late restoration preserves edited query and unsaved identity',
    () async {
      final pending = Completer<ProfileOverview>();
      when(
        () => repository.getProfileOverview(any()),
      ).thenAnswer((_) => pending.future);
      final restored = flow.restore(onboardingShown: false);
      flow
        ..start()
        ..updateGroupQuery('OTHER')
        ..updateIdentity('Draft Name', 'draft_handle');
      pending.complete(_profile);
      expect(await restored, isFalse);
      expect(flow.state.groupQuery, 'OTHER');
      expect(flow.state.group, isNull);
      expect(flow.state.identity.name, 'Draft Name');
      expect(flow.state.identity.handle, 'draft_handle');
      expect(flow.state.identity.verifiedHandle, isNull);
      expect(flow.state.totalSteps, 4);
    },
  );

  test(
    'editing a restored handle keeps verification bound to its saved value',
    () async {
      await flow.restore(onboardingShown: true);
      expect(flow.state.identity.complete, isTrue);
      flow.updateIdentity('Saved Student', 'unchecked_handle');
      expect(flow.state.identity.verifiedHandle, 'saved_student');
      expect(flow.state.identity.complete, isFalse);
    },
  );

  test(
    'early role selection keeps remote teacher for switching back',
    () async {
      final pending = Completer<void>();
      when(persona.restore).thenAnswer((_) => pending.future);
      final restored = flow.restore(onboardingShown: false);
      flow.startStudent();
      when(() => persona.state).thenReturn(
        const AccountPersonaState(
          persona: AccountPersona(
            role: AccountRole.teacher,
            teacherId: 'chosen-teacher',
            teacherName: 'Chosen Teacher',
            teacherAvailable: true,
          ),
        ),
      );
      pending.complete();
      expect(await restored, isFalse);
      expect(flow.state.role, AccountRole.student);
      expect(flow.state.teacher, _teacher);
      flow.startTeacher();
      expect(flow.state.teacher, _teacher);
    },
  );

  test('back and role changes preserve both selections and identity draft', () {
    flow
      ..startTeacher()
      ..selectTeacher(_teacher)
      ..startStudent()
      ..selectGroup(_group)
      ..afterSelection()
      ..updateIdentity('Draft Name', 'unchecked_handle')
      ..beforeIdentity()
      ..welcome()
      ..startTeacher();
    expect(flow.state.teacher, _teacher);
    expect(flow.state.group, _group);
    expect(flow.state.identity.handle, 'unchecked_handle');
    expect(flow.state.identity.verifiedHandle, isNull);
    flow
      ..afterSelection()
      ..completeIdentity('Saved Name', 'saved_name')
      ..beforeSettings();
    expect(flow.state.stage, OnboardingStage.identity);
    expect(flow.state.identity.verifiedHandle, 'saved_name');
  });

  test(
    'late restoration cannot resume or fill a replacement account',
    () async {
      final pending = Completer<ProfileOverview>();
      when(
        () => repository.getProfileOverview(any()),
      ).thenAnswer((_) => pending.future);
      final restored = flow.restore(onboardingShown: false);
      await Future<void>.delayed(Duration.zero);
      currentUser = 'replacement';
      pending.complete(_profile);
      expect(await restored, isFalse);
      expect(flow.state.group, isNull);
      expect(flow.state.identity.name, isNull);
    },
  );

  test(
    'teacher completion is atomic, rejects duplicate save and freezes draft',
    () async {
      final pending = Completer<void>();
      when(
        () => repository.ensureAcademicProfile('university'),
      ).thenAnswer((_) => pending.future);
      flow
        ..startTeacher()
        ..selectTeacher(_teacher);
      final saved = flow.prepareFinish();
      flow.startStudent();
      expect(await flow.prepareFinish(), isFalse);
      expect(flow.state.role, AccountRole.teacher);
      expect(flow.state.busy, isTrue);
      verifyNever(
        () => persona.configure(role: AccountRole.teacher, teacher: _teacher),
      );
      pending.complete();
      expect(await saved, isTrue);
      verify(
        () => persona.configure(role: AccountRole.teacher, teacher: _teacher),
      ).called(1);
      expect(flow.state.submission, FormzSubmissionStatus.success);
    },
  );

  test('teacher later clears binding through one configure call', () async {
    flow
      ..startTeacher()
      ..selectTeacher(_teacher)
      ..teacherLater();
    expect(await flow.prepareFinish(), isTrue);
    verify(
      () => persona.configure(role: AccountRole.teacher, clearTeacher: true),
    ).called(1);
  });

  test(
    'student completion syncs group and preserves existing teacher binding',
    () async {
      flow
        ..selectGroup(_group)
        ..startStudent();
      expect(await flow.prepareFinish(), isTrue);
      verify(
        () => repository.ensureAcademicProfile(
          'university',
          academicGroup: _group.name,
        ),
      ).called(1);
      verify(() => persona.configure(role: AccountRole.student)).called(1);
    },
  );

  test(
    'failed persona save remains editable and retries the same draft',
    () async {
      when(
        () => persona.configure(role: AccountRole.teacher, teacher: _teacher),
      ).thenAnswer((_) async => false);
      flow
        ..startTeacher()
        ..selectTeacher(_teacher);
      expect(await flow.prepareFinish(), isFalse);
      expect(flow.state.submission, FormzSubmissionStatus.failure);
      expect(flow.state.busy, isFalse);
      when(
        () => persona.configure(role: AccountRole.teacher, teacher: _teacher),
      ).thenAnswer((_) async => true);
      expect(await flow.prepareFinish(), isTrue);
      verify(
        () => persona.configure(role: AccountRole.teacher, teacher: _teacher),
      ).called(2);
    },
  );

  test('late restore cannot alter a submitted draft', () async {
    final pending = Completer<ProfileOverview>();
    when(
      () => repository.getProfileOverview(any()),
    ).thenAnswer((_) => pending.future);
    final restored = flow.restore(onboardingShown: false);
    await Future<void>.delayed(Duration.zero);
    flow
      ..startTeacher()
      ..selectTeacher(_teacher);
    expect(await flow.prepareFinish(), isTrue);
    pending.complete(_profile);
    expect(await restored, isFalse);
    expect(flow.state.teacher, _teacher);
    expect(flow.state.identity.name, isNull);
  });

  test('replacement account cannot complete a pending save', () async {
    final pending = Completer<void>();
    when(
      () => repository.ensureAcademicProfile('university'),
    ).thenAnswer((_) => pending.future);
    final saved = flow.prepareFinish();
    currentUser = 'replacement';
    pending.complete();
    expect(await saved, isFalse);
    verifyNever(() => persona.configure(role: AccountRole.student));
    expect(flow.state.submission, FormzSubmissionStatus.canceled);
  });

  test('closing during restore ignores its completion', () async {
    final pending = Completer<ProfileOverview>();
    when(
      () => repository.getProfileOverview(any()),
    ).thenAnswer((_) => pending.future);
    final restored = flow.restore(onboardingShown: false);
    await flow.close();
    pending.complete(_profile);
    expect(await restored, isFalse);
  });
}
