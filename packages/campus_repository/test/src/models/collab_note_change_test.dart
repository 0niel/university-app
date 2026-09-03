import 'package:campus_repository/src/models/collab_note_change.dart';
import 'package:test/test.dart';

void main() {
  group('CollabNoteChange', () {
    test('round-trips through payload', () {
      const change = CollabNoteChange(
        clientId: 'client-1',
        revision: 4,
        document: [
          {
            'insert': 'hi\n',
          },
        ],
      );

      final decoded = CollabNoteChange.fromPayload(change.toPayload());

      expect(decoded.clientId, 'client-1');
      expect(decoded.revision, 4);
      expect(decoded.document, change.document);
      expect(change.toPayload()['version'], 2);
    });

    test('rejects missing snapshot fields', () {
      expect(
        () => CollabNoteChange.fromPayload(const {}),
        throwsFormatException,
      );
    });

    test('rejects old uncommitted delta payloads', () {
      expect(
        () => CollabNoteChange.fromPayload(const {
          'clientId': 'a',
          'baseRevision': 2,
          'delta': 'not-a-list',
        }),
        throwsFormatException,
      );
    });

    test('rejects invalid revisions and documents', () {
      for (final change in <Map<String, Object?>>[
        {'revision': -1},
        {'revision': 1.5},
        {'document': 'not-a-list'},
        {'document': <Object?>[]},
        {'clientId': ''},
      ]) {
        expect(
          () => CollabNoteChange.fromPayload({
            'version': 2,
            'clientId': 'client',
            'revision': 1,
            'document': [
              {'insert': 'text\n'},
            ],
            ...change,
          }),
          throwsFormatException,
        );
      }
    });

    test('round-trips a committed timestamp', () {
      final change = CollabNoteChange(
        clientId: 'client',
        revision: 1,
        document: const [
          {'insert': '\n'},
        ],
        updatedAt: DateTime.utc(2026, 9, 3),
      );
      expect(
        CollabNoteChange.fromPayload(change.toPayload()).updatedAt,
        change.updatedAt,
      );
    });
  });
}
