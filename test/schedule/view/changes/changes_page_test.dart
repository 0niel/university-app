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
import 'package:rtu_mirea_app/schedule/view/changes/changes_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class MockScheduleChangesCubit extends MockCubit<ScheduleChangesState>
    implements ScheduleChangesCubit {}

class MockGamificationRepository extends Mock
    implements GamificationRepository {}

void main() {
  group('ChangesPage loading skeleton', () {
    late ScheduleBloc scheduleBloc;
    late ScheduleChangesCubit changesCubit;
    late GamificationRepository gamificationRepository;

    setUp(() {
      scheduleBloc = MockScheduleBloc();
      changesCubit = MockScheduleChangesCubit();
      gamificationRepository = MockGamificationRepository();

      when(() => scheduleBloc.state).thenReturn(const ScheduleState());
      // Best-effort settings load never resolves; the banner falls back to its
      // default state and the data region keeps showing the skeleton.
      when(
        () => gamificationRepository.getSettings(),
      ).thenAnswer((_) => Completer<UserSettings>().future);
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

      expect(find.byType(NinjaErrorState), findsOneWidget);
      expect(find.byType(NinjaEmptyState), findsNothing);
    });
  });
}
