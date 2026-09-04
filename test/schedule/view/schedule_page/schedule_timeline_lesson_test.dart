import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

void main() {
  final day = DateTime(2026, 9, 2);

  Future<void> pumpLesson(
    WidgetTester tester, {
    LessonSchedulePart? lesson,
    List<ScheduleChange> changes = const [],
  }) => tester.pumpApp(
    Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ScheduleDayView(
          day: day,
          now: day,
          schedule: [lesson ?? scheduleTestLesson()],
          changes: changes,
          preferences: const SchedulePreferencesState(),
          display: const ScheduleDisplayState(),
          activities: const [],
          comparing: false,
          onDay: (_) {},
        ),
      ),
    ),
    size: const Size(390, 844),
  );

  testWidgets('lesson card has no trailing more circle', (tester) async {
    await pumpLesson(tester);

    expect(
      find.byWidgetPredicate(
        (widget) => widget is AppLineIconWidget && widget.icon == .more,
      ),
      findsNothing,
    );
  });

  testWidgets('lesson card shows the short campus beside the classroom', (
    tester,
  ) async {
    await pumpLesson(
      tester,
      lesson: scheduleTestLesson().copyWith(
        classrooms: const [
          Classroom(
            name: 'А-415-6',
            campus: Campus(
              name: 'Проспект Вернадского, д.78',
              shortName: 'В-78',
            ),
          ),
        ],
      ),
    );

    expect(find.textContaining('А-415-6 · В-78'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('moved lesson keeps the short campus beside the new classroom', (
    tester,
  ) async {
    final lesson = scheduleTestLesson().copyWith(
      classrooms: const [
        Classroom(
          name: 'А-415-6',
          campus: Campus(
            name: 'Проспект Вернадского, д.78',
            shortName: 'В-78',
          ),
        ),
      ],
    );
    await pumpLesson(
      tester,
      lesson: lesson,
      changes: [
        ScheduleChange(
          id: 'room-change',
          kind: ScheduleChangeKind.room,
          subject: lesson.subject,
          lessonDate: lesson.dates.single,
          createdAt: lesson.dates.single,
          oldValue: const ScheduleChangeSlot(rooms: ['А-101']),
          newValue: const ScheduleChangeSlot(rooms: ['А-415-6']),
        ),
      ],
    );

    expect(find.textContaining('А-415-6 · В-78'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'long-pressing a lesson fires a medium haptic and opens actions',
    (tester) async {
      final calls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          calls.add(call);
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await pumpLesson(tester);

      await tester.longPress(find.text('Математика'));
      await tester.pumpAndSettle();

      expect(
        calls.any(
          (call) =>
              call.method == 'HapticFeedback.vibrate' &&
              call.arguments == 'HapticFeedbackType.mediumImpact',
        ),
        isTrue,
      );
      final context = tester.element(find.byType(Scaffold).first);
      expect(find.text(context.l10n.scheduleActionOpen), findsOneWidget);
      expect(find.text(context.l10n.classActionRemind), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
