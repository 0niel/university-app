@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_group.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_body.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'gallery_fonts.dart';
import 'schedule_gallery.dart';

void main() {
  setUpAll(loadGalleryFonts);

  _homeSheets();
  _scheduleSheets();
  _deadlineSheets();
  _feedSheets();
}

DateTime get _now => DateTime(2026, 8, 13, 11, 26);

LessonSchedulePart _lesson({
  required String subject,
  required int startHour,
  required int startMinute,
  required int endHour,
  required int endMinute,
  String room = '314 Б',
  LessonType type = LessonType.lecture,
}) {
  return LessonSchedulePart(
    subject: subject,
    lessonType: type,
    teachers: const [Teacher(name: 'Иванов И. И.')],
    classrooms: [Classroom(name: room)],
    lessonBells: LessonBells(
      startTime: TimeOfDay(hour: startHour, minute: startMinute),
      endTime: TimeOfDay(hour: endHour, minute: endMinute),
    ),
    dates: [DateTime(2026, 8, 13)],
  );
}

Future<void> _sheet(
  WidgetTester tester,
  String name,
  Widget child, {
  double height = 844,
  bool dark = false,
}) async {
  tester.view
    ..physicalSize = Size(390, height)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.colors.canvas,
          body: child,
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(seconds: 2));

  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$name.png'),
  );
}

