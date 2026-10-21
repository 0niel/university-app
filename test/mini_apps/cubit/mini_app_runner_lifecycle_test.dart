import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_runner_cubit.dart';

class _Repository extends Mock implements MiniAppsRepository {}

void main() {
  const app = MiniApp(id: 'app-1', slug: 'notes', name: 'Notes');
  for (final action in ['rate', 'report', 'consents']) {
    for (final failed in [false, true]) {
      late _Repository repository;
      late Completer<void> response;

      Future<void> update(MiniAppRunnerCubit cubit) async {
        switch (action) {
          case 'rate':
            await cubit.rate(4);
          case 'report':
            await cubit.report(MiniAppReportReason.broken, 'Details');
          case 'consents':
            await cubit.updateConsents(const [MiniAppPermission.camera]);
        }
      }

      blocTest<MiniAppRunnerCubit, MiniAppRunnerState>(
        '$action finishing after close ignores its '
        '${failed ? 'failure' : 'result'}',
        setUp: () {
          repository = _Repository();
          response = Completer<void>();
          when(
            () => repository.rateApp(appId: 'app-1', rating: 4),
          ).thenAnswer((_) => response.future);
          when(
            () => repository.reportApp(
              appId: 'app-1',
              reason: MiniAppReportReason.broken,
              details: 'Details',
            ),
          ).thenAnswer((_) => response.future);
          when(
            () => repository.setConsents(
              appId: 'app-1',
              scopes: const [MiniAppPermission.camera],
            ),
          ).thenAnswer((_) => response.future);
        },
        build: () => MiniAppRunnerCubit(
          miniAppsRepository: repository,
          slug: 'notes',
        ),
        seed: () => const MiniAppRunnerState(
          status: MiniAppRunnerStatus.ready,
          app: app,
          screen: {'type': 'appText', 'data': 'Notes'},
        ),
        act: (cubit) async {
          final pending = update(cubit);
          await cubit.close();
          if (failed) {
            response.completeError(Exception('network'), StackTrace.current);
          } else {
            response.complete();
          }
          await pending;
          await update(cubit);
        },
        expect: () => const <MiniAppRunnerState>[],
        errors: () => const <Object>[],
        verify: (_) {
          switch (action) {
            case 'rate':
              verify(
                () => repository.rateApp(appId: 'app-1', rating: 4),
              ).called(1);
            case 'report':
              verify(
                () => repository.reportApp(
                  appId: 'app-1',
                  reason: MiniAppReportReason.broken,
                  details: 'Details',
                ),
              ).called(1);
            case 'consents':
              verify(
                () => repository.setConsents(
                  appId: 'app-1',
                  scopes: const [MiniAppPermission.camera],
                ),
              ).called(1);
          }
        },
      );
    }
  }
}
