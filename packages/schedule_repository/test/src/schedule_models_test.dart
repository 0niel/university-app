import 'package:schedule_repository/schedule_repository.dart';
import 'package:test/test.dart';

void main() {
  group('LessonMaterial', () {
    test('normalizes loosely typed RPC values before generated parsing', () {
      final material = LessonMaterial.fromJson({
        'id': 42,
        'type': 'unsupported',
        'title': 'Lecture notes',
        'fileName': 'notes.pdf',
        'filePath': 'materials/notes.pdf',
        'fileSize': 12.9,
        'downloadCount': 'not-a-number',
        'likeCount': 3,
        'createdAt': '2026-07-13T10:00:00Z',
      });

      expect(material.id, '42');
      expect(material.type, LessonMaterialType.extra);
      expect(material.fileSize, 12);
      expect(material.downloadCount, 0);
      expect(material.authorName, 'Студент');
      expect(material.createdAt.isUtc, isFalse);
    });
  });

  group('ScheduleChange', () {
    test('accepts snake-case rows and trims PostgreSQL time values', () {
      final change = ScheduleChange.fromJson({
        'id': 'change-1',
        'change_kind': 'room',
        'subject': 'Databases',
        'lesson_date': '2026-07-14T00:00:00Z',
        'lesson_number': '2',
        'old_value': {
          'start': '09:00:00',
          'end': '10:30:00',
          'rooms': ['A-101'],
          'teachers': ['Teacher'],
        },
        'created_at': '2026-07-13T12:00:00Z',
      });

      expect(change.kind, ScheduleChangeKind.room);
      expect(change.lessonNumber, 2);
      expect(change.oldValue.start, '09:00');
      expect(change.oldValue.end, '10:30');
      expect(change.newValue.isEmpty, isTrue);
      expect(change.createdAt.isUtc, isFalse);
    });
  });

  group('UserActivity', () {
    test('normalizes snake-case timestamps and has Freezed value equality', () {
      final activity = UserActivity.fromJson({
        'id': 7,
        'activity_type': 'consult',
        'title': 'Consultation',
        'starts_at': '2026-07-14T08:00:00Z',
        'ends_at': '2026-07-14T09:00:00Z',
      });

      expect(activity.id, '7');
      expect(activity.type, UserActivityType.consult);
      expect(activity.startsAt.isUtc, isFalse);
      expect(activity.endsAt?.isUtc, isFalse);
      expect(activity.copyWith(), activity);
    });
  });
}
