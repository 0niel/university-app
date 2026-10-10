import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/account_persona_lifecycle.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _Repository extends Mock implements GamificationRepository {}

class _Storage extends Mock implements Storage {}

class _Account extends MockCubit<AccountPersonaState>
    implements AccountPersonaCubit {}

const _teacher = Teacher(uid: 'teacher-a', name: 'Иванов Иван Иванович');
const _saved = AccountPersona(
  role: AccountRole.teacher,
  teacherId: 'teacher-a',
  teacherName: 'Иванов Иван Иванович',
  teacherAvailable: true,
  revision: 3,
);

void main() {
  setUpAll(() => registerFallbackValue(AccountRole.student));

  Future<void> pumpLifecycle(
    WidgetTester tester,
    AccountPersonaCubit account,
  ) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpWidget(
      BlocProvider<AccountPersonaCubit>.value(
        value: account,
        child: const AccountPersonaLifecycle(child: SizedBox()),
      ),
    );
  }

  Future<void> resume(WidgetTester tester) async {
    const [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ].forEach(tester.binding.handleAppLifecycleStateChanged);
    await tester.pumpAndSettle();
  }

  for (final pendingChoice in [false, true]) {
    final target = pendingChoice ? 'the queued choice' : 'a failed read';
    testWidgets(
      'resume recovers $target after RPC becomes available',
      (tester) async {
        final storage = _Storage();
        when(() => storage.read(any())).thenReturn(null);
        when(
          () => storage.write(any(), any<dynamic>()),
        ).thenAnswer((_) async {});
        HydratedBloc.storage = storage;
        final repository = _Repository();
        when(
          () => repository.ensureAcademicProfile('campus'),
        ).thenAnswer((_) async {});
        when(
          () => repository.getAccountPersona(
            organizationId: 'campus',
            expectedUserId: 'account-a',
          ),
        ).thenThrow(
          const PostgrestException(
            message: 'RPC unavailable',
            code: 'PGRST202',
          ),
        );
        when(
          () => repository.setAccountPersona(
            organizationId: 'campus',
            expectedUserId: 'account-a',
            role: AccountRole.teacher,
            teacherId: 'teacher-a',
            expectedRevision: 0,
          ),
        ).thenAnswer((_) async => _saved.copyWith(revision: 1));
        final account = AccountPersonaCubit(
          userId: 'account-a',
          organizationId: 'campus',
          repository: repository,
          currentUserId: () => 'account-a',
        );
        addTearDown(account.close);
        if (pendingChoice) {
          expect(await account.selectTeacher(_teacher), isTrue);
        } else {
          await account.restore();
        }
        expect(account.state.syncError, isTrue);
        expect(account.state.pendingSync, pendingChoice);
        clearInteractions(repository);
        await pumpLifecycle(tester, account);
        when(
          () => repository.getAccountPersona(
            organizationId: 'campus',
            expectedUserId: 'account-a',
          ),
        ).thenAnswer(
          (_) async => pendingChoice ? AccountPersona.empty : _saved,
        );
        await resume(tester);
        expect(account.state.teacher?.uid, 'teacher-a');
        expect(account.state.persona.revision, pendingChoice ? 1 : 3);
        expect(account.state.syncError, isFalse);
        expect(account.state.pendingSync, isFalse);
        verify(
          () => repository.getAccountPersona(
            organizationId: 'campus',
            expectedUserId: 'account-a',
          ),
        ).called(1);
        if (pendingChoice) {
          verify(
            () => repository.setAccountPersona(
              organizationId: 'campus',
              expectedUserId: 'account-a',
              role: AccountRole.teacher,
              teacherId: 'teacher-a',
              expectedRevision: 0,
            ),
          ).called(1);
        } else {
          verifyNever(
            () => repository.setAccountPersona(
              organizationId: any(named: 'organizationId'),
              expectedUserId: any(named: 'expectedUserId'),
              role: any(named: 'role'),
              teacherId: any(named: 'teacherId'),
              expectedRevision: any(named: 'expectedRevision'),
            ),
          );
        }
        clearInteractions(repository);
        await resume(tester);
        verifyNever(() => repository.ensureAcademicProfile(any()));
        await tester.pumpWidget(const SizedBox());
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final state in const [
    AccountPersonaState(pendingEdit: AccountPersonaEdit.roleOnly),
    AccountPersonaState(
      loaded: true,
      operation: AccountPersonaOperation.restoring,
      pendingEdit: AccountPersonaEdit.roleOnly,
    ),
    AccountPersonaState(
      loaded: true,
      operation: AccountPersonaOperation.saving,
      pendingEdit: AccountPersonaEdit.roleOnly,
    ),
  ]) {
    final phase = !state.loaded
        ? 'an unresolved profile'
        : state.operation.name;
    testWidgets(
      'resume leaves $phase to its active owner',
      (tester) async {
        final account = _Account();
        when(() => account.state).thenReturn(state);
        when(account.retry).thenAnswer((_) async {});
        await pumpLifecycle(tester, account);
        await resume(tester);
        verifyNever(account.retry);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  testWidgets('disposed account scope stops receiving resume requests', (
    tester,
  ) async {
    final account = _Account();
    when(() => account.state).thenReturn(
      const AccountPersonaState(
        loaded: true,
        operation: AccountPersonaOperation.failed,
        pendingEdit: AccountPersonaEdit.teacherSelection,
      ),
    );
    when(account.retry).thenAnswer((_) async {});
    await pumpLifecycle(tester, account);
    await tester.pumpWidget(const SizedBox());
    await resume(tester);
    verifyNever(account.retry);
    expect(tester.takeException(), isNull);
  });
}
