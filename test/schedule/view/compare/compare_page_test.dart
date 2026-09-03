import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations_ru.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/compare/compare_page.dart';
import 'package:rtu_mirea_app/schedule/view/compare/widgets/comparison_day_details.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../gallery/gallery_fonts.dart';
import '../../../helpers/pump_app.dart';

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Repository extends Mock implements ScheduleRepository {}

LessonSchedulePart _lesson(String subject) => LessonSchedulePart(
  subject: subject,
  lessonType: LessonType.practice,
  teachers: const [],
  classrooms: const [],
  lessonBells: LessonBells(
    startTime: const TimeOfDay(hour: 9, minute: 0),
    endTime: const TimeOfDay(hour: 10, minute: 30),
  ),
  dates: [DateTime.now()],
);

void main() {
  setUpAll(loadGalleryFonts);
  final l10n = AppLocalizationsRu();
  late _Schedule schedule;
  late _Repository repository;
  late ScheduleComparisonCubit comparison;

  setUp(() {
    schedule = _Schedule();
    repository = _Repository();
    comparison = ScheduleComparisonCubit();
    when(() => schedule.state).thenReturn(
      ScheduleState(
        selectedSchedule: SelectedGroupSchedule(
          group: const Group(name: 'MY-GROUP'),
          schedule: [_lesson('Мой предмет')],
        ),
      ),
    );
    when(() => repository.searchGroups(query: any(named: 'query'))).thenAnswer(
      (invocation) async => SearchGroupsResponse(
        results: [Group(name: invocation.namedArguments[#query]! as String)],
      ),
    );
  });

  tearDown(() async {
    await schedule.close();
    await comparison.close();
  });

  Widget scene() => RepositoryProvider<ScheduleRepository>.value(
    value: repository,
    child: MultiBlocProvider(
      providers: [
        BlocProvider<ScheduleBloc>.value(value: schedule),
        BlocProvider<ScheduleComparisonCubit>.value(value: comparison),
      ],
      child: const ComparePage(),
    ),
  );

  Future<void> choose(
    WidgetTester tester, {
    required String currentLabel,
    required String name,
  }) async {
    await tester.ensureVisible(find.text(currentLabel).first);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text(currentLabel).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.enterText(find.byType(EditableText), name);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text(name).last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> revealDetails(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.byType(ComparisonDayDetails),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'day-first comparison keeps both subjects and optional week overview',
    (
      tester,
    ) async {
      comparison.start(
        SelectedGroupSchedule(
          group: const Group(name: 'FRIEND-GROUP'),
          schedule: [_lesson('Предмет друга')],
        ),
      );
      await tester.pumpApp(scene(), size: const Size(390, 844));
      await tester.pumpAndSettle();
      expect(find.byType(ScheduleWeekView), findsNothing);
      await revealDetails(tester);
      expect(find.byType(ComparisonDayDetails), findsOneWidget);
      expect(find.text('Мой предмет'), findsOneWidget);
      expect(find.text('Предмет друга'), findsOneWidget);
      await tester.ensureVisible(find.text(l10n.compareWeekView));
      await tester.tap(find.text(l10n.compareWeekView));
      await tester.pumpAndSettle();
      expect(find.byType(ScheduleWeekView), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('new group request wins and loading hides previous details', (
    tester,
  ) async {
    final first = Completer<ScheduleResponse>();
    final second = Completer<ScheduleResponse>();
    when(() => repository.getSchedule(group: 'FIRST')).thenAnswer(
      (_) => first.future,
    );
    when(() => repository.getSchedule(group: 'SECOND')).thenAnswer(
      (_) => second.future,
    );
    await tester.pumpApp(scene(), size: const Size(390, 844));
    await choose(tester, currentLabel: l10n.comparePickGroup, name: 'FIRST');
    expect(find.byType(AppSkeleton), findsWidgets);
    expect(find.byType(ComparisonDayDetails), findsNothing);
    await choose(tester, currentLabel: 'FIRST', name: 'SECOND');
    second.complete(ScheduleResponse(data: [_lesson('Новый предмет')]));
    await tester.pumpAndSettle();
    await revealDetails(tester);
    expect(find.text('Новый предмет'), findsOneWidget);
    first.complete(ScheduleResponse(data: [_lesson('Устаревший предмет')]));
    await tester.pumpAndSettle();
    expect(find.text('Новый предмет'), findsOneWidget);
    expect(find.text('Устаревший предмет'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('error state retries and restores full comparison', (
    tester,
  ) async {
    var attempts = 0;
    when(() => repository.getSchedule(group: 'RETRY')).thenAnswer((_) async {
      if (attempts++ == 0) throw Exception('offline');
      return ScheduleResponse(data: [_lesson('После повтора')]);
    });
    await tester.pumpApp(scene(), size: const Size(390, 844));
    await choose(tester, currentLabel: l10n.comparePickGroup, name: 'RETRY');
    expect(find.byType(AppErrorState), findsOneWidget);
    expect(find.byType(ComparisonDayDetails), findsNothing);
    await tester.tap(find.text(l10n.retry));
    await tester.pumpAndSettle();
    expect(attempts, 2);
    expect(find.byType(ScheduleWeekView), findsNothing);
    await revealDetails(tester);
    expect(find.byType(ComparisonDayDetails), findsOneWidget);
    expect(find.text('После повтора'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
