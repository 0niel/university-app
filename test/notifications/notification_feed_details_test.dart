import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations_ru.dart';
import 'package:rtu_mirea_app/notifications/model/notification_feed.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ru'));
  final l10n = AppLocalizationsRu();

  ScheduleChange change({
    required ScheduleChangeKind kind,
    ScheduleChangeSlot before = const ScheduleChangeSlot(),
    ScheduleChangeSlot after = const ScheduleChangeSlot(),
  }) => ScheduleChange(
    id: 'existing-read-id',
    kind: kind,
    subject: 'Математическая логика и теория алгоритмов',
    lessonDate: DateTime(2026, 9, 18),
    createdAt: DateTime(2026, 9, 6, 13),
    oldValue: before,
    newValue: after,
  );

  test('inbox keeps read identity and shows both full time ranges', () {
    final item = buildNotificationFeed(
      l10n: l10n,
      pushes: [],
      changes: [
        change(
          kind: ScheduleChangeKind.move,
          before: const ScheduleChangeSlot(start: '09:00', end: '10:30'),
          after: const ScheduleChangeSlot(start: '10:40', end: '12:10'),
        ),
      ],
    ).single;
    expect(item.id, 'change:existing-read-id');
    expect(item.route, '/schedule');
    for (final time in ['09:00', '10:30', '10:40', '12:10']) {
      expect(item.subtitle, contains(time));
    }
  });

  test('room-only change does not announce a time move', () {
    final item = buildNotificationFeed(
      l10n: l10n,
      pushes: [],
      changes: [
        change(
          kind: ScheduleChangeKind.move,
          before: const ScheduleChangeSlot(start: '09:00', rooms: ['А-101']),
          after: const ScheduleChangeSlot(start: '09:00', rooms: ['Б-202']),
        ),
      ],
    ).single;
    expect(item.title, isNot(contains('перенес')));
    expect(item.subtitle, contains('А-101'));
    expect(item.subtitle, contains('Б-202'));
    expect(item.subtitle, isNot(contains('— →')));
  });

  test('missing historical detail is not an invented move', () {
    final item = buildNotificationFeed(
      l10n: l10n,
      pushes: [],
      changes: [change(kind: ScheduleChangeKind.update)],
    ).single;
    expect(item.title, isNot(contains('перенес')));
    expect(item.subtitle, isNot(contains('— →')));
    expect(item.subtitle, isNotEmpty);
  });

  test('canonical title correction is readable in the home inbox', () {
    final correction = ScheduleChange.fromJson({
      'id': 'canonical-title-fix',
      'change_kind': 'update',
      'subject': 'Математическая логика и теория алгоритмов',
      'lesson_date': '2026-09-18',
      'created_at': '2026-09-06T13:40:00Z',
      'old_value': {
        'title': 'Математическая логика итеория алгоритмов',
        'start_time': '12:40:00',
        'end_time': '14:10:00',
        'dates': ['2026-09-18'],
      },
      'new_value': {
        'title': 'Математическая логика и теория алгоритмов',
        'start_time': '12:40:00',
        'end_time': '14:10:00',
        'dates': ['2026-09-18'],
      },
    });
    final item = buildNotificationFeed(
      l10n: l10n,
      pushes: [],
      changes: [correction],
    ).single;
    expect(item.title, isNot(contains('перенес')));
    expect(item.subtitle, contains('итеория'));
    expect(item.subtitle, contains('и теория'));
    expect(item.subtitle, contains('12:40'));
    expect(item.subtitle, contains('14:10'));
    expect(item.subtitle, isNot(contains('— →')));
  });
}
