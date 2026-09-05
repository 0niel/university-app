import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/view/collab_note_editor_view.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_outline.dart';

import '../../helpers/mocks/mock_campus_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('CollabNoteEditorView nested navigation', () {
    late NoteEditorCubit cubit;
    late GlobalKey<NavigatorState> branchNavigator;

    setUp(() {
      branchNavigator = GlobalKey<NavigatorState>();
      cubit = NoteEditorCubit(
        repository: MockCampusRepository(),
        note: const CollabNote(
          id: 'note-navigation',
          title: 'Алгоритмы',
          isMine: true,
          isPersonal: true,
          document: [
            {'insert': 'Введение\n'},
            {'insert': 'Раздел второй'},
            {
              'insert': '\n',
              'attributes': {'header': 2},
            },
            {'insert': 'Текст раздела\n'},
          ],
        ),
        editorName: 'Alex',
        saveDebounce: const Duration(days: 1),
      );
    });

    tearDown(() async => cubit.close());

    Future<void> openEditor(WidgetTester tester) async {
      await tester.pumpApp(
        Navigator(
          key: branchNavigator,
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider.value(
                      value: cubit,
                      child: const Scaffold(
                        body: SafeArea(child: CollabNoteEditorView()),
                      ),
                    ),
                  ),
                ),
                child: const Text('Открыть конспект'),
              ),
            ),
          ),
        ),
        size: const Size(390, 844),
      );
      await tester.tap(find.text('Открыть конспект'));
      await tester.pumpAndSettle();
      expect(branchNavigator.currentState!.canPop(), isTrue);
    }

    Future<void> openMore(WidgetTester tester) async {
      await tester.tap(find.bySemanticsLabel('Ещё'));
      await tester.pumpAndSettle();
      expect(find.byType(AppSheet), findsOneWidget);
      expect(
        Navigator.of(
          branchNavigator.currentContext!,
          rootNavigator: true,
        ).canPop(),
        isTrue,
      );
    }

    void expectEditorRetained(WidgetTester tester) {
      expect(tester.takeException(), isNull);
      expect(find.byType(CollabNoteEditorView), findsOneWidget);
      expect(branchNavigator.currentState!.canPop(), isTrue);
      expect(find.text('Открыть конспект'), findsNothing);
      expect(find.byType(AppSheet), findsNothing);
      expect(
        Navigator.of(
          branchNavigator.currentContext!,
          rootNavigator: true,
        ).canPop(),
        isFalse,
      );
    }

    testWidgets('More search closes only the root sheet', (tester) async {
      await openEditor(tester);
      await openMore(tester);
      await tester.tap(find.text('Найти в конспекте'));
      await tester.pumpAndSettle();

      expectEditorRetained(tester);
      expect(find.byType(AppSearchField), findsOneWidget);
      expect(cubit.controller.readOnly, isFalse);
    });

    testWidgets('More reading closes only the root sheet', (tester) async {
      await openEditor(tester);
      await openMore(tester);
      await tester.tap(
        find.descendant(
          of: find.byType(AppSheet),
          matching: find.text('Режим чтения'),
        ),
      );
      await tester.pumpAndSettle();

      expectEditorRetained(tester);
      expect(cubit.controller.readOnly, isTrue);
      expect(find.bySemanticsLabel('Жирный'), findsNothing);
    });

    testWidgets(
      'outline selection closes the root sheet and moves the cursor',
      (
        tester,
      ) async {
        await openEditor(tester);
        await openMore(tester);
        await tester.tap(find.text('Оглавление'));
        await tester.pumpAndSettle();
        expect(find.byType(NoteOutline), findsOneWidget);
        expect(find.byType(AppSheet), findsOneWidget);

        await tester.tap(
          find.descendant(
            of: find.byType(NoteOutline),
            matching: find.text('Раздел второй'),
          ),
        );
        await tester.pumpAndSettle();

        expectEditorRetained(tester);
        expect(find.byType(NoteOutline), findsNothing);
        expect(
          cubit.controller.selection,
          const TextSelection.collapsed(offset: 9),
        );
      },
    );
  });
}
