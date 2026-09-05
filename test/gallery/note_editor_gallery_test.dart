@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/view/collab_note_editor_view.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import '../helpers/mocks/mock_campus_repository.dart';
import 'gallery_fonts.dart';

void main() {
  setUpAll(loadGalleryFonts);
  for (final tablet in [false, true]) {
    testWidgets('note editor ${tablet ? 'tablet' : 'phone'}', (tester) async {
      tester.view
        ..physicalSize = tablet ? const Size(1200, 900) : const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final cubit = NoteEditorCubit(
        repository: MockCampusRepository(),
        editorName: 'Алексей',
        note: const CollabNote(
          id: 'gallery-note',
          title: 'Алгоритмы и структуры данных',
          isMine: true,
          isPersonal: true,
          document: [
            {'insert': 'Лекция 4 · Графы'},
            {
              'insert': '\n',
              'attributes': {'header': 1},
            },
            {
              'insert':
                  'Граф состоит из вершин и рёбер. Он помогает описать '
                  'связи: от маршрутов между корпусами '
                  'до зависимостей задач.\n\n',
            },
            {'insert': 'Обход в ширину'},
            {
              'insert': '\n',
              'attributes': {'header': 2},
            },
            {
              'insert': 'BFS',
              'attributes': {'bold': true},
            },
            {
              'insert':
                  ' посещает вершины по уровням. Используем очередь '
                  'и множество посещённых вершин.\n',
            },
            {'insert': 'Добавить начальную вершину в очередь'},
            {
              'insert': '\n',
              'attributes': {'list': 'checked'},
            },
            {'insert': 'Посетить всех соседей'},
            {
              'insert': '\n',
              'attributes': {'list': 'unchecked'},
            },
            {'insert': 'Повторить, пока очередь не пуста'},
            {
              'insert': '\n',
              'attributes': {'list': 'unchecked'},
            },
            {'insert': '\nВремя работы'},
            {
              'insert': '\n',
              'attributes': {'header': 2},
            },
            {
              'insert': 'O(V + E)',
              'attributes': {'code': true},
            },
            {'insert': ' — каждую вершину и ребро обрабатываем один раз.\n\n'},
            {'insert': 'К следующей паре'},
            {
              'insert': '\n',
              'attributes': {'header': 2},
            },
            {'insert': 'Сравнить BFS и DFS на примере карты кампуса.\n'},
          ],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: tablet ? AppTheme.darkTheme : AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider.value(
            value: cubit,
            child: const Scaffold(
              body: SafeArea(child: CollabNoteEditorView()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      if (tablet) {
        await tester.tap(find.bySemanticsLabel('Ещё'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Оглавление'));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/note_editor_${tablet ? 'tablet' : 'phone'}.png',
        ),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(cubit.close);
    });
  }
}
