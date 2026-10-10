import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _Repository extends Mock implements GamificationRepository {}

class _Storage extends Mock implements Storage {}

class _Observer extends BlocObserver {
  final errors = <Object>[];

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    errors.add(error);
    super.onError(bloc, error, stackTrace);
  }
}

const _teacher = Teacher(uid: 'teacher-a', name: 'Иванов Иван Иванович');
const _otherTeacher = Teacher(uid: 'teacher-b', name: 'Иванов Иван Иванович');
const _saved = AccountPersona(
  role: AccountRole.teacher,
  teacherId: 'teacher-a',
  teacherName: 'Иванов Иван Иванович',
  teacherAvailable: true,
  revision: 3,
);

void main() {
  late _Repository repository;
  late _Storage storage;
  late Map<String, dynamic> values;
  String? owner;

  setUpAll(() => registerFallbackValue(AccountRole.student));

  setUp(() {
    owner = 'account-a';
    values = {};
    storage = _Storage();
    when(() => storage.read(any())).thenAnswer(
      (invocation) => values[invocation.positionalArguments.first],
    );
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((call) async {
      values[call.positionalArguments.first as String] =
          call.positionalArguments[1];
    });
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    repository = _Repository();
    when(
      () => repository.ensureAcademicProfile(any()),
    ).thenAnswer((_) async {});
    when(
      () => repository.getAccountPersona(
        organizationId: any(named: 'organizationId'),
        expectedUserId: any(named: 'expectedUserId'),
      ),
    ).thenAnswer((_) async => AccountPersona.empty);
    when(
      () => repository.setAccountPersona(
        organizationId: any(named: 'organizationId'),
        expectedUserId: any(named: 'expectedUserId'),
        role: any(named: 'role'),
        teacherId: any(named: 'teacherId'),
        expectedRevision: any(named: 'expectedRevision'),
      ),
    ).thenAnswer((call) async {
      final teacherId = call.namedArguments[#teacherId] as String?;
      return AccountPersona(
        role: call.namedArguments[#role] as AccountRole,
        teacherId: teacherId,
        teacherName: teacherId == null ? null : _teacher.name,
        teacherAvailable: teacherId != null,
        revision: (call.namedArguments[#expectedRevision] as int) + 1,
      );
    });
  });

  AccountPersonaCubit create({
    String user = 'account-a',
    String org = 'campus',
    AccountRole? entryRole,
  }) {
    final cubit = AccountPersonaCubit(
      userId: user,
      organizationId: org,
      repository: repository,
      currentUserId: () => owner,
      entryRole: entryRole,
    );
    addTearDown(cubit.close);
    return cubit;
  }

  test('restores canonical teacher binding and server revision', () async {
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer((_) async => _saved);
    final cubit = create();
    await cubit.restore();
    expect(cubit.state.loaded, isTrue);
    expect(cubit.state.isTeacher, isTrue);
    expect(cubit.state.teacher?.uid, _teacher.uid);
    expect(cubit.state.persona.revision, 3);
  });

  test('teacher entry on a fresh device retains the remote binding', () async {
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer((_) async => _saved);
    final cubit = create(entryRole: AccountRole.teacher);
    await cubit.restore();
    expect(cubit.state.persona, _saved);
    expect(cubit.state.entryRequested, isTrue);
    expect(cubit.state.pendingSync, isFalse);
    verifyNever(
      () => repository.setAccountPersona(
        organizationId: any(named: 'organizationId'),
        expectedUserId: any(named: 'expectedUserId'),
        role: any(named: 'role'),
        teacherId: any(named: 'teacherId'),
        expectedRevision: any(named: 'expectedRevision'),
      ),
    );
  });

  test(
    'student entry changes role while retaining teacher selection',
    () async {
      when(
        () => repository.getAccountPersona(
          organizationId: 'campus',
          expectedUserId: 'account-a',
        ),
      ).thenAnswer((_) async => _saved);
      final cubit = create(entryRole: AccountRole.student);
      await cubit.restore();
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.isTeacher, isFalse);
      expect(cubit.state.entryRequested, isFalse);
      expect(cubit.state.teacher?.uid, 'teacher-a');
      expect(cubit.state.pendingSync, isFalse);
      verify(
        () => repository.setAccountPersona(
          organizationId: 'campus',
          expectedUserId: 'account-a',
          role: AccountRole.student,
          teacherId: 'teacher-a',
          expectedRevision: 3,
        ),
      ).called(1);
    },
  );

  test('offline role intent retains remote binding after restarting', () async {
    when(
      () => repository.ensureAcademicProfile(any()),
    ).thenThrow(Exception('offline'));
    when(
      () => repository.setAccountPersona(
        organizationId: any(named: 'organizationId'),
        expectedUserId: any(named: 'expectedUserId'),
        role: any(named: 'role'),
        teacherId: any(named: 'teacherId'),
        expectedRevision: any(named: 'expectedRevision'),
      ),
    ).thenThrow(Exception('offline'));
    final offline = create(entryRole: AccountRole.teacher);
    await offline.restore();
    await Future<void>.delayed(Duration.zero);
    expect(offline.state.pendingSync, isTrue);
    expect(offline.state.teacherSelectionPending, isFalse);
    final resumed = create();
    when(
      () => repository.ensureAcademicProfile(any()),
    ).thenAnswer((_) async {});
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer((_) async => _saved);
    await resumed.restore();
    expect(resumed.state.teacher?.uid, 'teacher-a');
    expect(resumed.state.pendingSync, isFalse);
  });

  test(
    'failed bootstrap preserves the choice without an unauthorized write',
    () async {
      when(
        () => repository.ensureAcademicProfile(any()),
      ).thenThrow(Exception('offline'));
      when(
        () => repository.setAccountPersona(
          organizationId: any(named: 'organizationId'),
          expectedUserId: any(named: 'expectedUserId'),
          role: any(named: 'role'),
          teacherId: any(named: 'teacherId'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenThrow(
        const PostgrestException(
          message: 'Organization access denied',
          code: '42501',
        ),
      );
      final cubit = create();
      expect(await cubit.selectTeacher(_otherTeacher), isTrue);
      expect(cubit.state.teacher?.uid, 'teacher-b');
      expect(cubit.state.pendingSync, isTrue);
      expect(cubit.state.syncError, isTrue);
      verifyNever(
        () => repository.setAccountPersona(
          organizationId: any(named: 'organizationId'),
          expectedUserId: any(named: 'expectedUserId'),
          role: any(named: 'role'),
          teacherId: any(named: 'teacherId'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      );
      when(
        () => repository.ensureAcademicProfile(any()),
      ).thenAnswer((_) async {});
      when(
        () => repository.getAccountPersona(
          organizationId: 'campus',
          expectedUserId: 'account-a',
        ),
      ).thenAnswer((_) async => _saved);
      when(
        () => repository.setAccountPersona(
          organizationId: 'campus',
          expectedUserId: 'account-a',
          role: AccountRole.teacher,
          teacherId: 'teacher-b',
          expectedRevision: 3,
        ),
      ).thenAnswer(
        (_) async => _saved.copyWith(teacherId: 'teacher-b', revision: 4),
      );
      await cubit.retry();
      expect(cubit.state.teacher?.uid, 'teacher-b');
      expect(cubit.state.persona.revision, 4);
      expect(cubit.state.pendingSync, isFalse);
      expect(cubit.state.syncError, isFalse);
    },
  );

  test(
    'missing backend RPC reports the original error and keeps the edit',
    () async {
      final observer = _Observer();
      final previous = Bloc.observer;
      Bloc.observer = observer;
      addTearDown(() => Bloc.observer = previous);
      const error = PostgrestException(
        message: 'RPC unavailable',
        code: 'PGRST202',
      );
      when(
        () => repository.getAccountPersona(
          organizationId: 'campus',
          expectedUserId: 'account-a',
        ),
      ).thenThrow(error);
      final cubit = create();
      expect(await cubit.selectTeacher(_teacher), isTrue);
      expect(cubit.state.pendingSync, isTrue);
      expect(cubit.state.syncError, isTrue);
      expect(observer.errors, [same(error)]);
      verifyNever(
        () => repository.setAccountPersona(
          organizationId: any(named: 'organizationId'),
          expectedUserId: any(named: 'expectedUserId'),
          role: any(named: 'role'),
          teacherId: any(named: 'teacherId'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      );
    },
  );

  test('coalesces retries while restoration is in flight', () async {
    final response = Completer<AccountPersona>();
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer((_) => response.future);
    final cubit = create();
    final original = cubit.restore();
    await Future<void>.delayed(Duration.zero);
    final retry = cubit.retry();
    await Future<void>.delayed(Duration.zero);
    verify(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).called(1);
    response.complete(_saved);
    await Future.wait([original, retry]);
    expect(cubit.state.persona, _saved);
    expect(cubit.state.loading, isFalse);
  });

  test('serializes a retry with a simultaneous new selection', () async {
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer((_) async => _saved);
    final cubit = create();
    await cubit.restore();
    final restoring = Completer<AccountPersona>();
    final saving = Completer<AccountPersona>();
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer((_) => restoring.future);
    when(
      () => repository.setAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
        role: AccountRole.teacher,
        teacherId: 'teacher-b',
        expectedRevision: 3,
      ),
    ).thenAnswer((_) => saving.future);
    final retry = cubit.retry();
    final selection = cubit.selectTeacher(_otherTeacher);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.operation, AccountPersonaOperation.restoring);
    verifyNever(
      () => repository.setAccountPersona(
        organizationId: any(named: 'organizationId'),
        expectedUserId: any(named: 'expectedUserId'),
        role: any(named: 'role'),
        teacherId: any(named: 'teacherId'),
        expectedRevision: any(named: 'expectedRevision'),
      ),
    );
    restoring.complete(_saved);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.operation, AccountPersonaOperation.saving);
    saving.complete(_saved.copyWith(teacherId: 'teacher-b', revision: 4));
    await Future.wait([retry, selection]);
    expect(cubit.state.teacher?.uid, 'teacher-b');
    expect(cubit.state.persona.revision, 4);
    expect(cubit.state.operation, AccountPersonaOperation.idle);
    expect(cubit.state.pendingEdit, isNull);
  });

  test('configures role and unlink in one atomic request', () async {
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer((_) async => _saved);
    final cubit = create();
    await cubit.restore();
    expect(
      await cubit.configure(role: AccountRole.student, clearTeacher: true),
      isTrue,
    );
    verify(
      () => repository.setAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
        role: AccountRole.student,
        expectedRevision: 3,
      ),
    ).called(1);
    expect(cubit.state.teacher, isNull);
    expect(cubit.state.teacherSelectionPending, isFalse);
  });

  test('rejected CAS rebase restores the latest remote confirmation', () async {
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer((_) async => _saved);
    final cubit = create();
    await cubit.restore();
    const remote = AccountPersona(revision: 4);
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer((_) async => remote);
    when(
      () => repository.setAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
        role: AccountRole.teacher,
        teacherId: 'teacher-b',
        expectedRevision: 3,
      ),
    ).thenThrow(const AccountPersonaConflictException());
    when(
      () => repository.setAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
        role: AccountRole.teacher,
        teacherId: 'teacher-b',
        expectedRevision: 4,
      ),
    ).thenThrow(
      const PostgrestException(message: 'Unavailable', code: '22023'),
    );
    expect(await cubit.selectTeacher(_otherTeacher), isFalse);
    expect(cubit.state.persona, remote);
    expect(cubit.state.pendingSync, isFalse);
  });

  test(
    'student mode retains binding and selecting a namesake changes UID',
    () async {
      final cubit = create();
      await cubit.selectTeacher(_teacher);
      await cubit.selectRole(AccountRole.student);
      expect(cubit.state.isTeacher, isFalse);
      expect(cubit.state.teacher?.uid, 'teacher-a');
      await cubit.selectTeacher(_otherTeacher);
      expect(cubit.state.isTeacher, isTrue);
      expect(cubit.state.teacher?.uid, 'teacher-b');
      await cubit.clearTeacher();
      expect(cubit.state.teacher, isNull);
      expect(cubit.state.isTeacher, isTrue);
    },
  );

  test('late restoration preserves newer explicit selection', () async {
    final restore = Completer<AccountPersona>();
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer((_) => restore.future);
    final cubit = create();
    final restoring = cubit.restore();
    await Future<void>.delayed(Duration.zero);
    final selecting = cubit.selectTeacher(_otherTeacher);
    expect(cubit.state.teacher?.uid, 'teacher-b');
    restore.complete(_saved);
    await restoring;
    expect(await selecting, isTrue);
    expect(cubit.state.teacher?.uid, 'teacher-b');
    verify(
      () => repository.setAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
        role: AccountRole.teacher,
        teacherId: 'teacher-b',
        expectedRevision: 3,
      ),
    ).called(1);
  });

  test(
    'serializes in-flight saves and drains the most recent choice',
    () async {
      final first = Completer<AccountPersona>();
      when(
        () => repository.setAccountPersona(
          organizationId: 'campus',
          expectedUserId: 'account-a',
          role: AccountRole.teacher,
          teacherId: 'teacher-a',
          expectedRevision: 0,
        ),
      ).thenAnswer((_) => first.future);
      final cubit = create();
      await cubit.restore();
      final selectingFirst = cubit.selectTeacher(_teacher);
      await Future<void>.delayed(Duration.zero);
      final selectingLast = cubit.selectTeacher(_otherTeacher);
      first.complete(_saved.copyWith(revision: 1));
      await Future.wait([selectingFirst, selectingLast]);
      expect(cubit.state.teacher?.uid, 'teacher-b');
      expect(cubit.state.persona.revision, 2);
      expect(cubit.state.pendingSync, isFalse);
    },
  );

  test('rejects a late restore and writes after switching accounts', () async {
    final pending = Completer<AccountPersona>();
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer((_) => pending.future);
    final cubit = create();
    final restoring = cubit.restore();
    await Future<void>.delayed(Duration.zero);
    owner = 'account-b';
    pending.complete(_saved);
    await restoring;
    expect(cubit.state.teacher, isNull);
    expect(await cubit.selectTeacher(_teacher), isFalse);
    verifyNever(
      () => repository.setAccountPersona(
        organizationId: any(named: 'organizationId'),
        expectedUserId: any(named: 'expectedUserId'),
        role: any(named: 'role'),
        teacherId: any(named: 'teacherId'),
        expectedRevision: any(named: 'expectedRevision'),
      ),
    );
  });

  test('hydrates separately per user and organization', () async {
    final first = create();
    await first.selectTeacher(_teacher);
    final same = create();
    expect(same.state.teacher?.uid, 'teacher-a');
    final otherAccount = create(user: 'account-b');
    final otherCampus = create(org: 'other-campus');
    expect(otherAccount.state.teacher, isNull);
    expect(otherCampus.state.teacher, isNull);
  });

  test('legacy role intent rebases onto the current remote teacher', () async {
    final seed = create();
    await seed.restore();
    values[values.keys.single] = {
      'persona': _saved.copyWith(role: AccountRole.student).toJson(),
      'pendingSync': true,
      'teacherSelectionPending': false,
    };
    final resumed = create();
    expect(resumed.state.pendingEdit, AccountPersonaEdit.roleOnly);
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer(
      (_) async => _saved.copyWith(teacherId: 'teacher-b', revision: 4),
    );
    await resumed.restore();
    await Future<void>.delayed(Duration.zero);
    expect(resumed.state.persona.role, AccountRole.student);
    expect(resumed.state.teacher?.uid, 'teacher-b');
    expect(resumed.state.pendingEdit, isNull);
    verify(
      () => repository.setAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
        role: AccountRole.student,
        teacherId: 'teacher-b',
        expectedRevision: 4,
      ),
    ).called(1);
  });

  test('legacy pending unlink survives hydration and remote restore', () async {
    final seed = create();
    await seed.restore();
    values[values.keys.single] = {
      'persona': const AccountPersona(role: AccountRole.teacher).toJson(),
      'pendingSync': true,
      'teacherSelectionPending': true,
    };
    final resumed = create();
    expect(resumed.state.pendingEdit, AccountPersonaEdit.teacherSelection);
    when(
      () => repository.getAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
      ),
    ).thenAnswer((_) async => _saved);
    await resumed.restore();
    await Future<void>.delayed(Duration.zero);
    expect(resumed.state.teacher, isNull);
    expect(resumed.state.isTeacher, isTrue);
    expect(resumed.state.pendingEdit, isNull);
    verify(
      () => repository.setAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
        role: AccountRole.teacher,
        expectedRevision: 3,
      ),
    ).called(1);
  });

  test('hydration retains only the persona and typed pending edit', () {
    final cubit = create();
    const pending = AccountPersonaState(
      persona: _saved,
      loaded: true,
      operation: AccountPersonaOperation.failed,
      pendingEdit: AccountPersonaEdit.teacherSelection,
      entryRequested: true,
    );
    final hydrated = cubit.fromJson(cubit.toJson(pending));
    expect(hydrated?.persona, _saved);
    expect(hydrated?.pendingEdit, AccountPersonaEdit.teacherSelection);
    expect(hydrated?.loaded, isFalse);
    expect(hydrated?.operation, AccountPersonaOperation.idle);
    expect(hydrated?.entryRequested, isFalse);
    expect(
      cubit.fromJson({'persona': _saved.toJson(), 'pendingEdit': 'unknown'}),
      isNull,
    );
  });

  test('retains offline choice for explicit retry', () async {
    when(
      () => repository.setAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
        role: AccountRole.teacher,
        teacherId: 'teacher-a',
        expectedRevision: 0,
      ),
    ).thenThrow(Exception('offline'));
    final cubit = create();
    expect(await cubit.selectTeacher(_teacher), isTrue);
    expect(cubit.state.pendingSync, isTrue);
    expect(cubit.state.syncError, isTrue);
    expect(cubit.state.saving, isFalse);
    when(
      () => repository.setAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
        role: AccountRole.teacher,
        teacherId: 'teacher-a',
        expectedRevision: 0,
      ),
    ).thenAnswer((_) async => _saved.copyWith(revision: 1));
    await cubit.retry();
    expect(cubit.state.pendingSync, isFalse);
    expect(cubit.state.syncError, isFalse);
  });

  test('server rejection rolls back an invalid teacher selection', () async {
    when(
      () => repository.setAccountPersona(
        organizationId: 'campus',
        expectedUserId: 'account-a',
        role: AccountRole.teacher,
        teacherId: 'teacher-a',
        expectedRevision: 0,
      ),
    ).thenThrow(
      const PostgrestException(message: 'Unavailable', code: '22023'),
    );
    final cubit = create();
    expect(await cubit.selectTeacher(_teacher), isFalse);
    expect(cubit.state.teacher, isNull);
    expect(cubit.state.pendingSync, isFalse);
    expect(cubit.state.saving, isFalse);
  });
}
