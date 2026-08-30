import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/schedule_management.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

void main() {
  group('ScheduleManagementPage', () {
    late ScheduleBloc scheduleBloc;

    setUp(() {
      scheduleBloc = MockScheduleBloc();
    });

    Widget buildSubject({double textScale = 1, bool reduceMotion = false}) {
      return MaterialApp(
        theme: NinjaTheme.dark(),
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(320, 700),
            textScaler: TextScaler.linear(textScale),
            accessibleNavigation: reduceMotion,
            disableAnimations: reduceMotion,
          ),
          child: BlocProvider<ScheduleBloc>.value(
            value: scheduleBloc,
            child: const ScheduleManagementPage(),
          ),
        ),
      );
    }

    testWidgets('shows a grouped Ninja skeleton and no spinner on cold load', (
      tester,
    ) async {
      when(() => scheduleBloc.state).thenReturn(
        const ScheduleState(status: ScheduleStatus.loading),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
      'renders the active schedule as the primary card and lists the other '
      'saved schedules, excluding the active one from its section',
      (tester) async {
        const active = Group(name: 'ИКБО-09-22');
        when(() => scheduleBloc.state).thenReturn(
          const ScheduleState(
            status: ScheduleStatus.loaded,
            selectedSchedule: SelectedGroupSchedule(
              group: active,
              schedule: <SchedulePart>[],
            ),
            groupsSchedule: [
              ('ИКБО-09-22', active, <SchedulePart>[]),
              ('ИНБО-04-22', Group(name: 'ИНБО-04-22'), <SchedulePart>[]),
            ],
            teachersSchedule: [
              ('t1', Teacher(name: 'Соколова М. В.'), <SchedulePart>[]),
            ],
          ),
        );

        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        expect(find.byType(PrimaryScheduleCard), findsOneWidget);
        expect(find.text('ИКБО-09-22'), findsOneWidget);
        expect(find.text('ИНБО-04-22'), findsOneWidget);
        expect(find.text('Соколова М. В.'), findsOneWidget);
      },
    );

    testWidgets('the active schedule is the only pastel card on the hub', (
      tester,
    ) async {
      const active = Group(name: 'ИКБО-09-22');
      when(() => scheduleBloc.state).thenReturn(
        const ScheduleState(
          status: ScheduleStatus.loaded,
          selectedSchedule: SelectedGroupSchedule(
            group: active,
            schedule: <SchedulePart>[],
          ),
          groupsSchedule: [
            ('ИКБО-09-22', active, <SchedulePart>[]),
            ('ИНБО-04-22', Group(name: 'ИНБО-04-22'), <SchedulePart>[]),
          ],
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final colors = NinjaColors.dark();
      final pastel = find.byWidgetPredicate((widget) {
        if (widget is! Container) return false;
        final decoration = widget.decoration;
        return decoration is BoxDecoration &&
            decoration.color == colors.accentSoft;
      });
      expect(pastel, findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(PrimaryScheduleCard),
          matching: pastel,
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows the empty state when nothing is saved', (tester) async {
      when(() => scheduleBloc.state).thenReturn(
        const ScheduleState(status: ScheduleStatus.loaded),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(PrimaryScheduleCard), findsNothing);
      expect(find.text('Пока нет расписаний'), findsOneWidget);
    });

    testWidgets('fits loaded content at 320px, 200% text and reduced motion', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 700);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      const active = Group(name: 'ИКБО-09-22');
      when(() => scheduleBloc.state).thenReturn(
        const ScheduleState(
          status: ScheduleStatus.loaded,
          selectedSchedule: SelectedGroupSchedule(
            group: active,
            schedule: <SchedulePart>[],
          ),
          groupsSchedule: [
            ('ИКБО-09-22', active, <SchedulePart>[]),
            (
              'very-long-group',
              Group(name: 'Очень длинное название учебной группы'),
              <SchedulePart>[],
            ),
          ],
        ),
      );

      await tester.pumpWidget(
        buildSubject(textScale: 2, reduceMotion: true),
      );
      await tester.pump();

      expect(find.byType(PrimaryScheduleCard), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
