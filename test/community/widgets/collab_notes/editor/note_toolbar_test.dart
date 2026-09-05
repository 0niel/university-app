import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_link_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_toolbar.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_toolbar_button.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import '../../../../helpers/pump_app.dart';

class _Repository extends Mock implements CampusRepository {}

void main() {
  late NoteEditorCubit cubit;
  late FocusNode editorFocus;
  late ScrollController editorScroll;

  setUp(() {
    cubit = NoteEditorCubit(
      repository: _Repository(),
      note: const CollabNote(
        id: 'toolbar-note',
        title: 'Note',
        content: 'Alpha Beta',
        isPersonal: true,
        isMine: true,
      ),
      editorName: 'Reader',
      saveDebounce: const Duration(days: 1),
    );
    editorFocus = FocusNode();
    editorScroll = ScrollController();
  });

  tearDown(() async {
    cubit.discardChanges();
    await cubit.close();
    editorFocus.dispose();
    editorScroll.dispose();
  });

  Future<void> pump(
    WidgetTester tester, {
    Size size = const Size(320, 700),
    bool readOnly = false,
    TextScaler textScaler = TextScaler.noScaling,
  }) => tester.pumpApp(
    BlocProvider.value(
      value: cubit,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: QuillEditor(
                controller: cubit.controller,
                focusNode: editorFocus,
                scrollController: editorScroll,
              ),
            ),
            NoteToolbar(readOnly: readOnly),
          ],
        ),
      ),
    ),
    size: size,
    textScaler: textScaler,
  );

  AppLocalizations l10n(WidgetTester tester) =>
      tester.element(find.byType(NoteToolbar)).l10n;

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.pumpAndSettle();
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> openFormat(WidgetTester tester) =>
      tap(tester, find.byTooltip(l10n(tester).noteToolbarFormat));

  Future<void> openLink(WidgetTester tester) async {
    await tap(tester, find.byTooltip(l10n(tester).noteToolbarInsert));
    await tap(tester, find.text(l10n(tester).noteToolbarLink));
  }

  testWidgets('phone keeps six 44dp controls visible without scrolling', (
    tester,
  ) async {
    await pump(tester, textScaler: const TextScaler.linear(2));
    expect(find.byType(NoteToolbarButton), findsNWidgets(6));
    for (final button in find.byType(NoteToolbarButton).evaluate()) {
      final finder = find.byWidget(button.widget);
      expect(finder.hitTestable(), findsOneWidget);
      expect(tester.getSize(finder).width, greaterThanOrEqualTo(44));
      expect(tester.getSize(finder).height, greaterThanOrEqualTo(44));
    }
    expect(
      tester.getSize(find.byType(NoteToolbar)).height,
      lessThanOrEqualTo(60),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('tablet exposes media and lists directly', (tester) async {
    await pump(tester, size: const Size(800, 700));
    for (final label in [
      l10n(tester).noteToolbarImage,
      l10n(tester).noteToolbarDrawing,
      l10n(tester).noteToolbarMic,
      l10n(tester).noteToolbarChecklist,
    ]) {
      expect(find.byTooltip(label).hitTestable(), findsOneWidget);
    }
    expect(
      tester.getSize(find.byType(NoteToolbar)).height,
      lessThanOrEqualTo(60),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('quick formatting keeps selection and supports undo and redo', (
    tester,
  ) async {
    await pump(tester);
    editorFocus.requestFocus();
    cubit.controller.updateSelection(
      const TextSelection(baseOffset: 0, extentOffset: 5),
      ChangeSource.local,
    );
    await tap(tester, find.byTooltip(l10n(tester).noteToolbarBold));
    expect(
      cubit.controller.getSelectionStyle().attributes[Attribute.bold.key],
      Attribute.bold,
    );
    expect(
      cubit.controller.selection,
      const TextSelection(baseOffset: 0, extentOffset: 5),
    );
    expect(editorFocus.hasFocus, isTrue);
    await tap(tester, find.byTooltip(l10n(tester).noteToolbarUndo));
    expect(
      cubit.controller.document.toDelta().toJson().first['attributes'],
      isNull,
    );
    await tap(tester, find.byTooltip(l10n(tester).noteToolbarRedo));
    expect(
      cubit.controller.document.toDelta().toJson().first['attributes'],
      containsPair('bold', true),
    );
  });

  testWidgets(
    'link follows original text when content and selection change in sheet',
    (
      tester,
    ) async {
      await pump(tester);
      cubit.controller.updateSelection(
        const TextSelection(baseOffset: 0, extentOffset: 5),
        ChangeSource.local,
      );
      await openLink(tester);
      cubit.controller.document.insert(0, 'Prefix ');
      cubit.controller.updateSelection(
        const TextSelection.collapsed(offset: 10),
        ChangeSource.local,
      );
      await tester.enterText(find.byType(TextField), 'docs.mirea.ninja');
      await tap(tester, find.text(l10n(tester).noteLinkInsert));
      final operations = cubit.controller.document.toDelta().toJson();
      expect(operations.first['insert'], 'Prefix ');
      final first = operations[1];
      expect(first['insert'], 'Alpha');
      expect(
        first['attributes'],
        containsPair('link', 'https://docs.mirea.ninja'),
      );
    },
  );

  testWidgets(
    'cancel color sheet preserves color and explicit reset removes it',
    (
      tester,
    ) async {
      await pump(tester);
      cubit.controller.updateSelection(
        const TextSelection(baseOffset: 0, extentOffset: 5),
        ChangeSource.local,
      );
      cubit.controller.formatSelection(const ColorAttribute('#ef4444'));
      await openFormat(tester);
      await tap(tester, find.text(l10n(tester).noteToolbarColor));
      final ink = tester.element(find.byType(AppColorPalette)).colors.ink;
      await tap(
        tester,
        find.byKey(ValueKey('app-color-swatch-${ink.toARGB32()}')),
      );
      await tap(tester, find.byType(AppSheetCloseButton));
      expect(
        cubit.controller
            .getSelectionStyle()
            .attributes[Attribute.color.key]
            ?.value,
        '#ef4444',
      );
      await openFormat(tester);
      await tap(tester, find.text(l10n(tester).noteToolbarColor));
      await tap(tester, find.text(l10n(tester).noteColorDefault));
      expect(
        cubit.controller.getSelectionStyle().attributes[Attribute.color.key],
        isNull,
      );
    },
  );

  testWidgets('read only toolbar prevents actions and pending link mutations', (
    tester,
  ) async {
    await pump(tester, readOnly: true);
    expect(
      tester
          .widgetList<AppIconButton>(find.byType(AppIconButton))
          .every((button) => button.onPressed == null),
      isTrue,
    );
    await pump(tester);
    await openLink(tester);
    cubit.controller.readOnly = true;
    await tester.enterText(find.byType(TextField).first, 'https://mirea.ninja');
    await tap(tester, find.text(l10n(tester).noteLinkInsert));
    expect(cubit.controller.document.toPlainText(), 'Alpha Beta\n');
    expect(
      cubit.controller.document.toDelta().toJson().first['attributes'],
      isNull,
    );
  });

  testWidgets('link rejects unsafe URL and keyboard submit inserts valid URL', (
    tester,
  ) async {
    await pump(tester);
    cubit.controller.updateSelection(
      const TextSelection(baseOffset: 0, extentOffset: 5),
      ChangeSource.local,
    );
    await openLink(tester);
    await tester.enterText(find.byType(TextField), 'javascript:alert(1)');
    await tap(tester, find.text(l10n(tester).noteLinkInsert));
    expect(find.text(l10n(tester).noteLinkInvalidUrl), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'https://mirea.ninja');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
    expect(
      cubit.controller.document.toDelta().toJson().first['attributes'],
      containsPair('link', 'https://mirea.ninja'),
    );
  });

  test(
    'manual links normalize website names '
    'and allow deliberate mail and phone targets',
    () {
      expect(
        normalizeNoteLink(' docs.mirea.ninja/path '),
        'https://docs.mirea.ninja/path',
      );
      expect(
        normalizeNoteLink('mailto:hello@mirea.ninja'),
        'mailto:hello@mirea.ninja',
      );
      expect(normalizeNoteLink('tel:+79990000000'), 'tel:+79990000000');
      for (final value in [
        '',
        'https://',
        'data:text/html,test',
        'file:///tmp/x',
        'not a url',
      ]) {
        expect(normalizeNoteLink(value), isNull);
      }
    },
  );
}
