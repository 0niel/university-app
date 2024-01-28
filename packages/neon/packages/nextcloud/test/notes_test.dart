import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/notes.dart' as notes;
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:test_api/src/backend/invoker.dart';

void main() {
  presets(
    'notes',
    'notes',
    (preset) {
      late DockerContainer container;
      late NextcloudClient client;
      setUpAll(() async {
        container = await DockerContainer.create(preset);
        client = await TestNextcloudClient.create(container);
      });
      tearDownAll(() async {
        if (Invoker.current!.liveTest.errors.isNotEmpty) {
          print(await container.allLogs());
        }
        container.destroy();
      });

      Future<void> deleteAllNotes() async {
        final response = await client.notes.getNotes();
        for (final note in response.body) {
          await client.notes.deleteNote(id: note.id);
        }
      }

      test('Is supported', () async {
        final response = await client.core.ocs.getCapabilities();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        final result = client.notes.getVersionCheck(response.body.ocs.data);
        expect(result.versions, isNotNull);
        expect(result.versions, isNotEmpty);
        expect(result.isSupported, isTrue);
      });

      test('Create note favorite', () async {
        await deleteAllNotes();
        final response = await client.notes.createNote(
          title: 'a',
          content: 'b',
          category: 'c',
          favorite: 1,
        );
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.id, isPositive);
        expect(response.body.title, 'a');
        expect(response.body.content, 'b');
        expect(response.body.category, 'c');
        expect(response.body.favorite, true);
        expect(response.body.readonly, false);
        expect(response.body.etag, isNotNull);
        expect(response.body.modified, isNotNull);
      });

      test('Create note not favorite', () async {
        await deleteAllNotes();
        final response = await client.notes.createNote(
          title: 'a',
          content: 'b',
          category: 'c',
        );
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.id, isPositive);
        expect(response.body.title, 'a');
        expect(response.body.content, 'b');
        expect(response.body.category, 'c');
        expect(response.body.favorite, false);
        expect(response.body.readonly, false);
        expect(response.body.etag, isNotNull);
        expect(response.body.modified, isNotNull);
      });

      test('Get notes', () async {
        await deleteAllNotes();
        await client.notes.createNote(title: 'a');
        await client.notes.createNote(title: 'b');

        final response = await client.notes.getNotes();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body, hasLength(2));
        expect(response.body[0].title, 'a');
        expect(response.body[1].title, 'b');
      });

      test('Get note', () async {
        await deleteAllNotes();
        final response = await client.notes.getNote(
          id: (await client.notes.createNote(title: 'a')).body.id,
        );
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.title, 'a');
      });

      test('Update note', () async {
        await deleteAllNotes();
        final id = (await client.notes.createNote(title: 'a')).body.id;
        await client.notes.updateNote(
          id: id,
          title: 'b',
        );

        final response = await client.notes.getNote(id: id);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.title, 'b');
      });

      test('Update note fail changed on server', () async {
        await deleteAllNotes();
        final response = await client.notes.createNote(title: 'a');
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        await client.notes.updateNote(
          id: response.body.id,
          title: 'b',
          ifMatch: '"${response.body.etag}"',
        );
        await expectLater(
          () => client.notes.updateNote(
            id: response.body.id,
            title: 'c',
            ifMatch: '"${response.body.etag}"',
          ),
          throwsA(predicate((e) => (e! as DynamiteStatusCodeException).statusCode == 412)),
        );
      });

      test('Delete note', () async {
        await deleteAllNotes();
        final id = (await client.notes.createNote(title: 'a')).body.id;

        var response = await client.notes.getNotes();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body, hasLength(1));

        await client.notes.deleteNote(id: id);

        response = await client.notes.getNotes();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body, hasLength(0));
      });

      test('Get and update settings', () async {
        var response = await client.notes.getSettings();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.notesPath, 'Notes');
        expect(response.body.fileSuffix, '.md');
        expect(response.body.noteMode, notes.Settings_NoteMode.rich);

        response = await client.notes.updateSettings(
          settings: notes.Settings(
            (b) => b
              ..notesPath = 'Test Notes'
              ..fileSuffix = '.txt'
              ..noteMode = notes.Settings_NoteMode.preview,
          ),
        );
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.notesPath, 'Test Notes');
        expect(response.body.fileSuffix, '.txt');
        expect(response.body.noteMode, notes.Settings_NoteMode.preview);

        response = await client.notes.getSettings();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.notesPath, 'Test Notes');
        expect(response.body.fileSuffix, '.txt');
        expect(response.body.noteMode, notes.Settings_NoteMode.preview);
      });
    },
    retry: retryCount,
    timeout: timeout,
  );
}
