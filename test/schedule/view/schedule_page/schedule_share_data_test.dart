import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations_ru.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/schedule_share_data.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/schedule_share_event.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../gallery/gallery_fonts.dart';
import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ru'));
  setUpAll(loadGalleryFonts);
  final l10n = AppLocalizationsRu();

  test(
    'mixed export retains real dates and never invents missing event times',
    () {
      final day = DateTime(2030, 9, 2);
      final events = scheduleShareEvents(
        l10n: l10n,
        schedule: [
          CalendarSchedulePart(title: 'All day', dates: [day], isAllDay: true),
          CalendarSchedulePart(title: 'Untimed', dates: [day]),
          CalendarSchedulePart(
            title: 'Conference',
            dates: [day],
            startsAt: day.add(const Duration(hours: 12)),
            endsAt: day.add(const Duration(hours: 14)),
            location: 'Hall',
          ),
          HolidaySchedulePart(title: 'Holiday', dates: [day]),
        ],
        activities: [
          UserActivity(
            id: 'own',
            type: UserActivityType.personal,
            title: 'My meeting',
            startsAt: day.add(const Duration(hours: 16)),
          ),
        ],
        first: day,
        last: day.add(const Duration(days: 1)),
        showPast: true,
        now: day,
      );
      expect(events, hasLength(5));
      expect(
        events.singleWhere((event) => event.title == 'My meeting').end,
        isNull,
      );
      final text = scheduleShareText(l10n, 'Group', [
        scheduleTestLesson(day: day),
      ], events: events);
      for (final title in [
        'All day',
        'Untimed',
        'Conference',
        'Holiday',
        'My meeting',
      ]) {
        expect(text, contains(title));
      }
      final calendar = scheduleShareCalendar(
        l10n,
        [],
        reminders: false,
        events: events,
      ).replaceAll('\r\n ', '');
      expect(calendar.split('BEGIN:VEVENT'), hasLength(5));
      expect(calendar, contains('DTSTART;VALUE=DATE:20300902'));
      expect(calendar, isNot(contains('SUMMARY:Untimed')));
      final own = calendar
          .split('BEGIN:VEVENT')
          .singleWhere((entry) => entry.contains('SUMMARY:My meeting'));
      expect(own, isNot(contains('DTEND')));
    },
  );

  test('week export clips recurring dates to the displayed week', () {
    final lesson = scheduleTestLesson().copyWith(
      dates: [
        DateTime(2026, 8, 26),
        DateTime(2026, 9, 2),
        DateTime(2026, 9, 9),
      ],
    );
    final result = scheduleShareLessons(
      [lesson],
      day: DateTime(2026, 9, 2),
      period: 1,
    );
    expect(result.single.dates, [DateTime(2026, 9, 2)]);
    expect(lesson.dates, hasLength(3));
  });

  test('January belongs to the preceding autumn semester', () {
    final lesson = scheduleTestLesson().copyWith(
      dates: [
        DateTime(2025, 9, 5),
        DateTime(2026, 1, 12),
        DateTime(2026, 2, 3),
      ],
    );
    final result = scheduleShareLessons(
      [lesson],
      day: DateTime(2026, 1, 12),
      period: 2,
    );
    expect(result.single.dates, [DateTime(2025, 9, 5), DateTime(2026, 1, 12)]);
  });

  test('ICS escapes data and includes only requested reminders', () {
    final lesson = scheduleTestLesson(subject: 'Алгебра, часть; 1\nГруппа');
    final calendar = scheduleShareCalendar(l10n, [lesson], reminders: true);
    expect(calendar, contains(r'SUMMARY:Алгебра\, часть\; 1\nГруппа'));
    expect(calendar, contains('BEGIN:VALARM\r\nTRIGGER:-PT15M'));
    expect(calendar.split('BEGIN:VEVENT'), hasLength(2));
    expect(
      scheduleShareCalendar(l10n, [lesson], reminders: false),
      isNot(contains('VALARM')),
    );
  });

  test(
    'ICS deduplicates dates and lessons without merging different types',
    () {
      final lesson = scheduleTestLesson().copyWith(
        dates: [DateTime(2026, 9, 2), DateTime(2026, 9, 2)],
      );
      final calendar = scheduleShareCalendar(
        l10n,
        [lesson, lesson, lesson.copyWith(lessonType: .practice)],
        reminders: false,
      );
      final unfolded = calendar.replaceAll('\r\n ', '');
      expect(unfolded.split('BEGIN:VEVENT'), hasLength(3));
      final identifiers = unfolded
          .split('\r\n')
          .where((l) => l.startsWith('UID:'));
      expect(identifiers.toSet(), hasLength(2));
    },
  );

  test('ICS folds UTF8 lines within 75 octets without losing content', () {
    final title = List.filled(20, 'Программирование; часть,').join(' ');
    final calendar = scheduleShareCalendar(
      l10n,
      [scheduleTestLesson(subject: title)],
      reminders: false,
    );
    for (final line in calendar.split('\r\n')) {
      expect(utf8.encode(line).length, lessThanOrEqualTo(75));
    }
    expect(
      calendar.replaceAll('\r\n ', ''),
      contains(
        'SUMMARY:${title.replaceAll(';', r'\;').replaceAll(',', r'\,')}',
      ),
    );
  });

  test('ICS normalizes carriage returns so text cannot inject properties', () {
    final calendar = scheduleShareCalendar(l10n, [
      scheduleTestLesson(subject: 'Math\r\nATTENDEE:malicious\rEND:VEVENT'),
    ], reminders: false).replaceAll('\r\n ', '');
    expect(calendar, contains(r'SUMMARY:Math\nATTENDEE:malicious\nEND:VEVENT'));
    expect(calendar.split('\r\nEND:VEVENT\r\n'), hasLength(2));
  });

  testWidgets('image export paginates a full schedule into bounded PNG pages', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpApp(
      Builder(
        builder: (value) {
          context = value;
          return const SizedBox();
        },
      ),
    );
    final lessons = [
      for (var i = 0; i < 24; i++)
        scheduleTestLesson(
          subject: 'Предмет $i — Полное расписание',
          day: DateTime(2030, 9, 2).add(Duration(days: i)),
        ),
    ];
    final pages = await tester.runAsync(
      () => scheduleShareImages(context, 'ИКБО-01-24', lessons),
    );
    expect(pages, isNotNull);
    expect(pages!.length, greaterThan(1));
    for (final bytes in pages) {
      final codec = await tester.runAsync(
        () => ui.instantiateImageCodec(bytes),
      );
      final frame = await tester.runAsync(codec!.getNextFrame);
      expect(frame!.image.width, 1080);
      expect(frame.image.height, 1600);
      frame.image.dispose();
      codec.dispose();
    }
    if (const bool.fromEnvironment('EXPORT_PREVIEW')) {
      await tester.runAsync(() async {
        final directory = Directory('build/test_exports');
        await directory.create(recursive: true);
        await File(
          '${directory.path}/schedule-first.png',
        ).writeAsBytes(pages.first);
        await File(
          '${directory.path}/schedule-last.png',
        ).writeAsBytes(pages.last);
      });
    }
  });

  testWidgets('image export retains oversized lesson text across pages', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpApp(
      Builder(
        builder: (value) {
          context = value;
          return const SizedBox();
        },
      ),
    );
    final pages = await tester.runAsync(
      () => scheduleShareImages(context, 'Расписание', [
        scheduleTestLesson(
          subject: List.filled(180, 'Длинное название предмета').join(' '),
        ),
      ]),
    );
    expect(pages!.length, greaterThan(1));
  });
}
