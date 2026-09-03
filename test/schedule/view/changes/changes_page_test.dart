import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/changes/changes_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class MockScheduleChangesCubit extends MockCubit<ScheduleChangesState>
    implements ScheduleChangesCubit {}

class MockGamificationRepository extends Mock
    implements GamificationRepository {}

void main() {
  tearDown(ToastManager.debugReset);

  group('ChangesPage loading skeleton', () {
    late ScheduleBloc scheduleBloc;
    late ScheduleChangesCubit changesCubit;
    late GamificationRepository gamificationRepository;

    setUp(() {
      scheduleBloc = MockScheduleBloc();
      changesCubit = MockScheduleChangesCubit();
      gamificationRepository = MockGamificationRepository();

      when(() => scheduleBloc.state).thenReturn(
        const ScheduleState(
          selectedSchedule: SelectedGroupSchedule(
            group: Group(name: 'A'),
            schedule: [],
          ),
        ),
      );
      when(
        () => changesCubit.matchesTarget(ScheduleTargetType.group, 'A'),
      ).thenReturn(true);
      when(
        () => changesCubit.load(
          targetType: ScheduleTargetType.group,
          target: 'A',
        ),
      ).thenAnswer((_) async {});
      when(
        () => gamificationRepository.getSettings(),
      ).thenAnswer((_) async => const UserSettings());
    });

    Widget buildSubject() {
      return MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<GamificationRepository>.value(
              value: gamificationRepository,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ScheduleBloc>.value(value: scheduleBloc),
              BlocProvider<ScheduleChangesCubit>.value(value: changesCubit),
            ],
            child: const ChangesPage(),
          ),
        ),
      );
    }

    testWidgets('shows a shimmering skeleton and no spinner on cold load', (
      tester,
    ) async {
      when(() => changesCubit.state).thenReturn(
        const ScheduleChangesState(status: ScheduleChangesStatus.loading),
      );

      await tester.pumpWidget(buildSubject());
      // Run the post-frame callback that triggers the loads, without settling.
      await tester.pump();

      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('keeps cached rows on refresh reloads (loading + changes)', (
      tester,
    ) async {
      final change = ScheduleChange(
        id: '1',
        kind: ScheduleChangeKind.room,
        subject: 'Системы ИИ',
        lessonDate: DateTime(2026, 5, 22),
        createdAt: DateTime(2026, 5, 22, 9),
      );
      when(() => changesCubit.state).thenReturn(
        ScheduleChangesState(
          status: ScheduleChangesStatus.loading,
          changes: [change],
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Cold-load guard (loading && changes.isEmpty) is false, so the live
      // timeline rows render instead of the skeleton.
      expect(find.byType(NinjaSkeleton), findsNothing);
    });

    testWidgets('shows a retryable error instead of the empty state', (
      tester,
    ) async {
      when(() => changesCubit.state).thenReturn(
        const ScheduleChangesState(status: ScheduleChangesStatus.failure),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(AppErrorState), findsOneWidget);
      expect(find.byType(AppEmptyState), findsNothing);
    });

    testWidgets('does not show changes for a custom or different target', (
      tester,
    ) async {
      when(() => changesCubit.state).thenReturn(
        ScheduleChangesState(
          changes: [
            ScheduleChange(
              id: 'other',
              kind: ScheduleChangeKind.cancel,
              subject: 'Другой предмет',
              lessonDate: DateTime(2026, 9, 2),
              createdAt: DateTime(2026, 9, 2),
            ),
          ],
        ),
      );
      when(
        () => changesCubit.matchesTarget(ScheduleTargetType.group, 'A'),
      ).thenReturn(false);
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.textContaining('Другой предмет'), findsNothing);
      expect(find.byType(AppEmptyState), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      when(() => scheduleBloc.state).thenReturn(
        const ScheduleState(
          selectedSchedule: SelectedCustomSchedule(
            id: 'own',
            name: 'Свои пары',
            schedule: [],
          ),
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.textContaining('Другой предмет'), findsNothing);
      verify(changesCubit.clear).called(1);
    });

    testWidgets('unknown alert settings never render an enabled toggle', (
      tester,
    ) async {
      when(() => changesCubit.state).thenReturn(const ScheduleChangesState());
      when(
        () => gamificationRepository.getSettings(),
      ).thenAnswer((_) => Completer<UserSettings>().future);
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.byType(AppSwitch), findsNothing);
      expect(find.byType(AppSkeletonRow), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
      'alert setting disables duplicate writes and restores failed value',
      (tester) async {
        final pending = Completer<UserSettings>();
        when(() => changesCubit.state).thenReturn(const ScheduleChangesState());
        when(
          () => gamificationRepository.updateSettings(
            const UserSettings(scheduleChangeAlerts: false),
          ),
        ).thenAnswer((_) => pending.future);
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();
        tester.widget<AppSwitch>(find.byType(AppSwitch)).onChanged!(false);
        await tester.pump();
        final disabled = tester.widget<AppSwitch>(find.byType(AppSwitch));
        expect(disabled.value, isFalse);
        expect(disabled.onChanged, isNull);
        pending.completeError(Exception('offline'));
        await tester.pumpAndSettle();
        expect(tester.widget<AppSwitch>(find.byType(AppSwitch)).value, isTrue);
        await tester.pump(const Duration(seconds: 5));
        verify(
          () => gamificationRepository.updateSettings(
            const UserSettings(scheduleChangeAlerts: false),
          ),
        ).called(1);
      },
    );
  });
}
