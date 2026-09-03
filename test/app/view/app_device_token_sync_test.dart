import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/services/device_token_sync_controller.dart';
import 'package:rtu_mirea_app/app/view/app_device_token_sync.dart';
import 'package:user_repository/user_repository.dart';

class _App extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  AppState user(String id) => AppState(
    status: .authenticated,
    user: User(id: id, isNewUser: false),
  );

  for (final rapid in [false, true]) {
    testWidgets('rebinds authenticated identity changes rapid=$rapid', (
      tester,
    ) async {
      final app = _App();
      final states = StreamController<AppState>.broadcast(sync: true);
      final refresh = StreamController<String>.broadcast(sync: true);
      var current = user('A');
      when(() => app.state).thenAnswer((_) => current);
      when(() => app.stream).thenAnswer((_) => states.stream);
      void emit(AppState state) {
        current = state;
        states.add(state);
      }

      final calls = <String>[];
      String? token;
      var sequence = 0;
      final registration = rapid ? Completer<void>() : null;
      final controller = DeviceTokenSyncController(
        getToken: () async => token ??= 'token-${++sequence}',
        tokenRefresh: refresh.stream,
        register: (value) async {
          calls.add('register:${app.state.user.id}:$value');
          if (registration != null) await registration.future;
        },
        unregister: (value) async => calls.add('unregister:$value'),
        deleteToken: () async {
          calls.add('delete:$token');
          token = null;
        },
        onError: (error, stackTrace) => fail('$error\n$stackTrace'),
      );
      addTearDown(() async {
        if (registration != null && !registration.isCompleted) {
          registration.complete();
        }
        await tester.pumpWidget(const SizedBox());
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pump();
        unawaited(states.close());
        unawaited(refresh.close());
        unawaited(app.close());
      });
      await tester.pumpWidget(
        BlocProvider<AppBloc>.value(
          value: app,
          child: AppDeviceTokenSync(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(calls, ['register:A:token-1']);
      expect(states.hasListener, isTrue);
      emit(user('B'));
      if (rapid) {
        await tester.pump();
        emit(user('C'));
        await tester.pump();
        registration!.complete();
      }
      await tester.pumpAndSettle();
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();
      expect(calls, [
        'register:A:token-1',
        'delete:token-1',
        'register:${rapid ? 'C' : 'B'}:token-2',
      ]);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'controller replacement retries failed token invalidation first',
    (
      tester,
    ) async {
      final app = _App();
      final states = StreamController<AppState>.broadcast(sync: true);
      var current = user('A');
      when(() => app.state).thenAnswer((_) => current);
      when(() => app.stream).thenAnswer((_) => states.stream);
      final calls = <String>[];
      final refresh = StreamController<String>.broadcast(sync: true);
      var failures = 1;
      DeviceTokenSyncController controller(String label) =>
          DeviceTokenSyncController(
            getToken: () async => label,
            tokenRefresh: refresh.stream,
            register: (token) async => calls.add('register:$token'),
            unregister: (token) async => calls.add('unregister:$token'),
            deleteToken: () async {
              calls.add('delete:$label');
              if (label == 'old' && failures-- > 0) {
                throw Exception('temporary rotation failure');
              }
            },
            onError: (error, stackTrace) => fail('$error\n$stackTrace'),
          );
      final old = controller('old');
      final next = controller('new');
      Widget view(DeviceTokenSyncController value) =>
          BlocProvider<AppBloc>.value(
            value: app,
            child: AppDeviceTokenSync(
              controller: value,
              child: const SizedBox(),
            ),
          );
      Future<void> settle() async {
        await tester.pumpAndSettle();
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pumpAndSettle();
      }

      addTearDown(() async {
        await tester.pumpWidget(const SizedBox());
        await settle();
        unawaited(states.close());
        unawaited(refresh.close());
        unawaited(app.close());
      });
      await tester.pumpWidget(view(old));
      await settle();
      expect(calls, ['register:old']);
      await tester.pumpWidget(view(next));
      await settle();
      expect(calls, ['register:old', 'delete:old']);
      current = user('B');
      states.add(current);
      await settle();
      expect(calls, [
        'register:old',
        'delete:old',
        'delete:old',
        'register:new',
      ]);
      expect(tester.takeException(), isNull);
    },
  );
}
