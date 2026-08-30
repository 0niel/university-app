import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/models/lesson_comment.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  final bells = LessonBells(
    number: 2,
    startTime: const TimeOfDay(hour: 10, minute: 40),
    endTime: const TimeOfDay(hour: 12, minute: 10),
  );

  LessonComment build({bool shared = false}) => .new(
    subjectName: 'Машинное обучение',
    lessonDate: DateTime(2026, 5, 20),
    lessonBells: bells,
    text: 'Backprop = chain rule #задание5',
    isSharedWithGroup: shared,
  );

  group('LessonComment', () {
    test('defaults isSharedWithGroup to false', () {
      final comment = LessonComment(
        subjectName: 'X',
        lessonDate: DateTime(2026),
        lessonBells: bells,
        text: 'hi',
      );
      expect(comment.isSharedWithGroup, isFalse);
    });

    test('equality includes isSharedWithGroup', () {
      final comment = build();
      expect(comment, isNot(equals(build(shared: true))));
    });

    test('round-trips the shared flag through json', () {
      final shared = build(shared: true);
      final json = shared.toJson();
      expect(json['isSharedWithGroup'], isTrue);
      expect(LessonComment.fromJson(json).isSharedWithGroup, isTrue);
    });

    test('tolerates legacy json without the flag', () {
      final json = build().toJson()..remove('isSharedWithGroup');
      expect(LessonComment.fromJson(json).isSharedWithGroup, isFalse);
    });
  });
}