void _homeSheets() {
  final lessons = [
    _lesson(
      subject: 'Математический анализ',
      startHour: 10,
      startMinute: 40,
      endHour: 12,
      endMinute: 10,
    ),
    _lesson(
      subject: 'Физика',
      startHour: 12,
      startMinute: 20,
      endHour: 13,
      endMinute: 50,
      room: '120 А',
    ),
    _lesson(
      subject: 'Английский язык',
      startHour: 14,
      startMinute: 0,
      endHour: 15,
      endMinute: 30,
      room: 'Б-105',
      type: LessonType.practice,
    ),
  ];
  final entries = homeDayEntries(day: _now, lessons: lessons, now: _now);
  for (final dark in [false, true]) {
    testWidgets('6a · home board${dark ? ' (dark)' : ''}', (tester) async {
      await _sheet(
        tester,
        dark ? 'home_6a_dark' : 'home_6a',
        dark: dark,
        height: 1100,
        Builder(
          builder: (context) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
            children: [
              HomeTopRow(
                userName: 'Анна Соколова',
                now: _now,
                dotColor: context.colors.accent,
                searchKey: GlobalKey(),
              ),
              const HomeGreeting(
                greeting: 'Доброе утро,',
                name: 'Анна',
                subtitle: 'Сегодня · идёт пара',
              ),
              const _GalleryDayStrip(),
              const SizedBox(height: 14),
              _GalleryHero(entries: entries, kind: HomeHeroKind.during),
              HomeLessonsGroup(
                entries: entries,
                featuredEntry: homeHeroEntry(entries, HomeHeroKind.during),
                onOpen: (_) {},
              ),
              HomeDeadlinesGroup(
                state: DeadlinesState(
                  status: DeadlinesStatus.ready,
                  deadlines: [
                    Deadline(
                      id: 'd1',
                      title: 'Отчёт по лабораторной №3',
                      dueAt: _now.add(const Duration(days: 1)),
                      source: DeadlineSource.me,
                      subjectName: 'Матанализ',
                      isMine: true,
                    ),
                    Deadline(
                      id: 'd2',
                      title: 'Курсовая — глава 2',
                      dueAt: _now.add(const Duration(days: 4)),
                      source: DeadlineSource.me,
                      subjectName: 'Физика',
                      isMine: true,
                    ),
                  ],
                ),
                now: _now,
                onAdd: () {},
                onOpen: () {},
                onToggle: (_) {},
                onRetry: () {},
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _GalleryHero extends StatelessWidget {
  const _GalleryHero({required this.entries, required this.kind});
  final List<HomeLessonEntry> entries;
  final HomeHeroKind kind;

  @override
  Widget build(BuildContext context) => HomeHero(
    entries: entries,
    kind: kind,
    tomorrow: const [],
    now: _now,
    onOpen: (_) {},
    onRoute: (_) {},
    onNote: (_) {},
    onFreeRooms: () {},
    onDeadlines: () {},
    onTomorrow: () {},
  );
}

void _scheduleSheets() {
  for (final view in ScheduleView.values) {
    for (final dark in [false, true]) {
      testWidgets('6d · schedule ${view.name}${dark ? ' dark' : ''}', (
        tester,
      ) async {
        await _sheet(
          tester,
          'schedule_${view.name}${dark ? '_dark' : ''}',
          dark: dark,
          scheduleGalleryScene(view: view),
        );
      });
    }
  }
  for (final dark in [false, true]) {
    testWidgets('6e · lesson${dark ? ' dark' : ''}', (tester) async {
      await _sheet(
        tester,
        'lesson${dark ? '_dark' : ''}',
        dark: dark,
        lessonGalleryScene(),
      );
    });
  }
}

class _GalleryDayStrip extends StatelessWidget {
  const _GalleryDayStrip();
  @override
  Widget build(BuildContext context) => HomeWeekPills(
    days: homeWeekDays(_now),
    lessonCounts: const [3, 4, 3, 4, 2, 0, 0],
    selectedIndex: _now.weekday - 1,
    today: _now,
    changedDays: const {},
    onSelected: (_) {},
  );
}

void _deadlineSheets() {
  final now = DateTime(2026, 8, 13, 11, 26);
  Deadline make(String id, String title, String subject, int days) => Deadline(
    id: id,
    title: title,
    subjectName: subject,
    dueAt: now.add(Duration(days: days)),
    source: DeadlineSource.me,
    isMine: true,
  );

  testWidgets('6b · deadlines board', (tester) async {
    await _sheet(
      tester,
      'deadlines_6b',
      CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: NinjaDisplayHeader(title: 'Дедлайны'),
          ),
          DeadlineGroup(
            title: 'Горит · завтра',
            deadlines: [make('1', 'Отчёт по лабе №3', 'Физика', 1)],
            pendingDeadlineIds: const {},
            onToggle: (_) {},
          ),
          DeadlineGroup(
            title: 'На этой неделе',
            deadlines: [
              make('2', 'ДЗ: ряды, №4.1–4.9', 'Матанализ', 2),
              make('3', 'Эссе “My future career”', 'Английский', 3),
            ],
            pendingDeadlineIds: const {},
            onToggle: (_) {},
          ),
          DeadlineGroup(
            title: 'Позже',
            dimmed: true,
            deadlines: [make('4', 'Доклад: НЭП', 'История', 9)],
            pendingDeadlineIds: const {},
            onToggle: (_) {},
          ),
        ],
      ),
    );
  });
}

void _feedSheets() {
  testWidgets('7d · feed', (tester) async {
    await _sheet(
      tester,
      'feed_7d',
      dark: true,
      ListView(
        padding: EdgeInsets.zero,
        children: [
          const NinjaDisplayHeader(title: 'Лента'),
          const SizedBox(height: 14),
          NinjaChipRow(
            children: [
              NinjaChip(label: 'Всё', selected: true, onTap: () {}),
              NinjaChip(label: 'Мой институт', onTap: () {}),
              NinjaChip(label: 'События', onTap: () {}),
              NinjaChip(label: 'Спорт', onTap: () {}),
            ],
          ),
          const SizedBox(height: 16),
          FeedHeroPost(
            title: 'Хакатон «Политех.Код» — 48 часов, призовой фонд 300 000 ₽',
            meta: 'ИТ-ЦЕНТР · регистрация до 20 авг · осталось 26 мест',
            badgeLabel: 'Событие · 22 авг',
            actionLabel: 'Записаться',
            onAction: () {},
            secondaryActionLabel: 'В команду ищут 2',
            onSecondaryAction: () {},
          ),
          const FeedPostRow(
            title: 'Запись на осенние спортсекции открыта до 25 августа',
            meta: 'Спорт · 2 ч назад',
          ),
          const FeedPostRow(
            title: 'Ремонт перехода между корпусами А и Б — до 18 августа',
            meta: 'Кампус · вчера · маршруты в расписании учтены',
          ),
        ],
      ),
    );
  });
}
