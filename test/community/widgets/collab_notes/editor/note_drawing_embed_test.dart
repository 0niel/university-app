import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:rtu_mirea_app/community/view/collab_note_drawing_page.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_stroke.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_embed_builders.dart';

import '../../../../helpers/pump_app.dart';

class _Repository extends Mock implements CampusRepository {}

const _stroke = DrawingStroke(
  points: [PointVector(10, 20, 0.5)],
  color: Color(0xFF123456),
  width: 8,
  canvasSize: Size(768, 1024),
);

void main() {
  late QuillController controller;
  late _Repository repository;
  late Completer<String> upload;

  setUpAll(() => registerFallbackValue(Uint8List(0)));

  setUp(() {
    controller = QuillController(
      document: Document.fromJson([
        {'insert': 'Before\n'},
        {
          'insert': {
            'note-drawing': {
              'url': '',
              'strokes': jsonEncode([_stroke.toJson()]),
            },
          },
        },
        {'insert': '\nAfter\n'},
      ]),
      selection: const TextSelection.collapsed(offset: 0),
    );
    repository = _Repository();
    when(
      () => repository.uploadNoteMedia(
        bytes: any(named: 'bytes'),
        contentType: any(named: 'contentType'),
        extension: any(named: 'extension'),
      ),
    ).thenAnswer((_) => upload.future);
  });

  tearDown(() => controller.dispose());

  Future<void> pump(WidgetTester tester) {
    upload = Completer<String>();
    return tester.pumpApp(
      RepositoryProvider<CampusRepository>.value(
        value: repository,
        child: Scaffold(
          body: QuillEditor.basic(
            controller: controller,
            config: const QuillEditorConfig(
              embedBuilders: [NoteDrawingEmbedBuilder()],
            ),
          ),
        ),
      ),
      size: const Size(360, 700),
    );
  }

  Future<void> open(WidgetTester tester) async {
    await pump(tester);
    final preview = tester.getRect(find.byType(Hero));
    expect(preview.width / preview.height, closeTo(3 / 4, 0.001));
    await tester.tap(find.byType(Hero));
    await tester.pumpAndSettle();
    expect(find.byType(CollabNoteDrawingPage), findsOneWidget);
  }

  Future<void> finish(WidgetTester tester) async {
    Navigator.of(tester.element(find.byType(CollabNoteDrawingPage))).pop(
      CollabNoteDrawingResult(
        bytes: Uint8List.fromList([1, 2]),
        strokes: [_stroke],
      ),
    );
    await tester.pumpAndSettle();
  }

  void verifyNoUpload() => verifyNever(
    () => repository.uploadNoteMedia(
      bytes: any(named: 'bytes'),
      contentType: any(named: 'contentType'),
      extension: any(named: 'extension'),
    ),
  );

  void verifyUpload() => verify(
    () => repository.uploadNoteMedia(
      bytes: any(named: 'bytes'),
      contentType: any(named: 'contentType'),
      extension: any(named: 'extension'),
    ),
  ).called(1);

  testWidgets(
    'updates drawing at its current document offset after preceding edits',
    (tester) async {
      await open(tester);
      await finish(tester);
      verifyUpload();
      controller.replaceText(0, 0, 'New\n', null);
      upload.complete('https://example.test/new.png');
      await tester.pump();
      expect(controller.document.toPlainText(), startsWith('New\nBefore\n'));
      expect(controller.document.toPlainText(), endsWith('\nAfter\n'));
      final embed = controller.document.querySegmentLeafNode(11).leaf! as Embed;
      expect((embed.value.data as Map)['url'], 'https://example.test/new.png');
      await tester.pumpWidget(const SizedBox());
    },
  );

  for (final mutation in ['remove', 'readOnly']) {
    testWidgets('$mutation while drawing skips upload and preserves document', (
      tester,
    ) async {
      await open(tester);
      if (mutation == 'remove') {
        controller.replaceText(7, 1, 'Retained text', null);
      } else {
        controller.readOnly = true;
      }
      final before = controller.document.toDelta().toJson();
      await finish(tester);
      verifyNoUpload();
      expect(controller.document.toDelta().toJson(), before);
    });
  }

  for (final mutation in ['replace', 'embed', 'readOnly', 'document']) {
    testWidgets('$mutation during upload cannot overwrite a stale target', (
      tester,
    ) async {
      await open(tester);
      await finish(tester);
      verifyUpload();
      if (mutation == 'replace') {
        controller.replaceText(7, 1, 'Retained text', null);
      } else if (mutation == 'embed') {
        controller.replaceText(
          7,
          1,
          const Embeddable('note-drawing', {
            'url': '',
            'strokes': '[]',
          }),
          null,
        );
      } else if (mutation == 'readOnly') {
        controller.readOnly = true;
      } else {
        controller.document = Document()..insert(0, 'Replacement document');
      }
      final before = controller.document.toDelta().toJson();
      upload.complete('https://example.test/new.png');
      await tester.pumpAndSettle();
      expect(controller.document.toDelta().toJson(), before);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'upload failure shows a kit toast and leaves editable drawing intact',
    (tester) async {
      await open(tester);
      await finish(tester);
      verifyUpload();
      final before = controller.document.toDelta().toJson();
      upload.completeError(StateError('Upload failed'));
      await tester.pumpAndSettle();
      expect(find.text('Не удалось загрузить изображение'), findsOneWidget);
      expect(controller.document.toDelta().toJson(), before);
      await tester.tap(find.byType(Hero));
      await tester.pumpAndSettle();
      expect(find.byType(CollabNoteDrawingPage), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
