import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/view/collab_note_editor_view.dart';

import '../../helpers/mocks/mock_campus_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(() => registerFallbackValue(Uint8List(0)));
  group('CollabNoteEditorView', () {
    late CampusRepository repository;
    late NoteEditorCubit cubit;

    setUp(() {
      repository = MockCampusRepository();
      when(
        () => repository.renameGroupNote(any(), any()),
      ).thenAnswer((_) async {});
      cubit = NoteEditorCubit(
        repository: repository,
        note: const CollabNote(
          id: 'note-1',
          title: 'Алгоритмы',
          content: 'Исходный текст',
          isMine: true,
          isPersonal: true,
        ),
        editorName: 'Alex',
        saveDebounce: const Duration(days: 1),
      );
    });

    tearDown(() async {
      if (!cubit.isClosed) await cubit.close();
    });

    Widget buildSubject() => RepositoryProvider.value(
      value: repository,
      child: BlocProvider.value(
        value: cubit,
        child: const Scaffold(body: SafeArea(child: CollabNoteEditorView())),
      ),
    );

    GroupNoteDocumentSaveResult saved(List<Object?> document) =>
        GroupNoteDocumentSaveResult(
          revision: 1,
          updatedAt: DateTime(2026, 7, 11, 12),
          document: document,
        );

    testWidgets('shows the note title in the header', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Алгоритмы'), findsOneWidget);
    });

    testWidgets('updates the title as the user types', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.enterText(
        find.byKey(const ValueKey('collab-note-title-field')),
        'Новый заголовок',
      );
      await tester.pump();

      expect(cubit.state.title, 'Новый заголовок');
      expect(await cubit.flush(), isTrue);
      await tester.pump();
    });

    testWidgets('title save failure opens the discard confirmation', (
      tester,
    ) async {
      when(
        () => repository.renameGroupNote(any(), any()),
      ).thenThrow(Exception('rename failed'));
      await tester.pumpApp(buildSubject());
      await tester.enterText(
        find.byKey(const ValueKey('collab-note-title-field')),
        'Несохранённый заголовок',
      );
      await tester.tap(find.bySemanticsLabel('Назад'));
      await tester.pumpAndSettle();
      expect(cubit.state.hasUnsavedChanges, isTrue);
      expect(cubit.state.status, NoteEditorStatus.failure);
      expect(find.text('Выйти без сохранения?'), findsOneWidget);
      cubit.discardChanges();
    });

    testWidgets('makes the title read-only for another note owner', (
      tester,
    ) async {
      await tester.runAsync(cubit.close);
      cubit = NoteEditorCubit(
        repository: repository,
        note: const CollabNote(
          id: 'note-1',
          title: 'Чужая заметка',
          isPersonal: true,
        ),
        editorName: 'Alex',
      );
      await tester.pumpApp(buildSubject());
      final title = tester.widget<AppInputField>(
        find.byKey(const ValueKey('collab-note-title-field')),
      );
      expect(title.readOnly, isTrue);
      expect(cubit.state.readOnly, isFalse);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(cubit.close);
    });

    testWidgets('flushes a pending edit and pops on back', (tester) async {
      when(
        () => repository.saveGroupNoteDocument(
          id: any(named: 'id'),
          document: any(named: 'document'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenAnswer(
        (invocation) async =>
            saved(invocation.namedArguments[#document] as List<Object?>),
      );
      await tester.pumpApp(buildSubject());
      cubit.controller.document.insert(0, 'Ещё текст ');
      await tester.pump();

      await tester.tap(find.bySemanticsLabel('Назад'));
      await tester.pumpAndSettle();

      verify(
        () => repository.saveGroupNoteDocument(
          id: 'note-1',
          document: any(named: 'document'),
          expectedRevision: 0,
        ),
      ).called(1);
    });

    testWidgets('deletes the note from the overflow menu', (tester) async {
      when(
        () => repository.deleteGroupNote('note-1'),
      ).thenAnswer((_) async {});
      await tester.pumpApp(buildSubject());

      await tester.tap(find.bySemanticsLabel('Ещё'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Удалить'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Удалить'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Удалить').last);
      await tester.pumpAndSettle();

      verify(() => repository.deleteGroupNote('note-1')).called(1);
    });

    testWidgets('renders the formatting toolbar', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.bySemanticsLabel('Голосовой ввод'), findsOneWidget);
      expect(find.bySemanticsLabel('Жирный'), findsOneWidget);
      expect(find.bySemanticsLabel('Рисунок'), findsOneWidget);
    });

    testWidgets(
      'reading mode hides tools and disables editing and image input',
      (tester) async {
        await tester.pumpApp(buildSubject(), size: const Size(390, 844));
        await tester.tap(find.bySemanticsLabel('Режим чтения'));
        await tester.pumpAndSettle();
        final editor = tester.widget<QuillEditor>(find.byType(QuillEditor));
        expect(editor.controller.readOnly, isTrue);
        expect(editor.config.checkBoxReadOnly, isTrue);
        expect(editor.config.contentInsertionConfiguration, isNull);
        expect(find.bySemanticsLabel('Жирный'), findsNothing);
        await tester.tap(find.bySemanticsLabel('Редактировать'));
        await tester.pumpAndSettle();
        expect(cubit.controller.readOnly, isFalse);
        expect(find.bySemanticsLabel('Жирный'), findsOneWidget);
      },
    );

    testWidgets('find selects the match without stealing keyboard focus', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject(), size: const Size(390, 844));
      await tester.tap(find.bySemanticsLabel('Ещё'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Найти в конспекте'));
      await tester.pumpAndSettle();
      final field = find.byType(AppSearchField);
      await tester.enterText(field, 'текст');
      await tester.pumpAndSettle();
      expect(cubit.controller.selection.start, 9);
      expect(cubit.controller.selection.end, 14);
      final input = tester.widget<EditableText>(
        find.descendant(of: field, matching: find.byType(EditableText)),
      );
      expect(input.focusNode.hasFocus, isTrue);
      expect(tester.takeException(), isNull);
    });

    for (final size in [const Size(320, 700), const Size(1200, 900)]) {
      testWidgets(
        'editor stays usable with a keyboard at $size and 200% text',
        (tester) async {
          tester.view.viewInsets = const FakeViewPadding(bottom: 300);
          await tester.pumpApp(
            buildSubject(),
            size: size,
            textScaler: const TextScaler.linear(2),
          );
          await tester.pumpAndSettle();
          final editor = tester.widget<QuillEditor>(find.byType(QuillEditor));
          expect(editor.config.enableScribble, isTrue);
          expect(editor.config.maxContentWidth, 820);
          expect(
            editor.config.contentInsertionConfiguration!.allowedMimeTypes,
            containsAll(['image/png', 'image/jpeg', 'image/webp']),
          );
          expect(
            tester.getSize(find.byType(QuillEditor)).height,
            greaterThan(80),
          );
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('hardware find shortcut opens search while editing', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject());
      await tester.tap(find.byType(QuillEditor));
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      expect(find.byType(AppSearchField), findsOneWidget);
      final input = tester.widget<EditableText>(
        find.descendant(
          of: find.byType(AppSearchField),
          matching: find.byType(EditableText),
        ),
      );
      expect(input.focusNode.hasFocus, isTrue);
      tester.testTextInput.enterText('текст');
      await tester.pump();
      expect(cubit.controller.document.toPlainText(), 'Исходный текст\n');
    });

    testWidgets('rejects missing keyboard image bytes without uploading', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject());
      final editor = tester.widget<QuillEditor>(find.byType(QuillEditor));
      editor.config.contentInsertionConfiguration!.onContentInserted(
        const KeyboardInsertedContent(
          mimeType: 'image/png',
          uri: 'content://keyboard/image',
        ),
      );
      await tester.pump();
      verifyNever(
        () => repository.uploadNoteMedia(
          bytes: any(named: 'bytes'),
          contentType: any(named: 'contentType'),
          extension: any(named: 'extension'),
        ),
      );
      expect(cubit.controller.document.toPlainText(), 'Исходный текст\n');
    });

    testWidgets('keyboard upload cannot insert into a changed document', (
      tester,
    ) async {
      final upload = Completer<String>();
      when(
        () => repository.uploadNoteMedia(
          bytes: any(named: 'bytes'),
          contentType: any(named: 'contentType'),
          extension: any(named: 'extension'),
        ),
      ).thenAnswer((_) => upload.future);
      await tester.pumpApp(buildSubject());
      final editor = tester.widget<QuillEditor>(find.byType(QuillEditor));
      editor.config.contentInsertionConfiguration!.onContentInserted(
        KeyboardInsertedContent(
          mimeType: 'image/png',
          uri: 'content://keyboard/image',
          data: Uint8List.fromList([137, 80, 78, 71, 13, 10, 26, 10]),
        ),
      );
      cubit.controller.document.insert(0, 'Новая строка ');
      upload.complete('https://example.org/image.png');
      await tester.pump();
      expect(
        cubit.controller.document.toPlainText(),
        'Новая строка Исходный текст\n',
      );
      expect(
        cubit.controller.document.toDelta().toJson().any(
          (operation) => operation['insert'] is Map,
        ),
        isFalse,
      );
      cubit.discardChanges();
    });
  });
}
