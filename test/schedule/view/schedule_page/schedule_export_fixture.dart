import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/schedule_share_sheet.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'schedule_test_data.dart';

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Exporter extends MockCubit<ScheduleExporterState>
    implements ScheduleExporterCubit {}

Future<void> pumpExportFixture(
  WidgetTester tester, {
  required bool dark,
  required Size size,
  double textScale = 1,
}) async {
  final day = DateTime(2030, 9, 2);
  final schedule = _Schedule();
  final exporter = _Exporter();
  when(() => schedule.state).thenReturn(
    ScheduleState(
      selectedSchedule: SelectedGroupSchedule(
        group: const Group(name: 'ИКБО-10-23'),
        schedule: [
          for (var index = 0; index < 18; index++)
            scheduleTestLesson(
              day: day.add(Duration(days: index ~/ 3)),
              start: 540 + (index % 3) * 100,
              end: 630 + (index % 3) * 100,
            ),
        ],
      ),
    ),
  );
  when(() => exporter.state).thenReturn(const ScheduleExporterState());
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await schedule.close();
    await exporter.close();
  });
  await tester.pumpWidget(
    RepositoryProvider.value(
      value: UniversityConfig.fromEnvironment(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ScheduleBloc>.value(value: schedule),
          BlocProvider<ScheduleExporterCubit>.value(value: exporter),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScale),
              viewPadding: const EdgeInsets.only(bottom: 34),
              padding: const EdgeInsets.only(bottom: 34),
              disableAnimations: true,
              accessibleNavigation: true,
            ),
            child: child!,
          ),
          home: Builder(
            builder: (context) => Scaffold(
              body: AppButton.primary(
                label: 'Open',
                onPressed: () => showScheduleShareSheet(context, day: day),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}
