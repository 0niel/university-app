import 'package:campus_repository/campus_repository.dart';
import 'package:test/test.dart';

void main() {
  group('CollabNote document fields', () {
    test('defaults document fields when absent', () {
      final note = CollabNote.fromJson({'id': 'n1', 'title': 'Лекция'});

      expect(note.document, isNull);
      expect(note.documentRevision, 0);
      expect(note.collaboratorNames, isEmpty);
    });

    test('parses document fields when present', () {
      final note = CollabNote.fromJson({
        'id': 'n1',
        'title': 'Лекция',
        'documentRevision': 5,
        'document': [
          {'insert': 'text\n'},
        ],
        'collaboratorNames': ['Аня', 'Боря'],
      });

      expect(note.documentRevision, 5);
      expect(note.document, [
        {'insert': 'text\n'},
      ]);
      expect(note.collaboratorNames, ['Аня', 'Боря']);
    });
  });
}
