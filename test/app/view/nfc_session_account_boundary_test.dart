import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/view/nfc_session_account_boundary.dart';
import 'package:user_repository/user_repository.dart';

class _AppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  const signedIn = AppState(
    status: AppStatus.authenticated,
    user: User(id: 'student-a'),
  );

  testWidgets(
    'reconciles the stored owner before building and on account changes',
    (
      tester,
    ) async {
      final app = _AppBloc();
      final states = StreamController<AppState>();
      addTearDown(states.close);
      whenListen(app, states.stream, initialState: signedIn);
      final accounts = <String?>[];
      await tester.pumpWidget(
        BlocProvider<AppBloc>.value(
          value: app,
          child: NfcSessionAccountBoundary(
            organizationId: 'mirea',
            synchronizeSessionAccount: (accountId) {
              accounts.add(accountId);
              return Future<void>.value();
            },
            child: Builder(
              builder: (_) {
                expect(accounts, ['mirea:student-a']);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(accounts, ['mirea:student-a']);

      states.add(signedIn.copyWith(isAmoled: true));
      await tester.pump();
      expect(accounts, ['mirea:student-a']);

      states.add(
        const AppState(
          status: AppStatus.authenticated,
          user: User(id: 'student-b'),
        ),
      );
      await tester.pump();
      expect(accounts, ['mirea:student-a', 'mirea:student-b']);

      states.add(const AppState());
      await tester.pump();
      expect(accounts, ['mirea:student-a', 'mirea:student-b', null]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('does not postpone account invalidation behind pending cleanup', (
    tester,
  ) async {
    final app = _AppBloc();
    final states = StreamController<AppState>();
    addTearDown(states.close);
    whenListen(app, states.stream, initialState: signedIn);
    final firstCleanup = Completer<void>();
    var calls = 0;
    await tester.pumpWidget(
      BlocProvider<AppBloc>.value(
        value: app,
        child: NfcSessionAccountBoundary(
          organizationId: 'mirea',
          synchronizeSessionAccount: (_) {
            calls++;
            return calls == 1 ? firstCleanup.future : Future<void>.value();
          },
          child: const SizedBox(),
        ),
      ),
    );
    states.add(const AppState());
    await tester.pump();
    expect(calls, 2);
    firstCleanup.complete();
    await tester.pump();
  });

  testWidgets('reports cleanup failure without exposing storage error data', (
    tester,
  ) async {
    final app = _AppBloc();
    whenListen(app, const Stream<AppState>.empty(), initialState: signedIn);
    final errors = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = errors.add;
    addTearDown(() => FlutterError.onError = previous);

    await tester.pumpWidget(
      BlocProvider<AppBloc>.value(
        value: app,
        child: NfcSessionAccountBoundary(
          organizationId: 'mirea',
          synchronizeSessionAccount: (_) async =>
              throw StateError('private storage contents'),
          child: const SizedBox(key: ValueKey('application')),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('application')), findsOneWidget);
    expect(errors, hasLength(1));
    expect(errors.single.exceptionAsString(), isNot(contains('private')));
  });
}
