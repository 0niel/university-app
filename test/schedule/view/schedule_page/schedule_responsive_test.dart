import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';

class _MockScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _MockSchedulePreferencesCubit extends MockCubit<SchedulePreferencesState>
    implements SchedulePreferencesCubit {}

class _MockUserActivitiesCubit extends MockCubit<UserActivitiesState>
    implements UserActivitiesCubit {}

class _MockScheduleChangesCubit extends MockCubit<ScheduleChangesState>
    implements ScheduleChangesCubit {}

class _MockClassmatesCubit extends MockCubit<ClassmatesState>
    implements ClassmatesCubit {}

class _MockLessonCommentsCubit extends MockCubit<LessonCommentsState>
    implements LessonCommentsCubit {}

class _MockLessonReactionsCubit extends MockCubit<LessonReactionsState>
    implements LessonReactionsCubit {}

void main() {
  late _MockScheduleBloc scheduleBloc;
  late _MockSchedulePreferencesCubit preferencesCubit;
  late _MockUserActivitiesCubit activitiesCubit;
  late _MockScheduleChangesCubit changesCubit;
  late _MockClassmatesCubit classmatesCubit;
  late _MockLessonCommentsCubit commentsCubit;
  late _MockLessonReactionsCubit reactionsCubit;

  setUp(() {
    final now = DateTime.now();
    final lesson = LessonSchedulePart(
      subject: 'Проектирование распределённых информационных систем',
      lessonType: LessonType.laboratoryWork,
      teachers: const [Teacher(name: 'Иванов Иван Иванович')],
      classrooms: const [Classroom(name: 'А-123')],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 12, minute: 0),
        endTime: const TimeOfDay(hour: 12, minute: 30),
      ),
      dates: [DateTime(now.year, now.month, now.day)],
    );
    final scheduleState = ScheduleState(
      status: ScheduleStatus.loaded,
      selectedSchedule: SelectedGroupSchedule(
        group: const Group(name: 'ИКБО-01-25'),
        schedule: [lesson],
      ),
    );

    scheduleBloc = _MockScheduleBloc();
    preferencesCubit = _MockSchedulePreferencesCubit();
    activitiesCubit = _MockUserActivitiesCubit();
    changesCubit = _MockScheduleChangesCubit();
    classmatesCubit = _MockClassmatesCubit();
    commentsCubit = _MockLessonCommentsCubit();
    reactionsCubit = _MockLessonReactionsCubit();

    whenListen(
      scheduleBloc,
      const Stream<ScheduleState>.empty(),
      initialState: scheduleState,
    );
    whenListen(
      preferencesCubit,
      const Stream<SchedulePreferencesState>.empty(),
      initialState: const SchedulePreferencesState(collapsePast: false),
    );
    whenListen(
      activitiesCubit,
      const Stream<UserActivitiesState>.empty(),
      initialState: const UserActivitiesState(),
    );
    whenListen(
      changesCubit,
      const Stream<ScheduleChangesState>.empty(),
      initialState: const ScheduleChangesState(),
    );
    whenListen(
      classmatesCubit,
      const Stream<ClassmatesState>.empty(),
      initialState: const ClassmatesState(),
    );
    whenListen(
      commentsCubit,
      const Stream<LessonCommentsState>.empty(),
      initialState: const LessonCommentsState(),
    );
    whenListen(
      reactionsCubit,
      const Stream<LessonReactionsState>.empty(),
      initialState: const LessonReactionsState(),
    );
    when(
      () => activitiesCubit.load(
        from: any(named: 'from'),
        to: any(named: 'to'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => changesCubit.load(
        targetType: ScheduleTargetType.group,
        target: any(named: 'target'),
      ),
    ).thenAnswer((_) async {});
    when(() => classmatesCubit.load(any())).thenAnswer((_) async {});
  });

  Widget subject() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScheduleBloc>.value(value: scheduleBloc),
        BlocProvider<SchedulePreferencesCubit>.value(value: preferencesCubit),
        BlocProvider<UserActivitiesCubit>.value(value: activitiesCubit),
        BlocProvider<ScheduleChangesCubit>.value(value: changesCubit),
        BlocProvider<ClassmatesCubit>.value(value: classmatesCubit),
        BlocProvider<LessonCommentsCubit>.value(value: commentsCubit),
        BlocProvider<LessonReactionsCubit>.value(value: reactionsCubit),
      ],
      child: const SchedulePage(),
    );
  }

  testWidgets('calendar controls keep 44px targets at 320px and 200% text', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pump();

    final dayControls = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.button == true &&
          widget.properties.selected != null &&
          widget.properties.label != null,
    );
    expect(dayControls, findsNWidgets(7));
    for (final element in dayControls.evaluate()) {
      final size = tester.getSize(find.byWidget(element.widget));
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
    }

    final viewControls = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.button == true &&
          widget.properties.selected != null &&
          widget.properties.label == null,
    );
    expect(viewControls, findsNWidgets(3));
    for (final element in viewControls.evaluate()) {
      final size = tester.getSize(find.byWidget(element.widget));
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('schedule actions stay readable at 320px and 200% text', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpApp(
      subject(),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pump();

    await tester.tap(find.byTooltip('Ещё'));
    await tester.pumpAndSettle();

    expect(find.text('Управление расписанием'), findsOneWidget);
    expect(find.text('ИКБО-01-25'), findsWidgets);
    expect(find.text('ВАЖНОЕ'), findsOneWidget);
    expect(find.text('ИНСТРУМЕНТЫ'), findsOneWidget);
    expect(find.text('НАСТРОЙКА И ОБМЕН'), findsOneWidget);

    final allSchedules = find.byKey(
      const ValueKey('schedule-actions-all'),
    );
    final customSchedules = find.byKey(
      const ValueKey('schedule-actions-custom'),
    );
    expect(
      tester.getTopLeft(customSchedules).dy,
      greaterThan(tester.getBottomLeft(allSchedules).dy),
    );

    final changesSubtitle = tester.widget<Text>(
      find.text('Переносы, отмены и замены в расписании'),
    );
    expect(changesSubtitle.maxLines, isNull);
    expect(changesSubtitle.overflow, isNull);

    await tester.ensureVisible(find.text('НАСТРОЙКА И ОБМЕН'));
    await tester.pumpAndSettle();
    expect(find.text('Что показывать в расписании'), findsOneWidget);
    await tester.ensureVisible(find.text('Что показывать в расписании'));
    await tester.pumpAndSettle();

    const filtersLabel = 'Фильтры. Что показывать в расписании';
    expect(
      tester.getSemantics(find.bySemanticsLabel(filtersLabel)),
      matchesSemantics(
        label: filtersLabel,
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    tester.semantics.tap(find.semantics.byLabel(filtersLabel));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('ТИПЫ ПАР'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('day and month views stay overflow-free at 200% text', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pump();

    await tester.tap(find.text('День'));
    await tester.pumpAndSettle();
    final dayControl = tester.widget<Semantics>(
      find
          .ancestor(of: find.text('День'), matching: find.byType(Semantics))
          .first,
    );
    expect(dayControl.properties.selected, isTrue);
    expect(
      find.text('Проектирование распределённых информационных систем'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.text('Неделя'));
    await tester.tap(find.text('Неделя'));
    await tester.pumpAndSettle();
    final weekControl = tester.widget<Semantics>(
      find
          .ancestor(of: find.text('Неделя'), matching: find.byType(Semantics))
          .first,
    );
    expect(weekControl.properties.selected, isTrue);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.text('Месяц'));
    await tester.tap(find.text('Месяц'));
    await tester.pumpAndSettle();
    final monthControl = tester.widget<Semantics>(
      find
          .ancestor(of: find.text('Месяц'), matching: find.byType(Semantics))
          .first,
    );
    expect(monthControl.properties.selected, isTrue);
    final monthControls = find.descendant(
      of: find.byType(GridView),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.button == true &&
            widget.properties.label?.contains('${DateTime.now().year}') == true,
      ),
    );
    expect(monthControls, findsWidgets);
    for (final element in monthControls.evaluate()) {
      final size = tester.getSize(find.byWidget(element.widget));
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
    }
    final now = DateTime.now();
    final keySuffix = '${now.year}-${now.month}-${now.day}';
    final dayNumber = find.byKey(ValueKey('month-day-number-$keySuffix'));
    final dayLoad = find.byKey(ValueKey('month-day-load-$keySuffix'));
    expect(dayNumber, findsOneWidget);
    expect(dayLoad, findsOneWidget);
    expect(
      tester.getRect(dayNumber).bottom,
      lessThanOrEqualTo(tester.getRect(dayLoad).top),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('day calendar expands into the month while selector glides', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pumpAndSettle();

    final indicator = find.byKey(
      const ValueKey('schedule-view-indicator'),
    );
    final startX = tester.getCenter(indicator).dx;
    final selectedAgendaDate = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.selected == true &&
          widget.properties.label != null,
    );
    final agendaCenter = tester.getCenter(selectedAgendaDate);
    final now = DateTime.now();
    final dayKey = now.year * 10000 + now.month * 100 + now.day;

    await tester.tap(find.text('Месяц'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 130));
    await tester.pump(const Duration(milliseconds: 130));

    final middleX = tester.getCenter(indicator).dx;
    expect(middleX, greaterThan(startX));
    expect(
      find.byKey(const ValueKey('schedule-view-transition')),
      findsOneWidget,
    );
    final morphDay = find.byKey(
      ValueKey('calendar-morph-day-$dayKey'),
    );
    expect(morphDay, findsOneWidget);
    final expandingCenter = tester.getCenter(morphDay);
    final monthLayer = find.byKey(
      const ValueKey('schedule-view-layer-month'),
    );
    final transitioningSelectedDate = find.descendant(
      of: monthLayer,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.selected == true &&
            widget.properties.label?.contains('${DateTime.now().year}') == true,
      ),
    );
    final monthElementBeforeSettle = transitioningSelectedDate
        .evaluate()
        .single;
    final excludedOutgoingView = find.ancestor(
      of: find.byType(PageView).first,
      matching: find.byWidgetPredicate(
        (widget) => widget is ExcludeSemantics && widget.excluding,
      ),
    );
    expect(excludedOutgoingView, findsOneWidget);

    await tester.pumpAndSettle();

    final endX = tester.getCenter(indicator).dx;
    expect(endX, greaterThan(middleX));
    expect(find.byType(GridView), findsOneWidget);
    expect(
      find.byKey(const ValueKey('schedule-month-pager')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('schedule-day-pager')), findsNothing);
    expect(find.byKey(const ValueKey('schedule-week-pager')), findsNothing);

    final selectedDate = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.selected == true &&
          widget.properties.label?.contains('${DateTime.now().year}') == true,
    );
    expect(selectedDate, findsOneWidget);
    expect(selectedDate.evaluate().single, same(monthElementBeforeSettle));
    final monthCenter = tester.getCenter(selectedDate);
    expect(
      expandingCenter.dy,
      inInclusiveRange(
        math.min(agendaCenter.dy, monthCenter.dy) + 1,
        math.max(agendaCenter.dy, monthCenter.dy) - 1,
      ),
    );

    await tester.tap(find.text('День'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 130));
    await tester.pump(const Duration(milliseconds: 130));

    expect(morphDay, findsOneWidget);
    final collapsingCenter = tester.getCenter(morphDay);
    final agendaLayer = find.byKey(
      const ValueKey('schedule-view-layer-agenda'),
    );
    final transitioningSelectedAgendaDate = find.descendant(
      of: agendaLayer,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.selected == true &&
            widget.properties.label != null,
      ),
    );
    final agendaElementBeforeSettle = transitioningSelectedAgendaDate
        .evaluate()
        .single;
    expect(
      collapsingCenter.dy,
      inInclusiveRange(
        math.min(agendaCenter.dy, monthCenter.dy) + 1,
        math.max(agendaCenter.dy, monthCenter.dy) - 1,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsNothing);
    expect(find.byType(PageView), findsNWidgets(2));
    final settledSelectedAgendaDate = find.descendant(
      of: find.byKey(const ValueKey('schedule-view-layer-agenda')),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.selected == true &&
            widget.properties.label != null,
      ),
    );
    expect(
      settledSelectedAgendaDate.evaluate().single,
      same(agendaElementBeforeSettle),
    );
    expect(tester.getCenter(indicator).dx, closeTo(startX, 0.01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('calendar morph stays stable at 320px and 200 percent text', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pumpAndSettle();

    final now = DateTime.now();
    final dayKey = now.year * 10000 + now.month * 100 + now.day;
    final morphDay = find.byKey(ValueKey('calendar-morph-day-$dayKey'));

    await tester.tap(find.text('Месяц'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 130));
    await tester.pump(const Duration(milliseconds: 130));

    expect(morphDay, findsOneWidget);
    expect(tester.getRect(morphDay).left, greaterThanOrEqualTo(0));
    expect(tester.getRect(morphDay).right, lessThanOrEqualTo(320));
    expect(tester.takeException(), isNull);

    await tester.pumpAndSettle();
    await tester.tap(find.text('День'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 130));
    await tester.pump(const Duration(milliseconds: 130));

    expect(morphDay, findsOneWidget);
    expect(tester.getRect(morphDay).left, greaterThanOrEqualTo(0));
    expect(tester.getRect(morphDay).right, lessThanOrEqualTo(320));
    final reverseException = tester.takeException();
    expect(
      reverseException,
      isNull,
      reason: reverseException is FlutterError
          ? reverseException.toStringDeep()
          : reverseException.toString(),
    );

    await tester.pumpAndSettle();
    expect(find.byType(PageView), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('closing morph keeps pagers mounted on the selected day', (
    tester,
  ) async {
    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pumpAndSettle();

    await tester.fling(
      find.byType(PageView).last,
      const Offset(-320, 0),
      1200,
    );
    await tester.pumpAndSettle();
    final selectedLabel = tester
        .widget<Semantics>(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.selected == true &&
                widget.properties.label != null,
          ),
        )
        .properties
        .label;

    await tester.tap(find.text('Месяц'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('День'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 130));
    await tester.pump(const Duration(milliseconds: 130));

    final pagersBeforeSettle = find
        .descendant(
          of: find.byKey(const ValueKey('schedule-view-layer-agenda')),
          matching: find.byType(PageView),
        )
        .evaluate()
        .toList();
    final pagesBeforeSettle = pagersBeforeSettle
        .map((element) => (element.widget as PageView).controller!.page)
        .toList();
    expect(pagersBeforeSettle, hasLength(2));

    await tester.pumpAndSettle();

    final pagersAfterSettle = find
        .descendant(
          of: find.byKey(const ValueKey('schedule-view-layer-agenda')),
          matching: find.byType(PageView),
        )
        .evaluate()
        .toList();
    final pagesAfterSettle = pagersAfterSettle
        .map((element) => (element.widget as PageView).controller!.page)
        .toList();
    expect(pagersAfterSettle, hasLength(2));
    expect(pagersAfterSettle[0], same(pagersBeforeSettle[0]));
    expect(pagersAfterSettle[1], same(pagersBeforeSettle[1]));
    expect(pagesAfterSettle, pagesBeforeSettle);
    expect(
      tester
          .widget<Semantics>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.selected == true &&
                  widget.properties.label != null,
            ),
          )
          .properties
          .label,
      selectedLabel,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('accessible navigation changes calendar view immediately', (
    tester,
  ) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: false,
            accessibleNavigation: true,
          ),
          child: subject(),
        ),
      ),
      size: const Size(390, 844),
    );
    await tester.pump();

    await tester.tap(find.text('Месяц'));
    await tester.pump();

    expect(find.byType(GridView), findsOneWidget);
    expect(
      find.byKey(const ValueKey('schedule-month-pager')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('schedule-day-pager')), findsNothing);
    expect(find.byKey(const ValueKey('schedule-week-pager')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rapid view reversal keeps only the latest layer interactive', (
    tester,
  ) async {
    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Месяц'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('День'));
    await tester.pump(const Duration(milliseconds: 100));

    final activeLayers = find.descendant(
      of: find.byKey(const ValueKey('schedule-view-transition')),
      matching: find.byWidgetPredicate(
        (widget) => widget is ExcludeSemantics && !widget.excluding,
      ),
    );
    expect(activeLayers, findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsNothing);
    expect(find.byType(PageView), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('focus and agenda share one sliver stream at 200 percent', (
    tester,
  ) async {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    LessonSchedulePart lesson(String subject, int endMinute) {
      return LessonSchedulePart(
        subject: subject,
        lessonType: LessonType.lecture,
        teachers: const [Teacher(name: 'Иванов Иван Иванович')],
        classrooms: const [Classroom(name: 'А-123')],
        lessonBells: LessonBells(
          startTime: const TimeOfDay(hour: 0, minute: 0),
          endTime: TimeOfDay(hour: 23, minute: endMinute),
        ),
        dates: [day],
      );
    }

    whenListen(
      scheduleBloc,
      const Stream<ScheduleState>.empty(),
      initialState: ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: SelectedGroupSchedule(
          group: const Group(name: 'ИКБО-01-25'),
          schedule: [
            lesson('Проектирование распределённых систем', 59),
            lesson('Инженерия пользовательского опыта', 58),
          ],
        ),
      ),
    );

    await tester.pumpApp(
      subject(),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pump();

    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byType(PageView), findsNWidgets(2));
    expect(find.text('ИКБО-01-25'), findsOneWidget);
    expect(find.text('Проектирование распределённых систем'), findsOneWidget);
    expect(find.byTooltip('Поиск'), findsOneWidget);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -420));
    await tester.pumpAndSettle();
    expect(find.text('Инженерия пользовательского опыта'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mixed week stays overflow-free at 320px and 200% text', (
    tester,
  ) async {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final activity = UserActivity(
      id: 'week-activity',
      type: UserActivityType.consult,
      title: 'Расширенная консультация по командному проекту',
      startsAt: day.add(const Duration(hours: 14)),
      endsAt: day.add(const Duration(hours: 15)),
    );
    whenListen(
      activitiesCubit,
      const Stream<UserActivitiesState>.empty(),
      initialState: UserActivitiesState(
        status: UserActivitiesStatus.populated,
        activities: [activity],
      ),
    );

    await tester.pumpApp(
      subject(),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pump();
    await tester.ensureVisible(find.text('Неделя'));
    await tester.tap(find.text('Неделя'));
    await tester.pumpAndSettle();

    expect(
      find.text('Проектирование распределённых информационных систем'),
      findsOneWidget,
    );
    expect(
      find.text('Расширенная консультация по командному проекту'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('empty week status is centered inside the day body', (
    tester,
  ) async {
    final now = DateUtils.dateOnly(DateTime.now());
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final emptyDay = List.generate(
      7,
      (index) => monday.add(Duration(days: index)),
    ).firstWhere((day) => !DateUtils.isSameDay(day, now));
    final dayKey = emptyDay.year * 10000 + emptyDay.month * 100 + emptyDay.day;

    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pump();
    await tester.tap(find.text('Неделя'));
    await tester.pumpAndSettle();

    final card = find.byKey(ValueKey('schedule-week-day-card-$dayKey'));
    final empty = find.byKey(ValueKey('schedule-week-empty-$dayKey'));
    expect(card, findsOneWidget);
    expect(empty, findsOneWidget);
    expect(
      tester.getCenter(empty).dx,
      closeTo(tester.getCenter(card).dx, .5),
    );
    expect(tester.getCenter(empty).dy, greaterThan(tester.getCenter(card).dy));
    expect(tester.takeException(), isNull);
  });

  testWidgets('holding a compact week class expands its details', (
    tester,
  ) async {
    final now = DateUtils.dateOnly(DateTime.now());
    final dayKey = now.year * 10000 + now.month * 100 + now.day;
    const subjectName = 'Проектирование распределённых информационных систем';
    final chip = find.byKey(
      ValueKey('schedule-week-lesson-$dayKey-$subjectName'),
    );
    final details = find.byKey(
      ValueKey('schedule-week-lesson-details-$dayKey-$subjectName'),
    );

    await tester.pumpApp(
      subject(),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pump();
    await tester.tap(find.text('Неделя'));
    await tester.pumpAndSettle();

    expect(chip, findsOneWidget);
    await tester.ensureVisible(chip);
    await tester.pumpAndSettle();
    expect(details, findsNothing);
    final collapsedHeight = tester.getSize(chip).height;
    expect(collapsedHeight, greaterThanOrEqualTo(NinjaMetrics.minTouchTarget));

    await tester.longPress(chip);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(details, findsOneWidget);
    expect(tester.getSize(chip).height, greaterThan(collapsedHeight));
    expect(find.textContaining('Иванов Иван Иванович'), findsOneWidget);
    final semantics = tester.widget<Semantics>(
      find.ancestor(of: chip, matching: find.byType(Semantics)).first,
    );
    expect(semantics.properties.toggled, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('weekends stay explicit in day week and month calendars', (
    tester,
  ) async {
    final now = DateUtils.dateOnly(DateTime.now());
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final saturday = monday.add(const Duration(days: 5));
    final saturdayKey =
        saturday.year * 10000 + saturday.month * 100 + saturday.day;

    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pump();

    final weekendDayControl = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.selected != null &&
          widget.properties.label?.contains('Выходной') == true,
    );
    expect(weekendDayControl, findsNWidgets(2));

    await tester.tap(find.text('Неделя'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(ValueKey('schedule-week-day-off-$saturdayKey')),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('Месяц'));
    await tester.tap(find.text('Месяц'));
    await tester.pumpAndSettle();

    final monthWeekend = find.descendant(
      of: find.byType(GridView),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label?.contains('Выходной') == true,
      ),
    );
    expect(monthWeekend, findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('lesson actions use responsive facts without divider rows', (
    tester,
  ) async {
    final day = DateTime.now();
    final lesson = LessonSchedulePart(
      subject: 'Проектирование информационных систем',
      lessonType: LessonType.lecture,
      teachers: const [Teacher(name: 'Иванов Иван Иванович')],
      classrooms: const [Classroom(name: 'А-123')],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 10, minute: 40),
        endTime: const TimeOfDay(hour: 12, minute: 10),
      ),
      dates: [day],
    );
    await tester.pumpApp(
      Builder(
        builder: (context) => NinjaButton.primary(
          label: 'Открыть',
          onPressed: () => showClassActionsSheet(
            context,
            lesson: lesson,
            day: day,
          ),
        ),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );

    await tester.tap(find.text('Открыть'));
    await tester.pumpAndSettle();

    expect(find.byType(AppSmartChip), findsNWidgets(2));
    expect(find.byType(Divider), findsNothing);
    expect(find.byType(VerticalDivider), findsNothing);
    final exception = tester.takeException();
    expect(
      exception,
      isNull,
      reason: exception is FlutterError
          ? exception.toStringDeep()
          : exception.toString(),
    );
  });

  testWidgets('compact day rail selects an adjacent day', (tester) async {
    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pump();

    Finder selectedDay() => find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.button == true &&
          widget.properties.selected == true &&
          widget.properties.label != null,
    );

    expect(find.byType(PageView), findsNWidgets(2));
    final before = tester.widget<Semantics>(selectedDay()).properties.label;

    final adjacentDay = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.button == true &&
          widget.properties.selected == false &&
          widget.properties.label != null,
    );
    await tester.tap(adjacentDay.first);
    await tester.pumpAndSettle();

    final after = tester.widget<Semantics>(selectedDay()).properties.label;
    expect(after, isNot(equals(before)));
    expect(tester.takeException(), isNull);
  });

  testWidgets('swiping the day pager walks the days and follows the strip', (
    tester,
  ) async {
    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pumpAndSettle();

    Finder selectedDay() => find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.button == true &&
          widget.properties.selected == true &&
          widget.properties.label != null,
    );

    String labelFor(DateTime day) =>
        DateFormat('EEEE, d MMMM', 'ru').format(day);

    final tomorrow = DateUtils.dateOnly(
      DateTime.now(),
    ).add(const Duration(days: 1));
    final strip = find.byType(PageView).first;
    final pager = find.byType(PageView).last;

    final before = tester.widget<Semantics>(selectedDay()).properties.label;
    await tester.fling(pager, const Offset(-320, 0), 1200);
    await tester.pumpAndSettle();

    final after = tester.widget<Semantics>(selectedDay()).properties.label;
    expect(after, isNot(equals(before)));
    expect(after, labelFor(tomorrow));

    await tester.fling(strip, const Offset(-320, 0), 1200);
    await tester.pumpAndSettle();

    expect(
      tester.widget<Semantics>(selectedDay()).properties.label,
      labelFor(tomorrow.add(const Duration(days: 7))),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('today floats at the lower right after leaving today', (
    tester,
  ) async {
    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('schedule-today-button')),
      findsNothing,
    );

    await tester.fling(
      find.byKey(const ValueKey('schedule-day-pager')),
      const Offset(-320, 0),
      1200,
    );
    await tester.pumpAndSettle();

    final today = find.byKey(const ValueKey('schedule-today-button'));
    expect(today, findsOneWidget);
    final rect = tester.getRect(today);
    expect(rect.center.dx, greaterThan(195));
    expect(rect.center.dy, greaterThan(560));

    await tester.tap(today);
    await tester.pumpAndSettle();

    expect(today, findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('month is a snapping pager and returns through today', (
    tester,
  ) async {
    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Месяц'));
    await tester.pumpAndSettle();

    final pager = find.byKey(const ValueKey('schedule-month-pager'));
    final before = tester.widget<PageView>(pager).controller!.page;

    await tester.tap(find.byTooltip('Следующий месяц'));
    await tester.pumpAndSettle();

    expect(tester.widget<PageView>(pager).controller!.page, before! + 1);
    expect(
      find.byKey(const ValueKey('schedule-today-button')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('schedule-today-button')));
    await tester.pumpAndSettle();

    expect(tester.widget<PageView>(pager).controller!.page, before);

    await tester.fling(pager, const Offset(-320, 0), 1200);
    await tester.pumpAndSettle();

    final after = tester.widget<PageView>(pager).controller!.page;
    expect(after, before + 1);
    expect(
      find.byKey(const ValueKey('schedule-today-button')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('schedule-today-button')));
    await tester.pumpAndSettle();

    expect(tester.widget<PageView>(pager).controller!.page, before);
    expect(
      find.byKey(const ValueKey('schedule-today-button')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('month controls retarget an in-flight page animation', (
    tester,
  ) async {
    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Месяц'));
    await tester.pumpAndSettle();

    final pager = find.byKey(const ValueKey('schedule-month-pager'));
    final initial = tester.widget<PageView>(pager).controller!.page;

    await tester.tap(find.byTooltip('Следующий месяц'));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.tap(find.byKey(const ValueKey('schedule-today-button')));
    await tester.pumpAndSettle();

    expect(tester.widget<PageView>(pager).controller!.page, initial);
    expect(
      find.byKey(const ValueKey('schedule-today-button')),
      findsNothing,
    );

    await tester.tap(find.byTooltip('Следующий месяц'));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.tap(find.byTooltip('Предыдущий месяц'));
    await tester.pumpAndSettle();

    expect(tester.widget<PageView>(pager).controller!.page, initial);
    expect(
      find.byKey(const ValueKey('schedule-today-button')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('day calendar stays pinned while the selector scrolls away', (
    tester,
  ) async {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final lessons = [
      for (var index = 0; index < 7; index++)
        LessonSchedulePart(
          subject: 'Предмет $index',
          lessonType: LessonType.lecture,
          teachers: const [],
          classrooms: const [],
          lessonBells: LessonBells(
            startTime: TimeOfDay(hour: 8 + index, minute: 0),
            endTime: TimeOfDay(hour: 8 + index, minute: 40),
          ),
          dates: [day],
        ),
    ];
    final activity = UserActivity(
      id: 'day-dot',
      type: UserActivityType.consult,
      title: 'Консультация',
      startsAt: day.add(const Duration(hours: 18)),
      endsAt: day.add(const Duration(hours: 19)),
    );
    whenListen(
      scheduleBloc,
      const Stream<ScheduleState>.empty(),
      initialState: ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: SelectedGroupSchedule(
          group: const Group(name: 'ИКБО-01-25'),
          schedule: lessons,
        ),
      ),
    );
    whenListen(
      activitiesCubit,
      const Stream<UserActivitiesState>.empty(),
      initialState: UserActivitiesState(
        status: UserActivitiesStatus.populated,
        activities: [activity],
      ),
    );

    await tester.pumpApp(subject(), size: const Size(390, 568));
    await tester.pumpAndSettle();

    final load = find.byKey(
      ValueKey(
        'schedule-day-load-${day.year * 10000 + day.month * 100 + day.day}',
      ),
    );
    expect(load, findsOneWidget);
    expect(
      find.descendant(of: load, matching: find.text('+2')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: load,
        matching: find.byKey(
          const ValueKey('schedule-day-activity-dot'),
        ),
      ),
      findsOneWidget,
    );

    final scroll = find.byType(CustomScrollView).hitTestable().first;
    await tester.drag(scroll, const Offset(0, -260));
    await tester.pumpAndSettle();

    final selector = find.byKey(
      const ValueKey('schedule-collapsing-view-selector'),
    );
    final calendar = find.byKey(
      const ValueKey('schedule-sticky-day-calendar'),
    );
    expect(tester.getSize(selector).height, closeTo(0, .1));
    final pinnedTop = tester.getTopLeft(calendar).dy;

    await tester.drag(scroll, const Offset(0, -180));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(calendar).dy, closeTo(pinnedTop, .1));
    expect(find.textContaining('числитель'), findsNothing);
    expect(find.textContaining('знаменатель'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('month calendar stays pinned while its grid scrolls', (
    tester,
  ) async {
    await tester.pumpApp(subject(), size: const Size(390, 480));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Месяц'));
    await tester.pumpAndSettle();

    final calendar = find.byKey(
      const ValueKey('schedule-sticky-month-calendar'),
    );
    final top = tester.getTopLeft(calendar).dy;
    final scroll = find.byType(CustomScrollView).hitTestable().first;
    await tester.drag(scroll, const Offset(0, -220));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(calendar).dy, lessThan(top));
    final pinnedTop = tester.getTopLeft(calendar).dy;
    await tester.drag(scroll, const Offset(0, -120));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(calendar).dy, closeTo(pinnedTop, .1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('activity-only day keeps its timeline and live marker', (
    tester,
  ) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final activity = UserActivity(
      id: 'live-activity',
      type: UserActivityType.consult,
      title: 'Консультация по проекту',
      startsAt: start,
      endsAt: start.add(const Duration(days: 1, hours: 1)),
    );
    whenListen(
      scheduleBloc,
      const Stream<ScheduleState>.empty(),
      initialState: const ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: SelectedGroupSchedule(
          group: Group(name: 'ИКБО-01-25'),
          schedule: [],
        ),
      ),
    );
    whenListen(
      activitiesCubit,
      const Stream<UserActivitiesState>.empty(),
      initialState: UserActivitiesState(
        status: UserActivitiesStatus.populated,
        activities: [activity],
      ),
    );

    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pump();

    expect(find.text('Консультация по проекту'), findsOneWidget);
    expect(find.textContaining('СЕЙЧАС'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.liveRegion == true &&
            widget.properties.label?.contains('СЕЙЧАС') == true,
      ),
      findsOneWidget,
    );
    expect(find.text('Сейчас'), findsOneWidget);
    expect(find.byTooltip('Добавить активность'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final dayKey = start.year * 10000 + start.month * 100 + start.day;
    await tester.tap(find.text('Месяц'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 130));
    await tester.pump(const Duration(milliseconds: 130));

    expect(
      find.byKey(ValueKey('calendar-morph-activity-dots-$dayKey')),
      findsOneWidget,
    );
    expect(
      find.byKey(ValueKey('calendar-morph-lesson-bars-$dayKey')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);

    await tester.pumpAndSettle();
    final selectedDate = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.selected == true &&
          widget.properties.label?.contains('${start.year}') == true,
    );
    await tester.tap(selectedDate);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Неделя'));
    await tester.pumpAndSettle();
    expect(find.text('Консультация по проекту'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('live lesson and now shortcut share no duplicate key', (
    tester,
  ) async {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final liveLesson = LessonSchedulePart(
      subject: 'Текущая пара',
      lessonType: LessonType.lecture,
      teachers: const [],
      classrooms: const [],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 0, minute: 0),
        endTime: const TimeOfDay(hour: 23, minute: 59),
      ),
      dates: [day],
    );
    whenListen(
      scheduleBloc,
      const Stream<ScheduleState>.empty(),
      initialState: ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: SelectedGroupSchedule(
          group: const Group(name: 'ИКБО-01-25'),
          schedule: [liveLesson],
        ),
      ),
    );

    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pumpAndSettle();

    expect(find.text('Текущая пара'), findsOneWidget);
    expect(find.textContaining('СЕЙЧАС'), findsOneWidget);
    await tester.tap(find.text('Сейчас'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('the lesson card uses a subject rail without a type icon', (
    tester,
  ) async {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final liveLesson = LessonSchedulePart(
      subject: 'Текущая пара',
      lessonType: LessonType.lecture,
      teachers: const [],
      classrooms: const [],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 0, minute: 0),
        endTime: const TimeOfDay(hour: 23, minute: 59),
      ),
      dates: [day],
    );
    whenListen(
      scheduleBloc,
      const Stream<ScheduleState>.empty(),
      initialState: ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: SelectedGroupSchedule(
          group: const Group(name: 'ИКБО-01-25'),
          schedule: [liveLesson],
        ),
      ),
    );

    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pumpAndSettle();

    final card = find.byWidgetPredicate(
      (widget) =>
          widget.key is ValueKey<String> &&
          (widget.key! as ValueKey<String>).value.startsWith(
            'schedule-lesson-card-',
          ),
    );
    final accent = find.byWidgetPredicate(
      (widget) =>
          widget.key is ValueKey<String> &&
          (widget.key! as ValueKey<String>).value.startsWith(
            'schedule-lesson-accent-',
          ),
    );
    final type = find.byWidgetPredicate(
      (widget) =>
          widget.key is ValueKey<String> &&
          (widget.key! as ValueKey<String>).value.startsWith(
            'schedule-lesson-type-',
          ),
    );
    expect(card, findsOneWidget);
    expect(accent, findsOneWidget);
    expect(type, findsOneWidget);
    expect(
      tester.getTopRight(card).dx - tester.getTopRight(type).dx,
      closeTo(16, .01),
    );
    expect(
      find.descendant(of: card, matching: find.byType(AppLineIconWidget)),
      findsNothing,
    );
    expect(find.text('Текущая пара'), findsOneWidget);
  });

  testWidgets('the lesson type stays right aligned with large text', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(),
      size: const Size(390, 844),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pumpAndSettle();

    final card = find.byWidgetPredicate(
      (widget) =>
          widget.key is ValueKey<String> &&
          (widget.key! as ValueKey<String>).value.startsWith(
            'schedule-lesson-card-',
          ),
    );
    final type = find.byWidgetPredicate(
      (widget) =>
          widget.key is ValueKey<String> &&
          (widget.key! as ValueKey<String>).value.startsWith(
            'schedule-lesson-type-',
          ),
    );
    expect(card, findsOneWidget);
    expect(type, findsOneWidget);
    expect(
      tester.getTopRight(card).dx - tester.getTopRight(type).dx,
      closeTo(16, .01),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('mixed timeline keeps free windows around activities', (
    tester,
  ) async {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    LessonSchedulePart lesson(
      String subject,
      int startHour,
      int startMinute,
      int endHour,
      int endMinute,
    ) => LessonSchedulePart(
      subject: subject,
      lessonType: LessonType.lecture,
      teachers: const [],
      classrooms: const [],
      lessonBells: LessonBells(
        startTime: TimeOfDay(hour: startHour, minute: startMinute),
        endTime: TimeOfDay(hour: endHour, minute: endMinute),
      ),
      dates: [day],
    );
    final first = lesson('Первая пара', 8, 0, 9, 0);
    final second = lesson('Вторая пара', 10, 15, 11, 0);
    final activity = UserActivity(
      id: 'between-lessons',
      type: UserActivityType.consult,
      title: 'Встреча с куратором',
      startsAt: day.add(const Duration(hours: 9, minutes: 15)),
      endsAt: day.add(const Duration(hours: 9, minutes: 30)),
    );
    whenListen(
      scheduleBloc,
      const Stream<ScheduleState>.empty(),
      initialState: ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: SelectedGroupSchedule(
          group: const Group(name: 'ИКБО-01-25'),
          schedule: [first, second],
        ),
      ),
    );
    whenListen(
      activitiesCubit,
      const Stream<UserActivitiesState>.empty(),
      initialState: UserActivitiesState(
        status: UserActivitiesStatus.populated,
        activities: [activity],
      ),
    );

    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pump();

    expect(find.text('Первая пара'), findsOneWidget);
    expect(find.text('Встреча с куратором'), findsOneWidget);
    expect(find.text('Вторая пара'), findsOneWidget);
    expect(find.textContaining('Окно 45 мин'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('changing from agenda clears its hidden lesson filter', (
    tester,
  ) async {
    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pump();

    await tester.tap(find.text('Всё'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Зачёты').last);
    await tester.pumpAndSettle();
    expect(
      find.text('Проектирование распределённых информационных систем'),
      findsNothing,
    );

    await tester.tap(find.text('Неделя'));
    await tester.pumpAndSettle();

    expect(
      find.text('Проектирование распределённых информационных систем'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
