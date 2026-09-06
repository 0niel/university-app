import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations_ru.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_change_card.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_change_presentation.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  final l10n = AppLocalizationsRu();
  setUpAll(() => initializeDateFormatting('ru'));

  ScheduleChange change({
    ScheduleChangeKind kind = ScheduleChangeKind.update,
    ScheduleChangeSlot before = const ScheduleChangeSlot(),
    ScheduleChangeSlot after = const ScheduleChangeSlot(),
  }) => ScheduleChange(
    id: 'change',
    kind: kind,
    subject: 'Математика',
    lessonDate: DateTime(2026, 9, 11),
    createdAt: DateTime(2026, 9, 6, 15, 20),
    oldValue: before,
    newValue: after,
  );
  ScheduleChangePresentation present(ScheduleChange value) =>
      ScheduleChangePresentation.fromChange(value, l10n);

  test('canonical subject rename preserves full unchanged lesson time', () {
    final result = present(
      change(
        before: const ScheduleChangeSlot(
          subject: 'Математическая логика',
          start: '12:40',
          end: '14:10',
        ),
        after: const ScheduleChangeSlot(
          subject: 'Математическая логика и теория алгоритмов',
          start: '12:40',
          end: '14:10',
        ),
      ),
    );
    expect(result.effectiveKind, ScheduleChangeKind.update);
    expect(result.title, l10n.scheduleChangeRenamed);
    expect(result.subject, 'Математическая логика и теория алгоритмов');
    expect(result.details.single.label, l10n.scheduleChangeSubjectLabel);
    expect(result.details.single.before, 'Математическая логика');
    expect(result.context, contains('12:40 – 14:10'));
    expect(result.summary, contains('2026'));
    expect(result.summary, isNot(contains('—')));
  });

  test('legacy move with only room difference is a room change', () {
    final result = present(
      change(
        kind: ScheduleChangeKind.move,
        before: const ScheduleChangeSlot(
          start: '12:40',
          end: '14:10',
          rooms: ['А-101'],
        ),
        after: const ScheduleChangeSlot(
          start: '12:40',
          end: '14:10',
          rooms: ['Б-202'],
        ),
      ),
    );
    expect(result.effectiveKind, ScheduleChangeKind.room);
    expect(result.title, l10n.changeRoomTitle);
    expect(result.details.single.before, 'А-101');
    expect(result.details.single.after, 'Б-202');
    expect(result.context, contains('12:40 – 14:10'));
  });

  test('date-only move shows dates instead of equal time values', () {
    final result = present(
      change(
        before: ScheduleChangeSlot(
          start: '12:40',
          end: '14:10',
          dates: [DateTime(2026, 9, 11)],
        ),
        after: ScheduleChangeSlot(
          start: '12:40',
          end: '14:10',
          dates: [DateTime(2026, 9, 18)],
        ),
      ),
    );
    expect(result.effectiveKind, ScheduleChangeKind.move);
    expect(result.details.single.label, l10n.scheduleChangeDate);
    expect(result.details.single.before, contains('11'));
    expect(result.details.single.after, contains('18'));
    expect(result.details.single.after, contains('2026'));
    expect(result.context, contains('12:40 – 14:10'));
  });

  test('end time changes and all changed staff and rooms remain visible', () {
    final result = present(
      change(
        before: const ScheduleChangeSlot(
          start: '12:40',
          end: '14:10',
          teachers: ['Иванов И.И.'],
          rooms: ['А-101'],
        ),
        after: const ScheduleChangeSlot(
          start: '12:40',
          end: '14:20',
          teachers: ['Петров П.П.'],
          rooms: ['А-102'],
        ),
      ),
    );
    expect(result.effectiveKind, ScheduleChangeKind.move);
    expect(result.details, hasLength(3));
    expect(result.summary, contains('12:40 – 14:10'));
    expect(result.summary, contains('12:40 – 14:20'));
    expect(result.summary, contains('Иванов И.И.'));
    expect(result.summary, contains('А-102'));
  });

  test('wire lesson types use the application locale', () {
    final result = present(
      change(
        before: const ScheduleChangeSlot(lessonType: 'lecture'),
        after: const ScheduleChangeSlot(lessonType: 'practice'),
      ),
    );
    expect(result.details.single.before, l10n.lecture);
    expect(result.details.single.after, l10n.practice);
    expect(result.summary, isNot(contains('practice')));
  });

  test('missing history never invents a move or rename', () {
    for (final before in [
      const ScheduleChangeSlot(),
      const ScheduleChangeSlot(end: '14:10'),
    ]) {
      final result = present(
        change(
          before: before,
          after: ScheduleChangeSlot(
            subject: 'Математика',
            start: '12:40',
            end: '14:10',
            dates: [DateTime(2026, 9, 11)],
          ),
        ),
      );
      expect(result.effectiveKind, ScheduleChangeKind.update);
      expect(result.title, l10n.scheduleChangeUpdated);
      expect(result.summary, contains(l10n.scheduleChangeUnavailable));
      expect(result.summary, isNot(contains('—')));
    }
    final titleOnly = present(
      change(
        after: const ScheduleChangeSlot(subject: 'Математика'),
      ),
    );
    expect(titleOnly.title, l10n.scheduleChangeUpdated);
  });

  test(
    'missing both snapshots describes unavailable detail without arrows',
    () {
      final result = present(change(kind: ScheduleChangeKind.move));
      expect(result.effectiveKind, ScheduleChangeKind.update);
      expect(result.details, isEmpty);
      expect(result.summary, contains(l10n.scheduleChangeDetailsUnavailable));
      expect(result.summary, isNot(contains('→')));
      expect(result.summary, isNot(contains('—')));
    },
  );

  test('reordered identical rooms and teachers do not invent differences', () {
    final result = present(
      change(
        before: const ScheduleChangeSlot(
          rooms: ['А-101', 'Б-202'],
          teachers: ['Иванов', 'Петров'],
        ),
        after: const ScheduleChangeSlot(
          rooms: ['Б-202', 'А-101'],
          teachers: ['Петров', 'Иванов'],
        ),
      ),
    );
    expect(result.details, isEmpty);
    expect(result.effectiveKind, ScheduleChangeKind.update);
  });

  test('add and cancel display the relevant complete snapshot', () {
    const snapshot = ScheduleChangeSlot(
      subject: 'Математика',
      start: '14:20',
      end: '15:50',
      rooms: ['А-101'],
      teachers: ['Иванов'],
      lessonNumber: 4,
      lessonType: 'Лекция',
    );
    for (final kind in [ScheduleChangeKind.add, ScheduleChangeKind.cancel]) {
      final result = present(
        change(
          kind: kind,
          before: kind == ScheduleChangeKind.cancel
              ? snapshot
              : const ScheduleChangeSlot(),
          after: kind == ScheduleChangeKind.add
              ? snapshot
              : const ScheduleChangeSlot(),
        ),
      );
      expect(result.effectiveKind, kind);
      expect(result.isSingleSnapshot, isTrue);
      expect(result.details, isEmpty);
      for (final text in ['14:20 – 15:50', 'А-101', 'Иванов', 'Лекция', '4']) {
        expect(result.summary, contains(text));
      }
    }
  });

  for (final width in [320.0, 390.0, 800.0]) {
    testWidgets('card remains readable at width $width with 200% text', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final item = change(
        before: const ScheduleChangeSlot(
          subject: 'Математическая логика',
          start: '12:40',
          end: '14:10',
          rooms: ['А-101'],
          teachers: ['Иванов Иван Иванович'],
        ),
        after: const ScheduleChangeSlot(
          subject: 'Математическая логика и теория алгоритмов',
          start: '14:20',
          end: '15:50',
          rooms: ['Б-202'],
          teachers: ['Петров Пётр Петрович'],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          theme: AppTheme.darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MediaQuery(
            data: MediaQueryData(
              size: Size(width, 900),
              textScaler: const TextScaler.linear(2),
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ScheduleChangeCard(change: item),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(AppCard), findsOneWidget);
      expect(
        find.text('Математическая логика и теория алгоритмов'),
        findsWidgets,
      );
      expect(find.text(l10n.scheduleChangeBefore), findsNWidgets(4));
      expect(find.text(l10n.scheduleChangeAfter), findsNWidgets(4));
      expect(find.text('12:40 – 14:10'), findsOneWidget);
      expect(find.text('14:20 – 15:50'), findsOneWidget);
      expect(find.textContaining('Обнаружено'), findsOneWidget);
    });
  }
}
