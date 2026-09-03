import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations_ru.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/schedule_share_sheet.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Activities extends MockCubit<UserActivitiesState>
    implements UserActivitiesCubit {}

class _Preferences extends MockCubit<SchedulePreferencesState>
    implements SchedulePreferencesCubit {}

class _Exporter extends MockCubit<ScheduleExporterState>
    implements ScheduleExporterCubit {}

void main() {
  final l10n = AppLocalizationsRu();
  for (final scale in [1.0, 2.0]) {
    testWidgets('export kit preserves mixed entries at text scale $scale', (
      tester,
    ) async {
      final day = DateTime(2030, 9, 2);
      final schedule = _Schedule();
      final activities = _Activities();
      final preferences = _Preferences();
      final exporter = _Exporter();
      when(() => schedule.state).thenReturn(
        ScheduleState(
          selectedSchedule: SelectedGroupSchedule(
            group: const Group(name: 'GROUP'),
            schedule: [
              scheduleTestLesson(day: day),
              scheduleTestLesson(day: day, subject: 'Hidden'),
              CalendarSchedulePart(title: 'Untimed event', dates: [day]),
            ],
          ),
        ),
      );
      when(() => preferences.state).thenReturn(
        const SchedulePreferencesState(hiddenSubjects: ['Hidden']),
      );
      when(() => activities.state).thenReturn(
        UserActivitiesState(
          activities: [
            UserActivity(
              id: 'mine',
              type: UserActivityType.personal,
              title: 'Personal',
              startsAt: day.add(const Duration(hours: 18)),
            ),
          ],
        ),
      );
      when(() => exporter.state).thenReturn(const ScheduleExporterState());
      await tester.pumpApp(
        RepositoryProvider.value(
          value: UniversityConfig.fromEnvironment(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ScheduleBloc>.value(value: schedule),
              BlocProvider<UserActivitiesCubit>.value(value: activities),
              BlocProvider<SchedulePreferencesCubit>.value(value: preferences),
              BlocProvider<ScheduleExporterCubit>.value(value: exporter),
            ],
            child: Builder(
              builder: (context) => Scaffold(
                body: AppButton.primary(
                  label: 'Open',
                  onPressed: () => showScheduleShareSheet(context, day: day),
                ),
              ),
            ),
          ),
        ),
        size: const Size(320, 844),
        textScaler: TextScaler.linear(scale),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text(l10n.exportEntriesCount(3)), findsOneWidget);
      expect(find.byType(AppRadioRow), findsNWidgets(4));
      await tester.ensureVisible(find.text(l10n.exportSystemCalendar));
      await tester.tap(find.text(l10n.exportSystemCalendar));
      await tester.pumpAndSettle();
      expect(find.text(l10n.exportEntriesCount(2)), findsOneWidget);
      expect(find.text(l10n.exportCalendarIncomplete), findsOneWidget);
      expect(find.text(l10n.exportUnscheduledEventsHint), findsOneWidget);
      final submit = find.byKey(const ValueKey('schedule-export-submit'));
      await tester.ensureVisible(submit);
      expect(tester.widget<AppButton>(submit).onPressed, isNull);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await schedule.close();
      await activities.close();
      await preferences.close();
      await exporter.close();
    });
  }
}
