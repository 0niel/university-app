import 'package:schedule/schedule.dart';
import 'package:test/test.dart';

void main() {
  LessonSchedulePart build({int? color, int? reminderMinutes}) {
    return LessonSchedulePart(
      subject: 'Машинное обучение',
      lessonType: .lecture,
      teachers: const [Teacher(name: 'Соколова М. В.')],
      classrooms: const [Classroom(name: 'Г-407')],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 10, minute: 40),
        endTime: const TimeOfDay(hour: 12, minute: 10),
        number: 1,
      ),
      dates: [DateTime(2026, 9, 2)],
      color: color,
      reminderMinutes: reminderMinutes,
    );
  }

  group('LessonSchedulePart color & reminderMinutes', () {
    test('round-trips through JSON (snake_case keys)', () {
      final lesson = build(color: 0xFF2F7AFF, reminderMinutes: 15);
      final json = lesson.toJson();

      expect(json['color'], 0xFF2F7AFF);
      expect(json['reminder_minutes'], 15);

      final restored = LessonSchedulePart.fromJson(json);
      expect(restored, equals(lesson));
      expect(restored.color, 0xFF2F7AFF);
      expect(restored.reminderMinutes, 15);
    });

    test('copyWith can explicitly clear nullable customization fields', () {
      final lesson = build(color: 0xFF112233, reminderMinutes: 15);

      final cleared = lesson.copyWith(color: null, reminderMinutes: null);

      expect(cleared.color, isNull);
      expect(cleared.reminderMinutes, isNull);
    });

    test('omits both keys from JSON when null', () {
      final json = build().toJson();
      expect(json.containsKey('color'), isFalse);
      expect(json.containsKey('reminder_minutes'), isFalse);

      final restored = LessonSchedulePart.fromJson(json);
      expect(restored.color, isNull);
      expect(restored.reminderMinutes, isNull);
    });

    test('copyWith overrides color and reminderMinutes', () {
      final updated = build().copyWith(color: 0xFFFF4F4F, reminderMinutes: 30);
      expect(updated.color, 0xFFFF4F4F);
      expect(updated.reminderMinutes, 30);
      expect(updated.subject, 'Машинное обучение');
    });

    test('color and reminderMinutes participate in equality', () {
      expect(build(color: 1), isNot(equals(build(color: 2))));
      expect(build(color: 1), equals(build(color: 1)));
      expect(
        build(reminderMinutes: 15),
        isNot(equals(build(reminderMinutes: 30))),
      );
    });
  });
}
