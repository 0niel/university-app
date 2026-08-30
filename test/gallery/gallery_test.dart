@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_group.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';
import 'package:rtu_mirea_app/home/view/dashboard/dashboard.dart';
import 'package:rtu_mirea_app/home/view/home_day_pager.dart';
import 'package:rtu_mirea_app/home/view/home_deadline_row.dart';
import 'package:rtu_mirea_app/home/view/home_lesson_hero.dart';
import 'package:rtu_mirea_app/home/view/home_section_header.dart';
import 'package:rtu_mirea_app/home/view/home_section_list.dart';
import 'package:rtu_mirea_app/home/view/home_today_row.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final loader = FontLoader('Inter');
    for (final weight in const [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
    ]) {
      loader.addFont(
        rootBundle.load(
          'packages/app_ui/assets/fonts/Inter/Inter-$weight.ttf',
        ),
      );
    }
    await loader.load();
  });

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
          backgroundColor: context.ninja.canvas,
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
  final deadlines = [
    Deadline(
      id: 'd1',
      title: 'Отчёт по лабораторной №3',
      dueAt: _now.add(const Duration(days: 1)),
      source: DeadlineSource.me,
      subjectName: 'Матанализ',
    ),
    Deadline(
      id: 'd2',
      title: 'Курсовая — глава 2',
      dueAt: _now.add(const Duration(days: 4)),
      source: DeadlineSource.me,
      subjectName: 'Физика',
    ),
  ];

  final current = _lesson(
    subject: 'Математический анализ',
    startHour: 10,
    startMinute: 40,
    endHour: 12,
    endMinute: 10,
  );
  final next = _lesson(
    subject: 'Физика',
    startHour: 12,
    startMinute: 20,
    endHour: 13,
    endMinute: 50,
    room: '120 А',
  );
  final third = _lesson(
    subject: 'Английский язык',
    startHour: 14,
    startMinute: 0,
    endHour: 15,
    endMinute: 30,
    room: 'Б-105',
    type: LessonType.practice,
  );

  testWidgets('6a · home board', (tester) async {
    await _sheet(
      tester,
      'home_6a',
      dark: true,
      CustomScrollView(
        slivers: [
          HomeDashboardHeader(
            day: _now,
            locale: 'ru',
            userName: 'Анна Соколова',
            greeting: 'Привет, Анна',
            loading: false,
            searchKey: GlobalKey(),
          ),
          SliverToBoxAdapter(
            child: HomeTitleBlock(
              day: _now,
              locale: 'ru',
              status: (
                kind: HomeDayStatusKind.live,
                lessonCount: 3,
                minutes: 44,
                startsAt: null,
              ),
              loading: false,
              offline: false,
            ),
          ),
          SliverList.list(
            children: [
              const _GalleryDayStrip(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: HomeLessonHero(
                  lesson: current,
                  day: _now,
                  now: _now,
                  isCurrent: true,
                ),
              ),
              const HomeSectionHeader(title: 'Дедлайны', action: 'все'),
              HomeSectionList(
                children: [
                  for (final deadline in deadlines)
                    HomeDeadlineRow(deadline: deadline),
                ],
              ),
              const HomeSectionHeader(title: 'Сегодня', action: 'все'),
              HomeSectionList(
                children: [
                  HomeTodayRow(lesson: next, isNext: true),
                  HomeTodayRow(lesson: third, isNext: false),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  });

  testWidgets('6a · home board (dark)', (tester) async {
    await _sheet(
      tester,
      'home_6a_dark',
      dark: true,
      CustomScrollView(
        slivers: [
          HomeDashboardHeader(
            day: _now,
            locale: 'ru',
            userName: 'Анна Соколова',
            greeting: 'Привет, Анна',
            loading: false,
            searchKey: GlobalKey(),
          ),
          SliverToBoxAdapter(
            child: HomeTitleBlock(
              day: _now,
              locale: 'ru',
              status: (
                kind: HomeDayStatusKind.live,
                lessonCount: 3,
                minutes: 44,
                startsAt: null,
              ),
              loading: false,
              offline: false,
            ),
          ),
          SliverList.list(
            children: [
              const _GalleryDayStrip(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: HomeLessonHero(
                  lesson: current,
                  day: _now,
                  now: _now,
                  isCurrent: true,
                ),
              ),
              const HomeSectionHeader(title: 'Сегодня', action: 'все'),
              HomeSectionList(
                children: [
                  HomeTodayRow(lesson: next, isNext: true),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  });
}

void _scheduleSheets() {
  final current = _lesson(
    subject: 'Математический анализ',
    startHour: 10,
    startMinute: 40,
    endHour: 12,
    endMinute: 10,
  );
  final next = _lesson(
    subject: 'Физика',
    startHour: 12,
    startMinute: 20,
    endHour: 13,
    endMinute: 50,
    room: '120 А',
    type: LessonType.laboratoryWork,
  );
  final third = _lesson(
    subject: 'Английский язык',
    startHour: 14,
    startMinute: 0,
    endHour: 15,
    endMinute: 30,
    room: 'Б-105',
    type: LessonType.practice,
  );
  testWidgets('6d · schedule day', (tester) async {
    await _sheet(
      tester,
      'schedule_6d',
      dark: true,
      ListView(
        padding: EdgeInsets.zero,
        children: [
          const HomeSectionHeader(
            title: 'Среда, 13 августа',
            action: 'сегодня',
            topPadding: 10,
          ),
          const _GalleryDayStrip(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: HomeLessonHero(
              lesson: current,
              day: _now,
              now: _now,
              isCurrent: true,
            ),
          ),
          const HomeSectionHeader(title: 'Далее', action: 'все'),
          HomeSectionList(
            children: [
              HomeTodayRow(lesson: next, isNext: true),
              HomeTodayRow(lesson: third, isNext: false),
            ],
          ),
        ],
      ),
    );
  });
}

class _GalleryDayStrip extends StatelessWidget {
  const _GalleryDayStrip();
  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      7,
      (index) => DateTime(2026, 8, 11 + index),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 7),
      child: HomeDayPager(
        days: days,
        lessonCounts: const [3, 4, 3, 4, 2, 0, 0],
        selectedIndex: 2,
        onSelected: (_) {},
      ),
    );
  }
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
