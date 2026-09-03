import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/view/collab_note_editor_view.dart';

import '../../helpers/mocks/mock_campus_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
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

    tearDown(() async => cubit.close());

    Widget buildSubject() => BlocProvider.value(
      value: cubit,
      child: const Scaffold(body: SafeArea(child: CollabNoteEditorView())),
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
      addTearDown(cubit.close);
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
      final title = tester.widget<EditableText>(
        find.byKey(const ValueKey('collab-note-title-field')),
      );
      expect(title.readOnly, isTrue);
      expect(cubit.state.readOnly, isFalse);
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
  });
}
