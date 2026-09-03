import 'package:campus_repository/campus_repository.dart';
import 'package:test/test.dart';

void main() {
  group('GroupNoteDocumentSaveResult', () {
    test('parses a successful save response', () {
      final result = GroupNoteDocumentSaveResult.fromJson({
        'revision': 3,
        'updatedAt': '2026-09-03T10:00:00Z',
        'conflict': false,
        'document': [
          {'insert': 'hello\n'},
        ],
        'content': 'hello',
      });

      expect(result.revision, 3);
      expect(result.conflict, isFalse);
      expect(result.content, 'hello');
      expect(result.document, [
        {'insert': 'hello\n'},
      ]);
    });

    test('parses a conflict response with the latest document', () {
      final result = GroupNoteDocumentSaveResult.fromJson({
        'revision': 7,
        'updatedAt': '2026-09-03T10:05:00Z',
        'conflict': true,
        'document': [
          {'insert': 'other editor wins\n'},
        ],
        'content': 'other editor wins',
      });

      expect(result.conflict, isTrue);
      expect(result.revision, 7);
    });

    test('defaults conflict to false when absent', () {
      final result = GroupNoteDocumentSaveResult.fromJson({
        'revision': 1,
        'updatedAt': '2026-09-03T10:00:00Z',
      });

      expect(result.conflict, isFalse);
      expect(result.document, isEmpty);
      expect(result.content, '');
    });
  });
}
